Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab0DTPta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:49:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742Ab0DTPt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:49:29 -0400
Date: Tue, 20 Apr 2010 17:49:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jeff Dike <jdike@addtoit.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, Jan Kiszka <jan.kiszka@web.de>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 2/5] uml: Drop private round_down definition
In-Reply-To: <20100420142510.GA30011@c-98-229-117-200.hsd1.ma.comcast.net>
Message-ID: <alpine.LNX.2.00.1004201749170.7579@pobox.suse.cz>
References: <cover.1271713955.git.jan.kiszka@web.de> <74c7d668690f283cf3b8aed92004dc72e872f7ce.1271713955.git.jan.kiszka@web.de> <20100420083358.GD4356@cr0.nay.redhat.com> <20100420142510.GA30011@c-98-229-117-200.hsd1.ma.comcast.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010, Jeff Dike wrote:

> > >Already defined in kernel.h. The official version assumes that 'n' is
> > >power of two - which it is in our case.
> > >
> > >Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
> > >---
> > > arch/um/sys-x86_64/signal.c |    2 --
> > > 1 files changed, 0 insertions(+), 2 deletions(-)
> > >
> > >diff --git a/arch/um/sys-x86_64/signal.c b/arch/um/sys-x86_64/signal.c
> > >index 1a899a7..07797d1 100644
> > >--- a/arch/um/sys-x86_64/signal.c
> > >+++ b/arch/um/sys-x86_64/signal.c
> > >@@ -165,8 +165,6 @@ struct rt_sigframe
> > > 	struct _fpstate fpstate;
> > > };
> > > 
> > >-#define round_down(m, n) (((m) / (n)) * (n))
> > >-
> > > int setup_signal_stack_si(unsigned long stack_top, int sig,
> > > 			  struct k_sigaction *ka, struct pt_regs * regs,
> > > 			  siginfo_t *info, sigset_t *set)
> > 
> > Shouldn't this signal.c #include <linux/kernel.h>?
> 
> I agree - if this is going to depend on kernel.h, it should be
> explicitly included.

Yup, I have already added that.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
