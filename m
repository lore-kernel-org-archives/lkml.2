Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1HCPAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 11:00:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37721 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579Ab1HCPAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 11:00:41 -0400
Message-ID: <4E396294.5090902@twiddle.net>
Date: Wed, 03 Aug 2011 08:00:36 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>, Mikael Starvik <starvik@axis.com>,
        David Howells <dhowells@redhat.com>,
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
References: <1312323292-2986-1-git-send-email-lenb@kernel.org> <0f579173fd1c9f5dba6703ed8e44a767edf948b5.1312323131.git.len.brown@intel.com>
In-Reply-To: <0f579173fd1c9f5dba6703ed8e44a767edf948b5.1312323131.git.len.brown@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 03:14 PM, Len Brown wrote:
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

Acked-by: Richard Henderson <rth@twiddle.net>


r~
