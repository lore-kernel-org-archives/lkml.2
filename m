Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436Ab2GCTej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:34:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37317 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933032Ab2GCTei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:34:38 -0400
Date: Tue, 3 Jul 2012 20:34:03 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alessandro Rubini <rubini@gnudd.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, x86@kernel.org, gregkh@linuxfoundation.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
Message-ID: <20120703193403.GA26355@n2100.arm.linux.org.uk>
References: <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com> <20120701104401.GA4352@mail.gnudd.com> <20120703130042.GA10007@mail.gnudd.com> <201207031319.40884.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207031319.40884.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 01:19:40PM +0000, Arnd Bergmann wrote:
> On Tuesday 03 July 2012, Alessandro Rubini wrote:
> >    drivers/dma/amba-pl08x.c: needs <asm/hardware/pl080.h>
> >      proposed fix: move pl080.h to include/linux
> 
> Note that there is already an include/linux/amba/pl08x.h.
> I would just move the few parts of pl080.h that are actually
> needed with global visibility there, and move the rest
> to drivers/dma/.

NAK.  It's the entire register definitions for the PL08x, which we really
should not be exporting to common code.

Please wait until _after_ my DMA engine stuff (which is now in linux-next)
makes its way upstream before touching any of this stuff, otherwise there's
going to be conflicts.

As part of my patch series, this gets rid of a number of uses of it in
arch/arm, but there's still the .cctl_memcpy initializer which does. I've
not yet checked whether all implementations use the same value (they
probably do), and if so then it should be eliminated from platform code
and moved into the driver.

I've talked about asm/hardware/pl080.h within the last week on this very
thread... and it's disappointing to have to re-say what I said because
you've not read my previous postings.
