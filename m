Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab2LNLN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:13:56 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36238 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab2LNLNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:13:54 -0500
Date: Fri, 14 Dec 2012 12:13:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: [PATCH] ata: uncomment ata_timing for XFER_PIO_SLOW
Message-ID: <20121214111351.GA7307@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>
References: <20121214110137.9155.68183.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121214110137.9155.68183.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 03:01:37PM +0400, Konstantin Khlebnikov wrote:
> This patch uncomments ata timings for XFER_PIO_SLOW,
> otherwise ata_timing_find_mode() returns NULL and kernel crashes in
> pacpi_set_dmamode() after null-pointer dereference.
> 
> The same problem was mentioned recently in debug patch v3.7-rc5-72-gcd705d5
> ("libata debugging: Warn when unable to find timing descriptor based on xfer_mode")
> 
> I'm not sure about this patch, because I have no idea what this XFER_PIO_SLOW

No, this is already fixed by:

http://git.kernel.org/?p=linux/kernel/git/jgarzik/libata-dev.git;a=commitdiff;h=5416912af75de9cba5d1c75b99a7888b0bbbd2fb

Btw, this patch will go to stable since I can't find it in 3.7, I'm
guessing Jeff will send it to Linus soonish since it is in his NEXT
branch.

Until that happens, you could test 3.7 by cherrypicking the patch above
ontop of it or by simply applying it by hand since it is only two lines.

Or, you could wait and test -rc1 when it comes out after the world ends :-).

> means and why this bug so rare (3 times during 4 days boot-reboot test) I caught
> this on completely ordinary PC with nvidia MCP61 chipset, sata hdd and ide dvd-rom.
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Signed-off-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

Btw, just FYI, this is not how S-o-b chaining works. Take a look
at <Documentation/SubmittingPatches> for details on how it is done
correctly.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
