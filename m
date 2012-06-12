Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab2FLSVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 14:21:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54979 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2FLSVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 14:21:02 -0400
Date: Tue, 12 Jun 2012 19:20:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brown <davidb@codeaurora.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Eric Miao <eric.y.miao@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Paulo Marques <pmarques@grupopie.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jon Masters <jonathan@jonmasters.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: two possible fixes for the KALLSYMS build problem
Message-ID: <20120612182036.GE7918@n2100.arm.linux.org.uk>
References: <1338567721-19514-1-git-send-email-davidb@codeaurora.org> <20120611203748.GA16967@codeaurora.org> <20120612143249.GB7918@n2100.arm.linux.org.uk> <20120612160229.GA21389@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120612160229.GA21389@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 09:02:29AM -0700, David Brown wrote:
> On Tue, Jun 12, 2012 at 03:32:49PM +0100, Russell King - ARM Linux wrote:
> > On Mon, Jun 11, 2012 at 01:37:48PM -0700, David Brown wrote:
> > > On Fri, Jun 01, 2012 at 09:21:59AM -0700, David Brown wrote:
> > > 
> > > > David Brown (1):
> > > >   ARM: Prevent KALLSYM size mismatch on ARM.
> > > > 
> > > >  arch/arm/kernel/vmlinux.lds.S |    3 +++
> > > >  1 file changed, 3 insertions(+)
> > > 
> > > Just wondering if anyone has had a chance to look at either of these,
> > > or try them.  I haven't seen any KALLSYMS mismatch build errors with
> > > either of these patches applied.
> > 
> > I think variant 2 is the better approach out of either as it doesn't add
> > to the size of the resulting kernel image.
> 
> The first variant doesn't ever increase the size of the kernel,
> either.  Variant two actually makes it a little smaller, since a few
> symbols are eliminated.

Ok.

> The second variant is cleaner, though as long as it is safe in every
> configuration.

Well, we don't have any per-CPU data unless we're building for SMP.
See:

#ifndef PER_CPU_BASE_SECTION
#ifdef CONFIG_SMP
#define PER_CPU_BASE_SECTION ".data..percpu"
#else
#define PER_CPU_BASE_SECTION ".data"
#endif
#endif

in include/asm-generic/percpu.h.
