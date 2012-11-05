Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab2KEUnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:43:15 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:33071 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab2KEUnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:43:10 -0500
MIME-Version: 1.0
In-Reply-To: <s5hhap49den.wl%tiwai@suse.de>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	<alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	<20121029174131.GC7580@srcf.ucam.org>
	<s5hobjia6vj.wl%tiwai@suse.de>
	<20121031173728.GA18615@srcf.ucam.org>
	<s5h390utqv3.wl%tiwai@suse.de>
	<1351743715.21227.95.camel@linux-s257.site>
	<20121101131849.752df6fd@pyramind.ukuu.org.uk>
	<s5hip9k9dng.wl%tiwai@suse.de>
	<s5hhap49den.wl%tiwai@suse.de>
Date: Mon, 5 Nov 2012 15:43:09 -0500
Message-ID: <CA+5PVA52rjx+E6tDcoiy+7tj+ZrYO0yHevdMUpvL-vuRcTkDKA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
From: Josh Boyer <jwboyer@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 5, 2012 at 12:18 PM, Takashi Iwai <tiwai@suse.de> wrote:
> Hi,
>
> this is a patch series to add the support for firmware signature
> check.  At this time, the kernel checks extra signature file (*.sig)
> for each firmware, instead of embedded signature.
> It's just a quick hack using the existing module signing mechanism,
> thus provided only as a proof of concept for now.
>
> To be noted, it doesn't support the firmwares via udev but only the
> direct loading, and the check for built-in firmware is missing, too.

Just to make sure I'm reading this correctly, it will sign any of the
firwmare files installed directly from the kernel tree if the option is
set.  So for the firmware in the linux-firmware tree we'd need to
either copy that into the kernel tree during build time, or duplicate the
signing bits in the linux-firmware tree itself.  However if we do the
latter, we'd probably need to use the same keys as the per-build kernel
key which means copying keys (ew) or tell the kernel to include a
separate firmware key in the extra list.

I feel like I'm rambling a bit, but I'm trying to work out how signed
firmware would look from a distro perspective.  A significant amount of
work has been done to decouple linux-firmware from the kernel tree and
if signed firmware is used it seems to couple them together one way or
another.  At the moment, using generated per-build keys to come up with
the firmware signatures seems a bit suboptimal in that regard.

josh
