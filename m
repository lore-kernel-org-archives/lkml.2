Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab2KCEtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 00:49:35 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44346 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893Ab2KCEtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 00:49:33 -0400
Date: Sat, 3 Nov 2012 05:49:29 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD A10: MCE Instruction Cache Error
Message-ID: <20121103044929.GB21829@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alexander Holler <holler@ahsoftware.de>,
	linux-kernel@vger.kernel.org
References: <5093A592.9070605@ahsoftware.de>
 <5093D069.20901@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5093D069.20901@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 02, 2012 at 02:53:45PM +0100, Alexander Holler wrote:
> Am 02.11.2012 11:50, schrieb Alexander Holler:
> >Hello,
> >
> >I've just got the following on an AMD A10 5800K:
> >
> >------
> >[ 8395.999581] [Hardware Error]: CPU:0
> >MC1_STATUS[-|CE|MiscV|-|AddrV|-|-]: 0x8c00002000010151
> >[ 8395.999586] [Hardware Error]:        MC1_ADDR: 0x0000ffffa00e1203
> >[ 8395.999588] [Hardware Error]: Instruction Cache Error: Parity error
> >during data load from IC.
> >[ 8395.999590] [Hardware Error]: cache level: L1, tx: INSN, mem-tx: IRD
> >------
> >
> >Kernel is 3.6.5, MB is an Asus F2A85-M with BIOS 5103 (the latest).
> >
> >Can someone enlight me about what might be wrong with my (new) system
> >(memtest didn't show an errors)?
> >
> >What IC is meant? As far as I know, this processor doesn't support ECC,
> >so I wonder where that parity error does come from.
> 
> I assume IC means Instruction Cache. ;)

It says so earlier in the sentence: "Instruction Cache Error" :)

> As the kernel didn't reboot or halt, this seems to have been a
> correctable error.

Yes, it is (the "CE" bit in MC1_STATUS). Btw, I have reworked this code
to spit human-readable information first. It also says what the error
severity is now.

> Which leads me to another question. I have mcelog running, but it
> doesn't seem to receive the error. With my previous Intel-HW and an
> older kernel, mcelog received MCE errors (trip temperatur). But
> since the kernel now decodes those message themself, that doesn't
> seem to happen anymore. mcelog is silent, but now I've seen the
> above message on all my consoles.

Yes, AMD doesn't use mcelog.

> So now I have two question:
> 
> - First, if the error is something I should ask AMD about,

Not really, it is a single bit flip which got corrected, simply watch
out if you get more of those.

> - Second, if the kernel could mention that it is an recoverable
> error. And if so and if such errors aren't something to get panic
> (e.g. it isn't unusual to receive such), if the kernel could output
> that message with another priority.

As I said above, it got corrected. If it were critical, it would've
either panicked or you wouldnt've seen it at all (probably only after
reboot).

HTH.

-- 
Regards/Gruss,
    Boris.
