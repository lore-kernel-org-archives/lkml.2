Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1EHTAX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 15:00:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46959 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202Ab1EHTAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 15:00:22 -0400
Date: Sun, 8 May 2011 21:00:15 +0200
From: Borislav Petkov <bp@alien8.de>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD C1E issue?   2.6.38.4
Message-ID: <20110508190015.GA29389@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
References: <4DC54CE5.6050307@xs4all.nl>
 <20110507162130.GA13307@liondog.tnic>
 <4DC57392.8010902@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DC57392.8010902@xs4all.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(you've dropped the cc list, please hit "reply-to-all" when replying to
those mails.

On Sat, May 07, 2011 at 06:30:10PM +0200, Udo van den Heuvel wrote:
> On 2011-05-07 18:21, Borislav Petkov wrote:
> >> Saw these in my messages after enabling C1E on my new Jetway Mini-ITX board:
> >>
> >> # microcode_ctl -u
> >> microcode_ctl: writing microcode (length: 430080)
> >> microcode_ctl: error writing to '/dev/cpu/microcode' errno=22 (Invalid
> >> argument)
> >> microcode_ctl: there may be messages from the driver in your system log.
> >>
> >> microcode: AMD microcode update via /dev/cpu/microcode not supported
> >> microcode: AMD microcode update via /dev/cpu/microcode not supported
> > 
> > no, the message is correct - the AMD ucode driver doesn't support
> > ucode loading method through the /dev node, only through the firmware
> > loader. I.e., you should simply put the microcode image into
> > /lib/firmware/amd-ucode/ and compile the kernel microcode driver as a
> > module - then it'll load automatically.
> 
> Wel, yes/no.
> It works that way on my other boxes.
> On this specific box microcode_ctl is not activated automagically during
> startup of the machine.

As I said earlier, microcode_ctl cannot load the microcode on AMD -
this happens upon module load with no need for userspace support except
enabling loading of the microcode.ko module (you have to check how
exactly Fedora does that).

> What else could be the cause of microcode_ctl not updating?
> Situation is:
> microcode: CPU0: patch_level=0x10000b7
> microcode: CPU1: patch_level=0x10000b7
> Is that new enough so that there is just no newer code to be uploaded
> for AMD Athlon(tm) II X2 235e Processor ?

Exactly, this says that you have the latest ucode for your CPU.

HTH.

-- 
Regards/Gruss,
    Boris.
