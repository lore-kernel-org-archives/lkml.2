Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab0HTWzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 18:55:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52659 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab0HTWzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 18:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=re6rxNJhN7Jivdw2EXaq2dI5JM6fUrj6utugmbbEZYQ3KmKcEfYTLF5oEfLhJwxcZ9
         oKJhpv2eSyG7VkIQYFuzTxsTEWNrgHV/k3IlUsSSsHF/WrADc+W2nAc63Z7rRbe5nILf
         HYRwMgf7KLTT/pjgrIp3dlDiyahmyIBAmOWWI=
MIME-Version: 1.0
In-Reply-To: <4C6E9B75.8030004@arndnet.de>
References: <4C455597.2020200@renesas.com>
	<4C6E9B75.8030004@arndnet.de>
Date: Sat, 21 Aug 2010 07:55:38 +0900
Message-ID: <AANLkTik9nnHiOL61ioT-1Eti9-DfKnDYY=qKespaOKje@mail.gmail.com>
Subject: Re: [PATCH] tmio_mmc: Make ack_mmc_irqs() write-only
From: Magnus Damm <magnus.damm@gmail.com>
To: Arnd Hannemann <arnd@arndnet.de>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Yusuke Goda <yusuke.goda.sx@renesas.com>, ian@mnementh.co.uk,
        damm@opensource.se, sameo@linux.intel.com,
        Paul Mundt <lethal@linux-sh.org>, g.liakhovetski@gmx.de,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 12:12 AM, Arnd Hannemann <arnd@arndnet.de> wrote:
> Am 20.07.2010 09:51, schrieb Yusuke Goda:
>> This patch updates ack_mmc_irqs() to acknowledge using write instead
>> of read-modify-write. Without this fix the old read-modify-write
>> implementation may acknowledge interrupt sources by mistake. The
>> driver may if so lock-up waiting forever for an interrupt that will
>> never come. Observed with the TMIO_STAT_RXRDY bit together with
>> CMD53 on AR6002 and BCM4318 SDIO cards in polled mode.
>>
>> Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
>
> Tested on AP4EVB (sh7372) with SDHC and MMC cards - no regression.
>
> Tested-by: Arnd Hannemann <arnd@arndnet.de>

Thanks, Arnd!

Andrew, is there anything you need to (re)pick-up this patch?

At the current point this patch has:
Signed-off-by: Yusuke Goda <yusuke.goda.sx@renesas.com>
Acked-by: Magnus Damm <damm@opensource.se>
Tested-by: Arnd Hannemann <arnd@arndnet.de>

Ian Molton also gave his "Acked-by" in a different email thread,
please see below:
On Tue, Jul 27, 2010 at 5:11 PM, Ian Molton <ian@mnementh.co.uk> wrote:
> Right now, the docs in question are on my dead fileserver.
>
> Given that, I'll say two things:
>
> 1) Its safe to assume anywhere that does a RMW does it because my
> original docs said so. I dont recall having ever "just done it because
> I had to" when I wrote this.
> 2) The code as is is clearly broken.
>
> I'm not really sure what to do about this. It got made 'doubly broken'
> when we added asic3 support because it was the first platform added
> where you couldnt just do a 32 bit RMW on the pair of registers.
>
> I'm inclined to say "Go Go Go" and see if anything breaks on this one.
> I cant see why the docs want it to be RMW as theres nothing stopping
> the hardware asserting an IRQ even if the CPU disables IRQs / did the
> RMW as an atomic op.
>
> This one therefore,
>
> Acked-by: Ian Molton <ian@mnementh.co.uk>

Thanks for the help everyone and sorry about the confused state of things.

/ magnus
