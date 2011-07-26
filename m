Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab1GZOaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:30:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42635 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab1GZOaR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
References: <1311185906-7813-1-git-send-email-jaswinder.singh@linaro.org>
	<1311220903-2545-1-git-send-email-jaswinder.singh@linaro.org>
	<CACRpkdbWHmob3EWJc6u5=yh=rNwVSR5hu9-Xud5kvQNU9-POtA@mail.gmail.com>
	<CAJe_Zhc4uJB8N9i2w38zzP3+XxcYF2v-zwsrhERWSi-yObV-6A@mail.gmail.com>
	<CABE8wwt7dkwgeahYBSUufOvJmVNfYyTss6U5qBgjJk9RVLBkYg@mail.gmail.com>
	<CAJe_ZhdYg4EpaNbBW+dayjSORqM=E6myT3oOG5VTsiQnh3erTA@mail.gmail.com>
	<CABE8wwt8J_r9cExG+EAqqK=XVmAyLYhv+-T49Rr9hhKudD8n2g@mail.gmail.com>
	<CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com>
	<CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
Date: Tue, 26 Jul 2011 20:00:16 +0530
Message-ID: <CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
Subject: Re: [PATCHv2] DMAEngine: Let dmac drivers to set chan_id
From: Jaswinder Singh <jaswinder.singh@linaro.org>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        vinod.koul@intel.com, rmk+kernel@arm.linux.org.uk,
        linus.walleij@stericsson.com, per.friden@stericsson.com,
        wei.zhang@freescale.com, ebony.zhu@freescale.com, iws@ovro.caltech.edu,
        s.hauer@pengutronix.de, maciej.sosnowski@intel.com, saeed@marvell.com,
        shawn.guo@freescale.com, yur@emcraft.com, agust@denx.de,
        iwamatsu.nobuhiro@renesas.com, per.forlin@stericsson.com,
        jonas.aberg@stericsson.com, anemo@mba.ocn.ne.jp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 July 2011 01:38, Williams, Dan J <dan.j.williams@intel.com> wrote:

>>> I can sort of see why it is attractive for the goal of having clients
>>> being able to talk to multiple DMACs since it is a field that all
>>> channels already implement.  But, I don't think we should be mixing
>>> sysfs presentation details with a capability that indicates a certain
>>> compatibility level in a DMAC driver implementation.  If the goal is
>>> to be able to use a single client with multiple drivers that, to me,
>>> is asking for a new capability bit (dma_transaction_type) rather than
>>> an id.  Do you have an example of the client and the DMACs that would
>>> first take advantage of such a cross DMAC compatibility?
>>>
>> Apparently I fail to explain my well. let me ask you this....
>>
>> Some DMAC drivers initialize chan_id before calling dma_async_device_register().
>> And dma_async_device_register() overwrites the chan_id _always_.
>>
>> Clearly only _one_ of them should be setting chan_id. Which was meant to be?
>
> Correct, it is meant that chan_id is only a sysfs property.  Any
> driver usage that is assuming chan_id is anything more than a
> guaranteed unique number within a given dma_device's list of channels
> is probably inferring too much.

So you mean dmac/client drivers are wrong if they make use of chan_id.
They shouldn't count upon it's value - which is set by DMA API for a completely
independent purpose, i.e, creating contiguous sysfs entries.

Since "chan_id is only a sysfs property" and the fact that it is used
only _once_
by the DMA API

In drivers/dma/dmaengine.c

      chan->chan_id = chancnt++;
      dev_set_name(&chan->dev->device, "dma%dchan%d",
                             device->dev_id, chan->chan_id);


Can't we do away with chan_id altogether ? by having

      dev_set_name(&chan->dev->device, "dma%dchan%d",
                             device->dev_id, chancnt++);

I mean why make every instance of dma_chan bigger by 4bytes ?

So why shouldn't we remove chan_id completely from the DMA API ?

Thanks,
Jassi


-- 
Linaro.org │ Open source software for ARM SoCs | Follow Linaro
http://facebook.com/pages/Linaro/155974581091106  -
http://twitter.com/#!/linaroorg - http://linaro.org/linaro-blog
