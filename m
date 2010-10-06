Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab0JFSMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:12:16 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:24539 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759538Ab0JFSMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:12:15 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: QRP09tIVM1lZHT3zed2YoKkpm2bxNd5s00P0hTCd1cEsqgS
 FhOpZHq03d3U0hxnDOHbIK.38XMXUn5KoIfOopfS94vvT08zGsi9BO5.r8GT
 8w.iKPi5gkJ4gYIlEabeha9WEa_TPbRfrqQTMtlhIekwXEjts91SWa_qkzjf
 5krItYuY6WCxAZ_ZZzVPqruDZ4w8BWjGUIPr.ba.y__nKgXvr6Koa26Wt8Ac
 ZVKAFyTM24Y_uJEhaf9sJ5h2ejZdXW2d2yQLaK4OxgEUndr39zs7izFfn_dY
 qfEc-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Oct 2010 13:12:11 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Zimny Lech <napohybelskurwysynom2010@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for October 6
In-Reply-To: <AANLkTikv4Y3gxCEFXg8SQdgmb2Gqk7OniUT7gBvLf14p@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1010061311430.31538@router.home>
References: <20101006163632.c1943a38.sfr@canb.auug.org.au> <AANLkTikxMdXrm1jRztZM1BUAoCbBtAs6A39v1cAgRnDY@mail.gmail.com> <20101006174831.02cf1691.sfr@canb.auug.org.au> <AANLkTikv4Y3gxCEFXg8SQdgmb2Gqk7OniUT7gBvLf14p@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Oct 2010, Zimny Lech wrote:

> >> It seems that you forgot to push to repo
> >> http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=summary
> >
> > No, its just that the mirroring was slow/blocked :-(
>
> Ok, I pulled latest tree. Thanks.
>
> I already reported this before.
>
> /home/test/linux-2.6/mm/slub.c: In function 'kmem_cache_init':
> /home/test/linux-2.6/mm/slub.c:3031:2: error: 'slab_memory_callback'
> undeclared (first use in this function)
> /home/test/linux-2.6/mm/slub.c:3031:2: note: each undeclared
> identifier is reported only once for each function it appears in
> make[2]: *** [mm/slub.o] Error 1
> make[1]: *** [mm] Error 2
> make: *** [sub-make] Error 2
>
> any thoughts?


Subject: slub: hotplug_memory_notifier not useable for !CONFIG_MEMORY_HOTPLUG

Add #ifdef to resolve the situation.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-10-06 13:10:00.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-10-06 13:10:25.000000000 -0500
@@ -3028,7 +3028,9 @@ void __init kmem_cache_init(void)
 		sizeof(struct kmem_cache_node),
 		0, SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);

+#ifdef CONFIG_MEMORY_HOTPLUG
 	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
+#endif

 	/* Able to allocate the per node structures */
 	slab_state = PARTIAL;
