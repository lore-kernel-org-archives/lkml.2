Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2EHUps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 16:45:48 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:42703 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753681Ab2EHUpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 16:45:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: IlP0QK4VM1mTsj5r.bJFgNBO5jIDNw58NPYToSQaRAnHnpc
 VCfVS5KT90Rjt_ujid_m1QfWVcEelIMq1fkkyvxnp0pH2cmjYTbbPGpnV3Ce
 EnVGfbFsanWOltXq9Tto0dRJ975f1sAxjRjrltEi5bMhNh3NCxeN9qkzwSh6
 LaJ3A4SRI96wY1MvX80j3bAgc4GjHZ.i_.h3Wb0kG_bORbETntDpSeCe57PN
 MA8QeYl5lOQ9nsVVfF.q8591vxFGdrKZQAku.7lMvS431ddgSvPfZqygJrO3
 41iJZHb2VtNdqi95YU0fKRHZO3iP6CcbO_MqkDo8qh7TJ_vfk6Qdh34jsFT4
 ZnyiciAGPG378Avl5bW7_VeLH08EXlvkLSZhLn55q4TdtK6uRSnSS_IFYBe4
 W
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 8 May 2012 15:45:38 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mike Galbraith <efault@gmx.de>
cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linaro-sched-sig@lists.linaro.org,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Kevin Hilman <khilman@ti.com>, Max Krasnyansky <maxk@qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/41] cpuset: Set up interface for nohz flag
In-Reply-To: <1336506601.7400.21.camel@marge.simpson.net>
Message-ID: <alpine.DEB.2.00.1205081541010.1391@router.home>
References: <1335830115-14335-1-git-send-email-fweisbec@gmail.com> <1335830115-14335-8-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.1205071053070.1060@router.home> <CAFTL4hymuHZOGssX2UShg0kL-XkCKQYtG6X=Vt9PmKj4EwtAgA@mail.gmail.com>
 <1336488626.16236.41.camel@twins> <alpine.DEB.2.00.1205081016370.27713@router.home> <1336490832.8226.5.camel@twins> <alpine.DEB.2.00.1205081035550.27713@router.home> <1336492081.8226.13.camel@twins> <alpine.DEB.2.00.1205081054310.27713@router.home>
 <1336493768.8226.29.camel@twins> <1336506601.7400.21.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2012, Mike Galbraith wrote:

> On Tue, 2012-05-08 at 18:16 +0200, Peter Zijlstra wrote:
> > On Tue, 2012-05-08 at 10:57 -0500, Christoph Lameter wrote:
>
> > isolcpus is a very limited hack that adds more pain that its worth. Its
> > yet another mask to check and its functionality is completely available
> > through cpusets.
>
> Agreed.

How would that work? By creating cpusets that only have a single cpu in
them?

> > You cannot cree multi-cpu partitions using isolcpus, you cannot
> > dynamically reconfigure it.
>
> Big plus for cpusets.

Why would you want to do anything like it? cpusets are confusing. You can
have a cpu be part of multiple cpusets. Which nohz setting applies for a
particular cpu then? If any of the cpusets have nohz set then it applies
to the cpu? And thus someone in a cpuset that does not has nohz set will
find that a cpu will have nohz functionality?

Its not a good match for this. You would want a per cpu attribute for
nohz.

> > And on the scheduler side cpusets doesn't add runtime overhead to normal
> > things, only sched_setaffinity() and a few other rare operations get
> > slightly more expensive. And it allows to reduce runtime overhead by
> > making the load-balancer domains smaller.
>
> Very big deal if you have a load that doesn't do all the performance 'i'
> dotting and 't' crossing it maybe could have, but ends up on a big box.

isolcpus are not part of load balancer domains.
