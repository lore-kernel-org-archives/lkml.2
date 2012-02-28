Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab2B1UGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:06:05 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:21076 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757294Ab2B1UGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:06:02 -0500
Date: Tue, 28 Feb 2012 21:06:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, linux@arm.linux.org.uk
Subject: Re: [PATCH] kernel.h: Include <linux/bug.h> to avoid build breakage
	with ARRAY_SIZE()
Message-ID: <20120228200600.GB3042@merkur.ravnborg.org>
References: <1330436499-17190-1-git-send-email-fabio.estevam@freescale.com> <20120228155124.GA2827@merkur.ravnborg.org> <4F4D0438.9070200@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4D0438.9070200@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 11:43:36AM -0500, Paul Gortmaker wrote:
> On 12-02-28 10:51 AM, Sam Ravnborg wrote:
> > On Tue, Feb 28, 2012 at 10:41:39AM -0300, Fabio Estevam wrote:
> >> Building imx_v6_v7_defconfig generated the following build error:
> >>
> >> arch/arm/mach-imx/cpu_op-mx51.c: In function 'mx51_get_cpu_op':
> >> arch/arm/mach-imx/cpu_op-mx51.c:27: error: implicit declaration of function 'BUILD_BUG_ON_ZERO'
> >>
> >> commit 6f863554 (kernel.h: doesn't explicitly use bug.h, so don't include it.)
> >> has removed asm/debug.h from linux/kernel.h.
> >>
> >> Quoting Russell King (http://www.spinics.net/lists/arm-kernel/msg161916.html)
> >>
> >> "linux/kernel.h _does_ use bug stuff - in ARRAY_SIZE().
> >>
> >> ARRAY_SIZE() uses __must_be_array(), which is defined in linux/compiler-gcc.h,
> >> which is obtained via linux/compiler.h and linux/linkage.h.
> >>
> >> linux/compiler-gcc.h defines __must_be_array() to be:
> >> #define __must_be_array(a) BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
> > 
> > In which case linux/compiler-gcc.h uses bug.h - so this is where you
> > should add the include.
> > Not in kernel.h that just happens to use __must_be_array()
> > We do not want to add "#include bug.h" to all header files
> > that happens to use __must_be_array.
> 
> The approach I was taking was to consider something "used" if it was
> actually in a static inline[1]. So in that sense, the kernel.h does
> not "use" ARRAY_SIZE, but only defines it.  This seems to be what has
> been done in the past, and folks have even converted trivial static
> inline functions to macros just to use this concept of "used" to
> help avoid tangling includes any further than they currently are.

We have a macro which uses a macro which uses a macro from bug.h.
Should we include bug.h with the first or the second macro?

I guess in this case it does not matter much.

	Sam
