Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab0DTOf4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 10:35:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:49925 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab0DTOfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 10:35:53 -0400
Date: Tue, 20 Apr 2010 16:35:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 2/5] uml: Drop private round_down definition
In-Reply-To: <20100420083358.GD4356@cr0.nay.redhat.com>
Message-ID: <alpine.LNX.2.00.1004201635050.7579@pobox.suse.cz>
References: <cover.1271713955.git.jan.kiszka@web.de> <74c7d668690f283cf3b8aed92004dc72e872f7ce.1271713955.git.jan.kiszka@web.de> <20100420083358.GD4356@cr0.nay.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010, Amerigo Wang wrote:

> On Mon, Apr 19, 2010 at 11:53:05PM +0200, Jan Kiszka wrote:
> >Already defined in kernel.h. The official version assumes that 'n' is
> >power of two - which it is in our case.
> >
> >Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
> >---
> > arch/um/sys-x86_64/signal.c |    2 --
> > 1 files changed, 0 insertions(+), 2 deletions(-)
> >
> >diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
> >index 1a899a7..07797d1 100644
> >--- a/arch/um/sys-x86_64/signal.c
> >+++ b/arch/um/sys-x86_64/signal.c
> >@@ -165,8 +165,6 @@ struct rt_sigframe
> > 	struct _fpstate fpstate;
> > };
> > 
> >-#define round_down(m, n) (((m) / (n)) * (n))
> >-
> > int setup_signal_stack_si(unsigned long stack_top, int sig,
> > 			  struct k_sigaction *ka, struct pt_regs * regs,
> > 			  siginfo_t *info, sigset_t *set)
> 
> Shouldn't this signal.c #include <linux/kernel.h>?

Well, it gets included implicitly through uaccess.h -> sched.h -> 
kernel.h.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
