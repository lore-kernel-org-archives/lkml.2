Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2FKInZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 04:43:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:57143 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab2FKInX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 04:43:23 -0400
Date: Mon, 11 Jun 2012 10:43:18 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boszormenyi Zoltan <zboszor@pr.hu>
Cc: linux-kernel@vger.kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: AMD FX CPU bug, not fixed by latest microcode?
Message-ID: <20120611084318.GA1685@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Boszormenyi Zoltan <zboszor@pr.hu>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <4FD4F45D.5050103@pr.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FD4F45D.5050103@pr.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(leaving in the full text)

On Sun, Jun 10, 2012 at 09:24:13PM +0200, Boszormenyi Zoltan wrote:
> Hi,
> 
> I have an AMD FX-8120 boxed CPU in an ASUS M5A99X-EVO mainboard
> with 32GB DDR3/1600 memory, running Fedora 17, upgraded from 16.
> memtest86+ show no problems.

Did you have the same issue with Fedora 16? Also, could you test with
another distro whether the same thing happens?

> Still, I get occasional crashes and signal 11 during kernel
> compilation even with single-job make. Sometimes the compiler jumps
> out with a strange error message, like "stray \NNN character in the
> source".

Is that the same ^Z character as below? Is that character with ascii
number \026? Or do you get different characters each time?

> When re-running
> make, the error doesn't happen in the same file and the source file doesn't
> contain the character being complained about when inspecting with
> an editor or hexdump.
> 
> Now, a few minutes ago I was able to catch this bug when I copied the
> kernel GIT tree to apply a patch manually and did "git commit -a".
> Strangely, the commit contained one extra file that I didn't touch.
> git diff showed this for the extra file:
> 
> ==============================
> --- a/drivers/usb/gadget/fsl_usb2_udc.h
> +++ b/drivers/usb/gadget/fsl_usb2_udc.h
> @@ -427,7 +427,7 @@ struct ep_td_struct {
>  #define  DTD_ADDR_MASK                        0xFFFFFFE0
>  #define  DTD_PACKET_SIZE                      0x7FFF0000
>  #define  DTD_LENGTH_BIT_POS                   16
> -#define  DTD_ERROR_MASK                       (DTD_STATUS_HALTED | \
> +#define  DTD_ERROR_MASK                       (DTD_STATUS_HALTED | ^Z
>                                                 DTD_STATUS_DATA_BUFF_ERR | \
>                                                 DTD_STATUS_TRANSACTION_ERR)
>  /* Alignment requirements; must be a power of two */
> ==============================
> 
> The "^Z" is a 0-character in the file and is not present in the
> original source tree, only in the copy.
> 
> Similar errors happened during copying large files on the same
> machine but it seems it's enough to trigger if the total amount
> of data read is large enough.
> 
> The mainboard has the latest (UEFI) firmware flashed which
> contains the latest AMD microcode, so microcode_ctl doesn't
> need to apply it anymore. Previously, I used amd-ucode-2012-01-17.tar
> from www.amd64.org/support/microcode.html which is now
> part of microcode_ctl in Fedora.

Can you send /proc/cpuinfo?

Also, a dmesg from a recent kernel?

> Since the error happens during compiling a source file and not only
> copying, the bug seems to happens during *reading* data.
> 
> Does anyone know whether it's a known problem in AMD FX CPUs?
> Does AMD have a newer microcode to fix this bug, or should I apply
> for warranty?

Thanks.

-- 
Regards/Gruss,
    Boris.
