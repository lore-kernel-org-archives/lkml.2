Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab0KSQV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:21:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:41068 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755605Ab0KSQVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:21:25 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1//F+QX/lH/+xSLrFfd0FNHSNIu9DE9nfg5x2oCRc
	H6yNCTf9LS5EZ9
Subject: Re: Galbraith patch
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Jordi Pujol <jordipujolp@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201011191005.12189.gene.heskett@gmail.com>
References: <201011191509.49586.jordipujolp@gmail.com>
	 <201011191005.12189.gene.heskett@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 09:21:08 -0700
Message-ID: <1290183668.24581.16.camel@maggy.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 10:05 -0500, Gene Heskett wrote:
> On Friday, November 19, 2010, Jordi Pujol wrote:
> >Hello,
> >
> >it requires a little modification,
> >
> >CONFIG_SCHED_DEBUG should not be a condition to create autogroup in
> >structure task_group
> >
> >remove
> >    && defined(CONFIG_SCHED_DEBUG)
> >in the following conditional:
> >
> >+++ linux-2.6.36/kernel/sched.c
> >@@ -78,6 +78,7 @@
> >
> > #include "sched_cpupri.h"
> > #include "workqueue_sched.h"
> >+#include "sched_autogroup.h"
> >
> > #define CREATE_TRACE_POINTS
> > #include <trace/events/sched.h>
> >@@ -268,6 +269,10 @@ struct task_group {
> > 	struct task_group *parent;
> > 	struct list_head siblings;
> > 	struct list_head children;
> >+
> >+#if (defined(CONFIG_SCHED_AUTOGROUP) && defined(CONFIG_SCHED_DEBUG))
> >+	struct autogroup *autogroup;
> >+#endif
> > };
> >
> >Kind,
> >
> >Jordi Pujol
> 
> Thanks Jordi, but my last attempted build, using only the last 2 patches 
> that Mike posted on a fresh unpack of 2.6.36, couldn't get past stage 2 of 
> the modules build, it kept squawking about all the IR control stuff that is 
> not even configured to be built.

No idea what's going on with that.  Maybe you should wait until I get
the /proc display/tweak interface cobbled together and post a checked
over patch instead of hasty WIP snapshot.

> I wonder how long it will take to get work this into mainline?

If it goes in at all, it won't be before .38.

> Along the same line, how does this compare to CK's bfs patch?

Like apple vs orange.

	-Mike

