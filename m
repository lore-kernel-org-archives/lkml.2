Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1HCIrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 04:47:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab1HCIrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 04:47:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <0f579173fd1c9f5dba6703ed8e44a767edf948b5.1312323131.git.len.brown@intel.com>
References: <0f579173fd1c9f5dba6703ed8e44a767edf948b5.1312323131.git.len.brown@intel.com> <1312323292-2986-1-git-send-email-lenb@kernel.org> <ca7cc5110a313a609da40ae948978a585352564b.1312323131.git.len.brown@intel.com> 
To: Len Brown <lenb@kernel.org>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Huang Ying <ying.huang@intel.com>,
        Richard Henderson <rth@twiddle.net>, Mikael Starvik <starvik@axis.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 10/19] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
Date: Wed, 03 Aug 2011 09:44:30 +0100
Message-ID: <5527.1312361070@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> wrote:

> From: Huang Ying <ying.huang@intel.com>
> 
> cmpxchg() is widely used by lockless code, including NMI-safe lockless
> code.  But on some architectures, the cmpxchg() implementation is not
> NMI-safe, on these architectures the lockless code may need a
> spin_trylock_irqsave() based implementation.
> 
> This patch adds a Kconfig option: ARCH_HAVE_NMI_SAFE_CMPXCHG, so that
> NMI-safe lockless code can depend on it or provide different
> implementation according to it.
> 
> On many architectures, cmpxchg is only NMI-safe for several specific
> operand sizes. So, ARCH_HAVE_NMI_SAFE_CMPXCHG define in this patch
> only guarantees cmpxchg is NMI-safe for sizeof(unsigned long).
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> Acked-by: Paul Mundt <lethal@linux-sh.org>
> Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Acked-by: Chris Metcalf <cmetcalf@tilera.com>
> CC: Richard Henderson <rth@twiddle.net>
> CC: Mikael Starvik <starvik@axis.com>
> CC: David Howells <dhowells@redhat.com>
> CC: Yoshinori Sato <ysato@users.sourceforge.jp>
> CC: Tony Luck <tony.luck@intel.com>
> CC: Hirokazu Takata <takata@linux-m32r.org>
> CC: Geert Uytterhoeven <geert@linux-m68k.org>
> CC: Michal Simek <monstr@monstr.eu>
> CC: Ralf Baechle <ralf@linux-mips.org>
> CC: Kyle McMartin <kyle@mcmartin.ca>
> CC: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: Chen Liqin <liqin.chen@sunplusct.com>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Ingo Molnar <mingo@redhat.com>
> CC: Chris Zankel <chris@zankel.net>
> Signed-off-by: Len Brown <len.brown@intel.com>

Acked-by: David Howells <dhowells@redhat.com> [FRV]
