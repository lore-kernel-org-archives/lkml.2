Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1KXJ66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:58:58 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:37579
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754941Ab1KXJ64 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:58:56 -0500
X-SpamScore: -12
X-BigFish: VS-12(zzc89bh936eK1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4ECE162D.7080408@freescale.com>
Date: Thu, 24 Nov 2011 18:02:21 +0800
From: LiuShuo <b35362@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Li Yang-R58472 <r58472@freescale.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "Artem.Bityutskiy@nokia.com" <Artem.Bityutskiy@nokia.com>,
        Wood Scott-B07421 <B07421@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322095306-13156-1-git-send-email-b35362@freescale.com>	 <1322095306-13156-3-git-send-email-b35362@freescale.com>	 <1322120515.24797.296.camel@sauron.fi.intel.com>	 <3F607A5180246847A760FD34122A1E052DC61F@039-SN1MPN1-003.039d.mgd.msft.net> <1322122592.24797.299.camel@sauron.fi.intel.com>
In-Reply-To: <1322122592.24797.299.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月24日 16:16, Artem Bityutskiy 写道:
> On Thu, 2011-11-24 at 07:49 +0000, Li Yang-R58472 wrote:
>>> Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
>>> large-page Nand chip
>>>
>>> On Thu, 2011-11-24 at 08:41 +0800, b35362@freescale.com wrote:
>>>> +               /*
>>>> +                * Freescale FCM controller has a 2K size limitation of buffer
>>>> +                * RAM, so elbc_fcm_ctrl->buffer have to be used if writesize
>>>> +                * of chip is greater than 2048.
>>>> +                * We malloc a large enough buffer (maximum page size is
>>> 16K).
>>>> +                */
>>>> +               elbc_fcm_ctrl->buffer = kmalloc(1024 * 16 + 1024,
>>> GFP_KERNEL);
>>>
>>> Are there NANDs with 16KiB page size?
>> We are not sure, but are there possibility that chip with 16K page will appear?  Or maybe we can add a MACRO for the maximum page size?
> I do not know, but I know that allocating 32KiB of contiguous physical
> RAM may cause unneeded memory pressure and even fail if the memory is
> too fragmented. So I would not go for this unless this is necessary.
What is your suggestion ? 8k is enough ?
> Did you try to look how the NAND base interface could be changed to
> avoid re-allocation altogether, BTW?
This buffer is a controller-wide resource( as Scott said), I only 
allocate buffer one time in this version.
It should be a large enough buffer for all chips.

-Liu Shuo

