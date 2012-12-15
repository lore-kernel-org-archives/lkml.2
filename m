Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab2LODwO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 22:52:14 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:65175 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab2LODwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 22:52:13 -0500
Message-ID: <1355543529.20987.6.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] 3.6.9-rt21
From: Mike Galbraith <bitbucket@online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Sat, 15 Dec 2012 04:52:09 +0100
In-Reply-To: <alpine.LFD.2.02.1212051659160.2701@ionos>
References: <alpine.LFD.2.02.1212051659160.2701@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:lixjvlHWObyUnz9AW3ySwcH9YvmNdG23lP19Sy0+wdq
 wQisIUV/kCeZh0MfAJPLnv+MgURZILkCsBSzB6o3L7UDO87m1R
 5L3p79X+p4qvdKsyFjF7SoxvUSMH4Ve1clTxkaS3tP7oqliOMk
 PhnP2IODK0l/Uz6DHcFSu2AVA0R37R0Lx6JUDyzAlE/iwsiaI8
 81zMuz5ceT6qGs1gatW9L3dtjx5/rXQspERArQC1+cN/eKdxhC
 KnoSxm2zlBnzhxrJJTIwKcxbEyEfT3CSgpwM/yoSgE4XTP0IdX
 hjrXRLcJs2HHmMBWUsydLGoXDWCba+dnErYko+1aGNbTq04oud
 DmWGEb4J3XBn8pzbRTwWpWS5AySMafrte5oP4TiZDckjpTCVjS
 MlDshfyw9zyPw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-05 at 17:05 +0100, Thomas Gleixner wrote: 
> Dear RT Folks,
> 
> I'm pleased to announce the 3.6.9-rt21 release. 3.6.7-rt18, 3.6.8-rt19
> and 3.6.9-rt20 are not announced updates to the respective 3.6.y
> stable releases without any RT changes
> 
> Changes since 3.6.9-rt20:
> 
>    * Fix the PREEMPT_LAZY implementation on ARM
> 
>    * Fix the RCUTINY issues
> 
>    * Fix a long standing scheduler bug (See commit log of
>      sched-enqueue-to-head.patch)

That last has an oversight buglet.

sched: add missing userspace->kernel struct sched_param.sched_priority inversion

Signed-off-by: Mike Galbraith <bitbucket@online.de>
---
 kernel/sched/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4624,7 +4624,7 @@ static int __sched_setscheduler(struct t
 	p->sched_reset_on_fork = reset_on_fork;
 
 	oldprio = p->prio;
-	if (oldprio == param->sched_priority)
+	if (oldprio == (MAX_RT_PRIO - 1) - param->sched_priority)
 		goto out;
 
 	on_rq = p->on_rq;


