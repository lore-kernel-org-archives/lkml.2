Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab2KZDGB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 22:06:01 -0500
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:57228 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753649Ab2KZDGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 22:06:00 -0500
Message-ID: <50B2DCED.5080509@marvell.com>
Date: Mon, 26 Nov 2012 11:07:25 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: max8925: fix compiler warnings
References: <1353550266-21330-1-git-send-email-qingx@marvell.com> <20121123014135.GC4385@opensource.wolfsonmicro.com> <50AEDF00.7060709@marvell.com> <20121124175554.GF4719@opensource.wolfsonmicro.com>
In-Reply-To: <20121124175554.GF4719@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Nov 2012 03:05:55.0275 (UTC) FILETIME=[F35CE1B0:01CDCB82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2012 01:55 AM, Mark Brown wrote:
> On Fri, Nov 23, 2012 at 10:27:12AM +0800, Qing Xu wrote:
>
>> But, in fact, it is not necessary to initialize regulator_idx.
>>          for (i = 0; i < ARRAY_SIZE(max8925_regulator_info); i++) {
>>                  ri = &max8925_regulator_info[i];
>>                  if (ri->vol_reg == res->start) {
>> ****** if regulator_idx can not get a match "i" here, it will return
>> -EINVAL in below code
>>                          regulator_idx = i;
>>                          break;
>>                  }
>>          }
>>          if (i == ARRAY_SIZE(max8925_regulator_info)) {
>>                  dev_err(&pdev->dev, "Failed to find regulator %llu\n",
>>                          (unsigned long long)res->start);
>>                  return -EINVAL;
>>          }
>> How to solve such compiler warning?
> Typically by reporting a compiler bug, though sometimes in the process
> of doing that one finds out that there's some non-obvious way in which
> the code can break.

It seems not like a compiler bug, its logic is:

for(...; i<xxx; ...) {
     if (...) {
         regulator_idx = i
         break;
     }
}

if (i == xxx)
     return ERROR;

If regulator_idx can not get a matched "i" value, code will return ERROR.
But it seems that compiler can not do so complex judge.
And, I think the code is safe even if regulator_idx is not initialized, also
because of the "return ERROR" judge.



