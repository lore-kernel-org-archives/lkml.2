Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab2KWCeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 21:34:23 -0500
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:34204 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752823Ab2KWCeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 21:34:22 -0500
Message-ID: <50AEDF00.7060709@marvell.com>
Date: Fri, 23 Nov 2012 10:27:12 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: max8925: fix compiler warnings
References: <1353550266-21330-1-git-send-email-qingx@marvell.com> <20121123014135.GC4385@opensource.wolfsonmicro.com>
In-Reply-To: <20121123014135.GC4385@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Nov 2012 02:25:49.0391 (UTC) FILETIME=[DA1ADDF0:01CDC921]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 09:41 AM, Mark Brown wrote:
> On Thu, Nov 22, 2012 at 10:11:06AM +0800, Qing Xu wrote:
>
>> -	int i, regulator_idx;
>> +	int i;
>> +	int regulator_idx = 0;
> This sort of fix is rarely good without some analysis as to why this is
> a sensible initialisation to do, just unconditionally initialising may
> be masking a real issue in the control flow which the compiler has
> identified.
In my build environment, there is no such compiler warning. :(

Adding this patch is just want to avoid kbuild test robot's warning.
But, in fact, it is not necessary to initialize regulator_idx.


         for (i = 0; i < ARRAY_SIZE(max8925_regulator_info); i++) {
                 ri = &max8925_regulator_info[i];
                 if (ri->vol_reg == res->start) {

****** if regulator_idx can not get a match "i" here, it will return
-EINVAL in below code

                         regulator_idx = i;
                         break;
                 }
         }

         if (i == ARRAY_SIZE(max8925_regulator_info)) {
                 dev_err(&pdev->dev, "Failed to find regulator %llu\n",
                         (unsigned long long)res->start);
                 return -EINVAL;
         }

How to solve such compiler warning?

