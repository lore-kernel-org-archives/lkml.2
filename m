Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1EGQVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 12:21:41 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57239 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855Ab1EGQVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 12:21:34 -0400
Date: Sat, 7 May 2011 18:21:30 +0200
From: Borislav Petkov <bp@alien8.de>
To: Udo van den Heuvel <udovdh@xs4all.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: AMD C1E issue?   2.6.38.4
Message-ID: <20110507162130.GA13307@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Udo van den Heuvel <udovdh@xs4all.nl>, linux-kernel@vger.kernel.org
References: <4DC54CE5.6050307@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DC54CE5.6050307@xs4all.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 07, 2011 at 03:45:09PM +0200, Udo van den Heuvel wrote:
> Hello,
> 
> Saw these in my messages after enabling C1E on my new Jetway Mini-ITX board:
> 
> # microcode_ctl -u
> microcode_ctl: writing microcode (length: 430080)
> microcode_ctl: error writing to '/dev/cpu/microcode' errno=22 (Invalid
> argument)
> microcode_ctl: there may be messages from the driver in your system log.
> 
> microcode: AMD microcode update via /dev/cpu/microcode not supported
> microcode: AMD microcode update via /dev/cpu/microcode not supported

no, the message is correct - the AMD ucode driver doesn't support
ucode loading method through the /dev node, only through the firmware
loader. I.e., you should simply put the microcode image into
/lib/firmware/amd-ucode/ and compile the kernel microcode driver as a
module - then it'll load automatically.

> This is on kernel.org 2.6.38.4 on AMD Athlon II X2 235e on JNC84E-LF
> board, Fedora 14 for most of the rest of the stuff.
> 
> Anybody can tell why the update cannot work?
> The previous board (JNC81) did not show these but also did not have C1E
> in BIOS as far as I recall.

This doesn't have anything to do with C1E.

HTH.

-- 
Regards/Gruss,
    Boris.
