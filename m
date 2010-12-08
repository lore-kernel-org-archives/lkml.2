Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab0LHVVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:21:53 -0500
Received: from www.tglx.de ([62.245.132.106]:49152 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106Ab0LHVVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:21:51 -0500
Date: Wed, 8 Dec 2010 22:21:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ralf Baechle <ralf@linux-mips.org>
cc: David Daney <ddaney@caviumnetworks.com>, Anoop P A <anoop.pa@gmail.com>,
        linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Introduce mips_late_time_init
In-Reply-To: <20101208203704.GB30923@linux-mips.org>
Message-ID: <alpine.LFD.2.00.1012082217230.2653@localhost6.localdomain6>
References: <1291623812.31822.6.camel@paanoop1-desktop> <4CFD2095.9040404@caviumnetworks.com> <20101208203704.GB30923@linux-mips.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010, Ralf Baechle wrote:
> Running everything from late_time_init() instead allows the use of kmalloc.
> X86 has the same issue with requiring kmalloc in time_init which is why
> they had moved everything to late_time_init.

It's more ioremap, but yeah.
 
> So the real question is, why can't we just move the call of time_init()
> in setup_kernel() to where late_time_init() is getting called from for
> all architectures, does anything rely on it getting called early?

That's a good question and I asked it myself already. I can't see a
real reason why something would need it early. Definitely worth to
try.

Thanks,

	tglx
