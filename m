Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116Ab1LNUPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:15:20 -0500
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:53775
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757976Ab1LNUPQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:15:16 -0500
X-SpamScore: -14
X-BigFish: VS-14(zzbb2dI9371Ic89bh936eK1432N98dKzz1202hzzz2dh2a8h668h839h93fh)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4EE903CE.1010903@freescale.com>
Date: Wed, 14 Dec 2011 14:15:10 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: LiuShuo <b35362@freescale.com>
CC: <dedekind1@gmail.com>, <shuo.liu@freescale.com>, <dwmw2@infradead.org>,
        <Artem.Bityutskiy@nokia.com>, <linux-mtd@lists.infradead.org>,
        <linuxppc-dev@lists.ozlabs.org>, <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: Re: [PATCH 3/3] mtd/nand : workaround for Freescale FCM to support
 large-page Nand chip
References: <1322973098-2528-1-git-send-email-shuo.liu@freescale.com>   <1322973098-2528-3-git-send-email-shuo.liu@freescale.com>   <4EDEAEB9.6020703@freescale.com> <1323724195.2297.11.camel@koala>  <4EE66EFE.1050608@freescale.com> <1323724784.2297.20.camel@koala> <4EE6725C.3050706@freescale.com> <4EE6BC9B.4000602@freescale.com> <4EE8612C.9050104@freescale.com>
In-Reply-To: <4EE8612C.9050104@freescale.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2011 02:41 AM, LiuShuo wrote:
> 于 2011年12月13日 10:46, LiuShuo 写道:
>> 于 2011年12月13日 05:30, Scott Wood 写道:
>>> On 12/12/2011 03:19 PM, Artem Bityutskiy wrote:
>>>> On Mon, 2011-12-12 at 15:15 -0600, Scott Wood wrote:
>>>>> NAND chips come from the factory with bad blocks marked at a certain
>>>>> offset into each page.  This offset is normally in the OOB area, but
>>>>> since we change the layout from "4k data, 128 byte oob" to "2k
>>>>> data, 64
>>>>> byte oob, 2k data, 64 byte oob" the marker is no longer in the
>>>>> oob.  On
>>>>> first use we need to migrate the markers so that they are still in
>>>>> the oob.
>>>> Ah, I see, thanks. Are you planning to implement in-kernel migration or
>>>> use a user-space tool?
>>> That's the kind of answer I was hoping to get from Shuo. :-)
>> OK, I try to do this. Wait for a couple of days.
>>
>> -LiuShuo
> I found it's too complex to do the migration in Linux driver.
> 
> Maybe we can add a uboot command (e.g. nand bbmigrate) to do it, once is
> enough.

Any reason not to do it automatically on the first U-Boot bad block
scan, if the flash isn't marked as already migrated?

Further discussion on the details of how to do it in U-Boot should move
to the U-Boot list.

> And let user ensure it been completed before linux use the Nand flash chip.

I don't want to trust the user here.  It's too easy to skip it, and
things will appear to work, but have subtle problems.

> Even if we don't do the migration, the bad block also can be marked as bad
> by wearing. So, do we really need to take much time to implement it ?
> (code looks too complex.)

It is not acceptable to ignore factory bad block markers just because
some methods of using the flash may eventually detect an error (possibly
after data is lost -- no guarantee that the badness is ECC-correctable)
and mark the block bad again.

If you don't feel up to the task, I can look at it, but won't have time
until January.

-Scott

