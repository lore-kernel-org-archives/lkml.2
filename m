Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1JZHeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 03:34:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48721 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672Ab1JZHeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 03:34:19 -0400
Date: Wed, 26 Oct 2011 09:33:50 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-m68k@vger.kernel.org,
        linux-mips@linux-mips.org, linux-sh@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH] gpiolib/arches: Centralise bolierplate asm/gpio.h
Message-ID: <20111026073348.GB2915@opensource.wolfsonmicro.com>
References: <1319528012-19006-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAJaTeTp2w85UHnmH-PPMZsQGQMNa-93kw-tjmDxA_wjJXkYQcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJaTeTp2w85UHnmH-PPMZsQGQMNa-93kw-tjmDxA_wjJXkYQcQ@mail.gmail.com>
X-Cookie: You will be divorced within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 07:44:14PM -0400, Mike Frysinger wrote:

> i don't think this is generally how asm-generic is handled.  instead, how about:
>  - move the duplicate code to asm-generic/gpio.h
>  - have the arches which merely need asm-generic/gpio.h add "generic-y
> += gpio.h" to their include/asm/Kbuild
>  - for arches which need to override these common funcs in some way,
> add #ifdef protection to the asm-generic/gpio.h

> and it seems like with slightly more work, this path allow you to
> merge most of arch/sh/include/asm/gpio.h.  and it has the advantage of
> not needing new Kconfig symbols.

That's really not how gpiolib is currently handled, unfortunately -
trying to transition over to that model in one patch would be way too
much.  

The goal here from that point of view is to make transitioning to
something more sensible easier by getting rid of the boilerplate code,
it makes doing the more invasive changes like you're suggesting much
easier as we're only dealing with the architectures that are actually
doing something.  It also means that we're able to immediately work on
turning on gpiolib on random architectures which is a definite win.
