Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab1DGRkv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:40:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39207 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab1DGRku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:40:50 -0400
Date: Thu, 7 Apr 2011 18:39:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Huang Ying <ying.huang@intel.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Mikael Starvik <starvik@axis.com>, David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH -v2 1/4] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
Message-ID: <20110407173953.GB17049@n2100.arm.linux.org.uk>
References: <1302139746-1030-1-git-send-email-ying.huang@intel.com> <1302139746-1030-2-git-send-email-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302139746-1030-2-git-send-email-ying.huang@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 07, 2011 at 09:29:03AM +0800, Huang Ying wrote:
> cmpxchg() is widely used by lockless code, including NMI-safe lockless
> code.  But on some architectures, the cmpxchg() implementation is not
> NMI-safe, on these architectures the lockless code may need to a
> spin_trylock_irqsave() based implementation.
> 
> This patch adds a Kconfig option: ARCH_HAVE_NMI_SAFE_CMPXCHG, so that
> NMI-safe lockless code can depend on it or provide different
> implementation according to it.
> 
> On many architectures, cmpxchg is only NMI-safe for several specific
> operand sizes. So, ARCH_HAVE_NMI_SAFE_CMPXCHG define in this patch
> only guarantees cmpxchg is NMI-safe for sizeof(unsigned long).

As this no longer touches any ARM code, I thinky you can drop me from the
CC list.  Thanks.
