Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab1FPPIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:08:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:53237 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755474Ab1FPPIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:08:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 5/5] kgdbts: unify/generalize gdb breakpoint adjustment
Date: Thu, 16 Jun 2011 17:07:32 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mike Frysinger <vapier@gentoo.org>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-sh@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <1302760895-13459-1-git-send-email-vapier@gentoo.org> <1302760895-13459-6-git-send-email-vapier@gentoo.org> <20110418082900.GB32457@linux-sh.org>
In-Reply-To: <20110418082900.GB32457@linux-sh.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106161707.32356.arnd@arndb.de>
X-Provags-ID: V02:K0:otFejYD0M76/Hv8/uDoYqrKZi6HCiscMIvvn6u2AfLn
 9GJgGfzXhbY6doUGAE/hopVcxiH92QgDoIS0At0lTZRVhs5TlL
 zTEjdlKgZZfXxADmy4LO7lr0ygEPgQhE0RemuUmRbQgO/DGFRj
 CeLnRh3VnRgTBBU/M2ZkRQuUiAwLZA85zHGtPK1eF5Qcd3fqle
 wUQvevBI+5OcpNlePlpSw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 April 2011, Paul Mundt wrote:
> On Thu, Apr 14, 2011 at 02:01:35AM -0400, Mike Frysinger wrote:
> > The Blackfin arch, like the x86 arch, needs to adjust the PC manually
> > after a breakpoint is hit as normally this is handled by the remote gdb.
> > However, rather than starting another arch ifdef mess, create a common
> > GDB_ADJUSTS_BREAK_OFFSET define for any arch to opt-in via their kgdb.h.
> > 
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> 
> Acked-by: Paul Mundt <lethal@linux-sh.org>


This patch is causing build problems now, because the instruction_pointer_set()
that is used now is only defined in asm-generic/ptrace.h, which is only
used on x86, blackfin and sparc. Every other architecture now fails to
build.

	Arnd
