Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2HAHOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 03:14:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:48586 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2HAHOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 03:14:33 -0400
Date: Wed, 1 Aug 2012 09:14:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Boonstoppel <pboonstoppel@nvidia.com>
cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Andy Walls <awalls@md.metrocast.net>,
        Diwakar Tundlam <dtundlam@nvidia.com>, Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: RE: [PATCH 1/1] kthread: disable preemption during complete()
In-Reply-To: <5FBF8E85CA34454794F0F7ECBA79798F379D364860@HQMAIL04.nvidia.com>
Message-ID: <alpine.LFD.2.02.1208010913030.32033@ionos>
References: <5FBF8E85CA34454794F0F7ECBA79798F379D364859@HQMAIL04.nvidia.com>  <20120725000901.GA5304@google.com>  <5FBF8E85CA34454794F0F7ECBA79798F379D36485E@HQMAIL04.nvidia.com>  <20120725224044.GC32378@google.com> <1343289850.26034.79.camel@twins>,<alpine.LFD.2.02.1207261242240.32033@ionos>
 <5FBF8E85CA34454794F0F7ECBA79798F379D364860@HQMAIL04.nvidia.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012, Peter Boonstoppel wrote:

> > > tglx has patches that make the kthread create/destroy stuff from hotplug
> > > go away.. that seems like the better approach.
> 
> > Right. That cpu hotplug setup/teardown stuff is ugly.
> 
> If that stuff gets removed complete that's great. The only change I'm aware of right now is the workqueue one: http://thread.gmane.org/gmane.linux.kernel/1329164
> 
> > > The main thing is avoiding the wakeup preemption from the complete()
> > > because we're going to sleep right after anyway.
> 
> You are very likely to be preempted by the complete(), since the newly created thread has a relatively high vruntime.
> 
> > > The comment doesn't really make that clear.
> 
> > Right, the comment is crap. It has nothing to do with kthread_bind()
> > and stuff. The whole purpose is to avoid the pointless preemption
> > after wakeup.
> 
> The only case I want to solve is the kthread_bind()->wait_task_inactive() scenario. On our platforms this patch reduces average cpu_up() time from about 9ms to 8ms, but max time goes down from 37ms to 8.5ms. cpu_up() latency becomes much more predictable.
> 

There is a bunch of patches in the queue, which kills the full
setup/teardown of per cpu threads and puts those threads into a "park"
position instead.

Thanks,

	tglx
