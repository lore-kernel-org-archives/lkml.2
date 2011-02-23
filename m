Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1BWPA7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:00:59 -0500
Received: from ra.se.axis.com ([195.60.68.13]:45343 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab1BWPA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:00:57 -0500
Date: Wed, 23 Feb 2011 16:00:47 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@vmware.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
	module versions
Message-ID: <20110223150047.GC13204@axis.com>
References: <20110217.142320.102554706.davem@davemloft.net> <AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com> <AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com> <1298074455.2460.85.camel@pasglop> <87pqqmrq9q.fsf@rustcorp.com.au> <1298339909.8833.135.camel@pasglop> <AANLkTimyaA+JdBHekm69R5Y2A2DEdPdndFLrKJAaz=vt@mail.gmail.com> <20110222070240.GA21765@dtor-ws.eng.vmware.com> <20110222170849.GW13204@axis.com> <AANLkTikd9QJZVoN+N4yLfr+Y+GWkB1EvShrgvb39Fp=0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikd9QJZVoN+N4yLfr+Y+GWkB1EvShrgvb39Fp=0@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 09:47:09PM +0100, Linus Torvalds wrote:
> On Tue, Feb 22, 2011 at 9:08 AM, Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> > True, at least until I've made sure that there isn't any
> > underlying reason for CRISv32 to put __param in a different place...
> >
> > Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
> 
> I really am not going to apply a patch that likely just adds another
> redundant field to the linker scripts. So the ack I'm just ignoring,

:-)

> But it would be good to get the "remove the legacy __param thing
> because it's already there from the asm-generic version" confirmed by
> testing, and not just looking at the source code.

Testing shows no problems with the below patch.

>From f8c17a94940a012f237986b4f40ca557a88f9019 Mon Sep 17 00:00:00 2001
From: Jesper Nilsson <jespern@axis.com>
Date: Wed, 23 Feb 2011 13:04:25 +0100
Subject: [PATCH] Drop redundant __param section for CRISv32.

The __param section is already brought in by RODATA above.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/kernel/vmlinux.lds.S |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/cris/kernel/vmlinux.lds.S b/arch/cris/kernel/vmlinux.lds.S
index 917b727..e8adc35 100644
--- a/arch/cris/kernel/vmlinux.lds.S
+++ b/arch/cris/kernel/vmlinux.lds.S
@@ -75,11 +75,6 @@ SECTIONS
 	INIT_TEXT_SECTION(PAGE_SIZE)
 	.init.data : { INIT_DATA }
 	.init.setup : { INIT_SETUP(16) }
-#ifdef CONFIG_ETRAX_ARCH_V32
-	__start___param = .;
-	__param : { *(__param) }
-	__stop___param = .;
-#endif
 	.initcall.init : {
 		INIT_CALLS
 	}
-- 
1.7.4

>                      Linus

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
