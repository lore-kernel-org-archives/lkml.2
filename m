Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1GZSNA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:13:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38014 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab1GZSMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:12:55 -0400
MIME-Version: 1.0
In-Reply-To: <CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
References: <1311185906-7813-1-git-send-email-jaswinder.singh@linaro.org>
	<1311220903-2545-1-git-send-email-jaswinder.singh@linaro.org>
	<CACRpkdbWHmob3EWJc6u5=yh=rNwVSR5hu9-Xud5kvQNU9-POtA@mail.gmail.com>
	<CAJe_Zhc4uJB8N9i2w38zzP3+XxcYF2v-zwsrhERWSi-yObV-6A@mail.gmail.com>
	<CABE8wwt7dkwgeahYBSUufOvJmVNfYyTss6U5qBgjJk9RVLBkYg@mail.gmail.com>
	<CAJe_ZhdYg4EpaNbBW+dayjSORqM=E6myT3oOG5VTsiQnh3erTA@mail.gmail.com>
	<CABE8wwt8J_r9cExG+EAqqK=XVmAyLYhv+-T49Rr9hhKudD8n2g@mail.gmail.com>
	<CAJe_ZheVyLk-yqyF_XO80xX3j7_7mDPnv-me+n=X_hNWycSLwg@mail.gmail.com>
	<CABE8wwtkSnaJ5fvi=4bq7zye3W0SmErHAZeWAcHuYvLgvqy=_Q@mail.gmail.com>
	<CAJe_ZhfYvd6mdUMtzdAKKk4o1ythCBm7rut7ZCWRTxiWLP__Tg@mail.gmail.com>
	<CABE8wwv2XQ_aJ8O2TUAz1LgJorBwDbgyQQv7jeAn06Q2AcqH+Q@mail.gmail.com>
Date: Tue, 26 Jul 2011 23:42:54 +0530
Message-ID: <CAJe_ZhcNM7m-eWA0nDUrOrHxeAhNS00gewf=txmvOFL_uOPhrw@mail.gmail.com>
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

On 26 July 2011 20:59, Williams, Dan J <dan.j.williams@intel.com> wrote:
> On Tue, Jul 26, 2011 at 7:30 AM, Jaswinder Singh
> <jaswinder.singh@linaro.org> wrote:
>> On 26 July 2011 01:38, Williams, Dan J <dan.j.williams@intel.com> wrote:
>>> Correct, it is meant that chan_id is only a sysfs property.  Any
>>> driver usage that is assuming chan_id is anything more than a
>>> guaranteed unique number within a given dma_device's list of channels
>>> is probably inferring too much.
>>
>> So you mean dmac/client drivers are wrong if they make use of chan_id.
>> They shouldn't count upon it's value - which is set by DMA API for a completely
>> independent purpose, i.e, creating contiguous sysfs entries.
>
> They can count on it being unique, and maybe the fact that it is in
> the same order as dma_device.channels.
The latter implies the former. And it is already the dmac driver that
decides the
rank of a channel in the list.

>
>>
>> Since "chan_id is only a sysfs property" and the fact that it is used
>> only _once_
>> by the DMA API
>>
>> In drivers/dma/dmaengine.c
>>
>>      chan->chan_id = chancnt++;
>>      dev_set_name(&chan->dev->device, "dma%dchan%d",
>>                             device->dev_id, chan->chan_id);
>>
>>
>> Can't we do away with chan_id altogether ? by having
>>
>>      dev_set_name(&chan->dev->device, "dma%dchan%d",
>>                             device->dev_id, chancnt++);
>>
>> I mean why make every instance of dma_chan bigger by 4bytes ?
>>
>> So why shouldn't we remove chan_id completely from the DMA API ?
>
> Good point...  Let's remove chan_id from the core and push it into the
> drivers that need it.
>
If you agree, I would preserve the chan_id in 'struct dma_chan' but remove
any assignment to it in dmaengine.c  and let the dmac drivers use it freely.
That would:-
a) Let dmac drivers decide what numbers they want to show up in sysfs.
b) chan_id is easily reachable by client drivers, so it is better this way.
c) It would mean lesser and simpler changes to extant users of it.

Thanks,
-Jassi

-- 
Linaro.org │ Open source software for ARM SoCs | Follow Linaro
http://facebook.com/pages/Linaro/155974581091106  -
http://twitter.com/#!/linaroorg - http://linaro.org/linaro-blog
