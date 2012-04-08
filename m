Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2DHXYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:24:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54275 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab2DHXYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:24:09 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1333921246.2508.8.camel@joe2Laptop>
References: <1333919920-25481-1-git-send-email-olof@lixom.net>
	<1333921246.2508.8.camel@joe2Laptop>
Date: Sun, 8 Apr 2012 16:24:08 -0700
Message-ID: <CAOesGMgav3iqqNBtc1DccKKvRSpnNnDaCZmKBsdHj4feq-ns_A@mail.gmail.com>
Subject: Re: [PATCH] dma: pl330: fix a couple of compilation warnings
From: Olof Johansson <olof@lixom.net>
To: Joe Perches <joe@perches.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org, Boojin Kim <boojin.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 8, 2012 at 2:40 PM, Joe Perches <joe@perches.com> wrote:
> On Sun, 2012-04-08 at 14:18 -0700, Olof Johansson wrote:
>> Move a couple of tests and do a minor refactor to avoid:
> []
>> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> []
>> @@ -2926,8 +2928,9 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
>>       INIT_LIST_HEAD(&pd->channels);
>>
>>       /* Initialize channel parameters */
>> -     num_chan = max(pdat ? pdat->nr_valid_peri : (u8)pi->pcfg.num_peri,
>> -                     (u8)pi->pcfg.num_chan);
>> +     num_chan = max_t(int, pdat ? pdat->nr_valid_peri :
>> +                                  pi->pcfg.num_peri,
>> +                           pi->pcfg.num_chan);
>>       pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
>
> Few trivial things:
>
> There's no error checking for a malloc failure
> This should probably be kcalloc

Yes, this driver could do with further cleanups, congratulations on
your observations.

All of that is completely unrelated to this patch. Feel free to submit
your own changes to clean up the driver further.

> The alignment here is not nice

Bikeshed much? Let's just remove the ? : instead then. New patch shortly.


-Olof
