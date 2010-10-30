Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab0J3TQd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 15:16:33 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29892 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0J3TQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 15:16:30 -0400
Date: Sat, 30 Oct 2010 21:06:13 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] Perf, AMD: Prefer kzalloc() over kmalloc()+memset() in
 amd_alloc_nb()
Message-ID: <alpine.LNX.2.00.1010302101240.1572@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I believe this would be an improvement?

Prefer kzalloc() over kmalloc()+memset() in amd_alloc_nb().


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 perf_event_amd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index 46d5844..a3787b2 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -280,11 +280,10 @@ static struct amd_nb *amd_alloc_nb(int cpu, int nb_id)
 	struct amd_nb *nb;
 	int i;
 
-	nb = kmalloc(sizeof(struct amd_nb), GFP_KERNEL);
+	nb = kzalloc(sizeof(struct amd_nb), GFP_KERNEL);
 	if (!nb)
 		return NULL;
 
-	memset(nb, 0, sizeof(*nb));
 	nb->nb_id = nb_id;
 
 	/*


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

