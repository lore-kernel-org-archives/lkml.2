Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2GZP50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:57:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab2GZP5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:57:24 -0400
Date: Thu, 26 Jul 2012 17:54:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Peter Boonstoppel <pboonstoppel@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Andy Walls <awalls@md.metrocast.net>,
        Diwakar Tundlam <dtundlam@nvidia.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/1] kthread: disable preemption during complete()
Message-ID: <20120726155409.GB20964@redhat.com>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D364859@HQMAIL04.nvidia.com> <20120725000901.GA5304@google.com> <5FBF8E85CA34454794F0F7ECBA79798F379D36485E@HQMAIL04.nvidia.com> <20120725224044.GC32378@google.com> <1343289850.26034.79.camel@twins> <alpine.LFD.2.02.1207261242240.32033@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1207261242240.32033@ionos>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26, Thomas Gleixner wrote:
>
> On Thu, 26 Jul 2012, Peter Zijlstra wrote:
> > On Wed, 2012-07-25 at 15:40 -0700, Tejun Heo wrote:
> > > > This patch disables preemption during complete(), since we call
> > > > schedule() directly afterwards, so it will correctly enter
> > > > TASK_UNINTERRUPTIBLE. This speeds up kthread creation/binding during
> > > > cpu hotplug significantly.
> >
> > tglx has patches that make the kthread create/destroy stuff from hotplug
> > go away.. that seems like the better approach.
>
> Right. That cpu hotplug setup/teardown stuff is ugly.

Could you cc me if you send these patches?

> > The comment doesn't really make that clear.
>
> Right, the comment is crap. It has nothing to do with kthread_bind()
> and stuff. The whole purpose is to avoid the pointless preemption
> after wakeup.

Yes, but this "avoid the preemption after wakeup" can actually help
kthread_bind()->wait_task_inactive() ?

This reminds me, Peter had a patch which teaches wait_task_inactive()
to use sched_in/sched_out notifiers to avoid the polling...

Oleg.

