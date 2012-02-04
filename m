Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab2BDRGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 12:06:38 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:18480 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab2BDRGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 12:06:35 -0500
Date: Sat, 4 Feb 2012 18:06:32 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, Russell King <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Grant Likely <grant.likely@secretlab.ca>, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, uclinux-dist-devel@blackfin.uclinux.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sh@vger.kernel.org
Subject: Re: [PATCH] gpiolib/arches: Centralise bolierplate asm/gpio.h
Message-ID: <20120204170632.GA3615@merkur.ravnborg.org>
References: <1328370879-18523-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328370879-18523-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 04, 2012 at 03:54:39PM +0000, Mark Brown wrote:
> Rather than requiring architectures that use gpiolib but don't have any
> need to define anything custom to copy an asm/gpio.h provide a Kconfig
> symbol which architectures must select in order to include gpio.h and
> for other architectures just provide the trivial implementation directly.

Hi Mark.

There is an even simpler solution.

For each arch that uses asm-generic/gpio.h add a line
to arch/$ARCH/include/asm/Kbuild like this:


    generic-y += gpio.h

This will then make this arch pick up the asm-generic version when
you do #include <asm/gpio.h>.

And you avoid the kconfig games.

iFor the archs which require their own asm/gpio.h file - just
add it to the asm/ dir - and do not add the generic-y assignment.

	Sam
