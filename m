Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0ECFlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 01:41:19 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33730 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab0ECFlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 01:41:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SH/l4FVcbT5wtj8o1nKqvCBCOGKT1csJtX2nh8R8bY87P20ZFgdi0m+AXadKZAdoBp
         yT9iZDn4OnHIjYVliKmnophdV4LnGE2bz4uGxAJr9cgxlRginXeTA30bldXpLQbxQKId
         pv//OUlWQOixGpV0tMbJBibtuZKsMNDbGUFY4=
Subject: Re: mmotm 2010-04-28 - RCU whinges
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1272865137.2173.179.camel@edumazet-laptop>
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org>
	 <5702.1272822394@localhost>  <1272865137.2173.179.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 07:41:07 +0200
Message-ID: <1272865267.2173.180.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 03 mai 2010 à 07:38 +0200, Eric Dumazet a écrit :
> Le dimanche 02 mai 2010 à 13:46 -0400, Valdis.Kletnieks@vt.edu a écrit :
> > On Wed, 28 Apr 2010 16:53:32 PDT, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2010-04-28-16-53 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > I thought we swatted all these, hit another one...
> > 
> > [    9.131490] ctnetlink v0.93: registering with nfnetlink.
> > [    9.131535]
> > [    9.131535] ===================================================
> > [    9.131704] [ INFO: suspicious rcu_dereference_check() usage. ]
> > [    9.131794] ---------------------------------------------------
> > [    9.131883] net/netfilter/nf_conntrack_ecache.c:88 invoked rcu_dereference_check() without protection!
> > [    9.131977]
> > [    9.131977] other info that might help us debug this:
> > [    9.131978]
> > [    9.132218]
> > [    9.132219] rcu_scheduler_active = 1, debug_locks = 0
> > [    9.132434] 1 lock held by swapper/1:
> > [    9.132519]  #0:  (nf_ct_ecache_mutex){+.+...}, at: [<ffffffff8148922d>] nf_conntrack_register_notifier+0x1a/0x75
> > [    9.132938]
> > [    9.132939] stack backtrace:
> > [    9.133129] Pid: 1, comm: swapper Tainted: G        W   2.6.34-rc5-mmotm0428 #1
> > [    9.133220] Call Trace:
> > [    9.133319]  [<ffffffff81064832>] lockdep_rcu_dereference+0xaa/0xb2
> > [    9.133410]  [<ffffffff81489250>] nf_conntrack_register_notifier+0x3d/0x75
> > [    9.133521]  [<ffffffff81b5a157>] ctnetlink_init+0x71/0xd5
> > [    9.133627]  [<ffffffff81b5a0e6>] ? ctnetlink_init+0x0/0xd5
> > [    9.133735]  [<ffffffff810001ef>] do_one_initcall+0x59/0x14e
> > [    9.133843]  [<ffffffff81b2e68a>] kernel_init+0x144/0x1ce
> > [    9.133949]  [<ffffffff81003414>] kernel_thread_helper+0x4/0x10
> > [    9.134060]  [<ffffffff81598a40>] ? restore_args+0x0/0x30
> > [    9.134196]  [<ffffffff81b2e546>] ? kernel_init+0x0/0x1ce
> > [    9.134328]  [<ffffffff81003410>] ? kernel_thread_helper+0x0/0x10
> > [    9.134530] ip_tables: (C) 2000-2006 Netfilter Core Team
> > [    9.134655] TCP bic registered
> > 
> 
> Thanks for the report !
> 
> We can use rcu_dereference_protected() in those cases.
> 
> [PATCH] net: Use rcu_dereference_protected in nf_conntrack_ecache
> 
> Writers own nf_ct_ecache_mutex.
> 
> Reported-by: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---


Oops scratch that, I'll resend a correct version.



