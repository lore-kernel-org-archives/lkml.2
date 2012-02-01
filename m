Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2BALJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:09:49 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58250 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753999Ab2BALJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:09:48 -0500
Date: Wed, 1 Feb 2012 11:08:36 +0000
From: Will Deacon <will.deacon@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Gary King <gking@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/8] ARM: tegra: rework Tegra secondary CPU core
 bringup
Message-ID: <20120201110836.GB3058@mudshark.cambridge.arm.com>
References: <1328028051-24271-1-git-send-email-pdeschrijver@nvidia.com>
 <1328028051-24271-4-git-send-email-pdeschrijver@nvidia.com>
 <20120131225045.GE8338@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120131225045.GE8338@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 10:50:45PM +0000, Russell King - ARM Linux wrote:
> On Tue, Jan 31, 2012 at 06:40:41PM +0200, Peter De Schrijver wrote:
> > +#ifdef CONFIG_ARM_ERRATA_743622
> > +	teq	r6, #0x20			@ present in r2p0
> > +	teqne	r6, #0x21			@ present in r2p1
> > +	teqne	r6, #0x22			@ present in r2p2
> > +	teqne	r6, #0x27			@ present in r2p7
> > +	teqne	r6, #0x29			@ present in r2p9
> 
> Okay, so we have this errata in proc-v7.S, but only for p0..p2.  If
> it's also p7 and p9, then it shows that the errata in the kernel aren't
> being actively maintained, and brings into question their worth.

It looks like the errata document has been updated since I wrote the
workaround in proc-v7.S (and new r2p* versions of the A9 have been
released). The new document states that r2p* are affected, so we should
update the workaround.

> Plus, of course, we don't want platforms re-implementing the errata
> in their own code if we're already implementing it somewhere in the
> kernel.  So, that's something which needs to be thought about.

Indeed, that could become extremely confusing, especially when they start
doing different things.

> That's something that needs considering along side the whole 'what
> to do about errata when running in non-secure mode' problem which
> OMAP suffers from.

My view is that the workarounds in the kernel are a good way to highlight
which errata we consider to be important from Linux's point-of-view and also
how to avoid them in practice. It's not always possible to apply them in the
kernel at runtime (due to security constraints) but I think it's important
to show what Linux expects.

I'll go back through the errata document and check if any others have been
updated besides this one.

Will
