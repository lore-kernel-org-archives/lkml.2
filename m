Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965243Ab2CBOwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:52:11 -0500
Received: from www.linutronix.de ([62.245.132.108]:43185 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2CBOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:52:09 -0500
Date: Fri, 2 Mar 2012 15:52:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Carsten Emde <C.Emde@osadl.org>, John Kacur <jkacur@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>
Subject: Re: [PATCH RT 7/9][RFC] [PATCH 7/9] cpu/rt: Rework cpu down for
 PREEMPT_RT
In-Reply-To: <20120301190346.172835662@goodmis.org>
Message-ID: <alpine.LFD.2.02.1203021518501.2742@ionos>
References: <20120301185527.064629423@goodmis.org> <20120301190346.172835662@goodmis.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2012, Steven Rostedt wrote:
> Bringing a CPU down is a pain with the PREEMPT_RT kernel because
> tasks can be preempted in many more places than in non-RT. In
> order to handle per_cpu variables, tasks may be pinned to a CPU
> for a while, and even sleep. But these tasks need to be off the CPU
> if that CPU is going down.
> 
> Several synchronization methods have been tried, but when stressed
> they failed. This is a new approach.

OMG! That hotplug stuff has been ugly as hell already, but you managed
to make it exponentially worse. That's really an achievement.
 
Instead of adding more mess, we should simply fix hotplug. 

We can migrate away all tasks _before_ we run stomp-machine and
prevent that any new tasks go on the cpu which is about to be taken
down. Once all migratable tasks are gone, we only have to deal with
the cpu bound ones, which is not causing such headaches.

So no, I rather keep the current problem than applying that insanity.

Thanks,

	tglx
