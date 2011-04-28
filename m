Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab1D1Pnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:43:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42256 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933297Ab1D1Pn2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:43:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH v3] cpumask: add cpumask_var_t documentation
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <BANLkTim4RWbkEMuUDcGG5y-ApznqX+31uw@mail.gmail.com>
References: <20110429002847.3D77.A69D9226@jp.fujitsu.com> <BANLkTim4RWbkEMuUDcGG5y-ApznqX+31uw@mail.gmail.com>
Message-Id: <20110429004505.3D7F.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 29 Apr 2011 00:43:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 28, 2011 at 12:27 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> > cpumask_var_t has one nortable difference against cpumask_t.
> > This patch adds the explanation.
> >
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  include/linux/cpumask.h |   14 ++++++++++++++
> >  1 files changed, 14 insertions(+), 0 deletions(-)
> >
> > diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> > index 1e40dd0..471c98a 100644
> > --- a/include/linux/cpumask.h
> > +++ b/include/linux/cpumask.h
> > @@ -617,6 +617,20 @@ static inline size_t cpumask_size(void)
> >  *       ... use 'tmpmask' like a normal struct cpumask * ...
> >  *
> >  *     free_cpumask_var(tmpmask);
> > + *
> > + *
> > + * However, one notable exception is there. cpumask_var_t is allocated
> > + * only nr_cpu_ids bits
> 
> Maybe, instead of "is allocated only", "allocates only" ?

Instead, "alloc_cpumask_var() allocates only nr_cpu_ids bits" is more clear? :)


> > (in the other hand, real cpumask_t always has
> > + * NR_CPUS bits). therefore You don't have to dereference cpumask_var_t.
> 
> s/therefore You/Therefore you/ ?
> 

Thx.


> > + *
> > + *     cpumask_var_t tmpmask;
> > + *     if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
> > + *             return -ENOMEM;
> > + *
> > + *     var = *tmpmask;
> > + *
> > + * This code makes NR_CPUS length memcopy and bring memroy corruption.
> 
> /s/memroy/memory
> 
> You are saying that I should not use this code? I'm confused, could
> you explain a little bit?

Yes. you aren't confused.


> > + * You have to use cpumask_copy() instead.
> >  */
> 
> I don't get this. :(

"cpumask_copy() privide safe copy functionality." is clear?


>From d2ea9d4846e46bcc8a82b9a641ede3a10aca346c Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 19:58:39 +0900
Subject: [PATCH v3] cpumask: add cpumask_var_t documentation

cpumask_var_t has one nortable difference against cpumask_t.
This patch adds the explanation.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/cpumask.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 1e40dd0..e2b9032 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -617,6 +617,20 @@ static inline size_t cpumask_size(void)
  *	  ... use 'tmpmask' like a normal struct cpumask * ...
  *
  *	free_cpumask_var(tmpmask);
+ *
+ *
+ * However, one notable exception is there. alloc_cpumask_var() allocates
+ * only nr_cpumask_bits bits (in the other hand, real cpumask_t always has
+ * NR_CPUS bits). Therefore you don't have to dereference cpumask_var_t.
+ *
+ *	cpumask_var_t tmpmask;
+ *	if (!alloc_cpumask_var(&tmpmask, GFP_KERNEL))
+ *		return -ENOMEM;
+ *
+ *	var = *tmpmask;
+ *
+ * This code makes NR_CPUS length memcopy and bring memory corruption.
+ * cpumask_copy() privide safe copy functionality.
  */
 #ifdef CONFIG_CPUMASK_OFFSTACK
 typedef struct cpumask *cpumask_var_t;
-- 
1.7.3.1



