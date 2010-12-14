Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216Ab0LNXAI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:00:08 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:56644 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758935Ab0LNXAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:00:06 -0500
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX18kXKRlY/IkjNaWx6R01S0KYp9TONTxfRwCIj7w/h
	6bKZNxPNjQXDMz
Date: Wed, 15 Dec 2010 00:00:01 +0100
From: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arch/arm/kernel: use cpu_relax() in halt loops
Message-ID: <20101214230001.GA1747@debian.debian>
References: <20101214224848.GA1706@debian.debian>
 <20101214225126.GD24303@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101214225126.GD24303@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 10:51:26PM +0000, Russell King - ARM Linux wrote:
> On Tue, Dec 14, 2010 at 11:48:48PM +0100, Jonathan Neuschäfer wrote:
> > Looking throught arch/arm/kernel/ I found some halt loops.
> > I just thought we could save some power here using cpu_relax(),
> > or am I missing something?
> 
> #if __LINUX_ARM_ARCH__ == 6
> #define cpu_relax()                     smp_mb()
> #else
> #define cpu_relax()                     barrier()
> #endif
> 
> IOW, it's either a memory barrier or compiler barrier on ARM; it
> doesn't do any power saving.

Okay, thanks for that explanation.
