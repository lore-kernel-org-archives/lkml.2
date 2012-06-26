Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834Ab2FZFAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:00:54 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:34975 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2FZFAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:00:52 -0400
Date: Tue, 26 Jun 2012 07:00:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] mod/file2alias: make modalias generation safe for
	cross compiling
Message-ID: <20120626050049.GA24503@merkur.ravnborg.org>
References: <CAMuHMdXk6pByz14JcDgY+UE6QM0sHD8cbXye9CgOVSRRtr7J+Q@mail.gmail.com> <20120615201021.GB14544@kroah.com> <CAMuHMdUj6tAcWhkSkV43Kw3-2-3+JzgP6W=2w3fjL2KBfRh9ZQ@mail.gmail.com> <20120615231220.GC8205@kroah.com> <87lijns84s.fsf@nemi.mork.no> <m2bokjb6tv.fsf@igel.home> <87fw9urqau.fsf@nemi.mork.no> <m2d34n1sz9.fsf_-_@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2d34n1sz9.fsf_-_@igel.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas.

On Mon, Jun 25, 2012 at 02:22:34PM +0200, Andreas Schwab wrote:
> Use the target compiler to compute the offsets of the fields of the
> device_id structures, so that it won't be broken by different alignments
> between the host and target ABIs.
Looks good.

> diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
> index 08dce14..ff22206 100644
> --- a/scripts/Makefile.modpost
> +++ b/scripts/Makefile.modpost
> @@ -80,8 +80,7 @@ modpost = scripts/mod/modpost                    \
>   $(if $(KBUILD_EXTRA_SYMBOLS), $(patsubst %, -e %,$(KBUILD_EXTRA_SYMBOLS))) \
>   $(if $(KBUILD_EXTMOD),-o $(modulesymfile))      \
>   $(if $(CONFIG_DEBUG_SECTION_MISMATCH),,-S)      \
> - $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w) \
> - $(if $(cross_build),-c)
> + $(if $(KBUILD_EXTMOD)$(KBUILD_MODPOST_WARN),-w)

With this change we can kill cross_build, and thus we can
drop KBUILD_BUILDHOST too (from top-level Makefile).

	Sam
