Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778Ab2ILMiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 08:38:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36298 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2ILMiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:38:07 -0400
Date: Wed, 12 Sep 2012 18:03:45 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] uprobes: single-step fixes
Message-ID: <20120912123345.GC9582@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120903152525.GA9028@redhat.com>
 <20120908170601.GA19311@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120908170601.GA19311@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091212-6148-0000-0000-000009939904
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-08 19:06:01]:

> On 09/03, Oleg Nesterov wrote:
> >
> > Sebastian, I changed your patches a bit:
> >
> > 	1/7:
> >
> > 		- Change the subject and update the changelog. In particular,
> > 		  s/utrace/uprobes/. I am wondering where this typo came from ;)
> 
> Hmm. I just noticed this patch is buggy. arch_uprobe_disable_step(&uprobe->arch)
> is not safe after put_uprobe().
> 
> Srikar, I fixed this in my tree with the following change,
> 
> 	--- kernel/events/uprobes.c~	2012-09-02 16:52:54.000000000 +0200
> 	+++ kernel/events/uprobes.c	2012-09-08 18:56:44.000000000 +0200
> 	@@ -1536,10 +1536,10 @@ static void handle_singlestep(struct upr
> 		else
> 			WARN_ON_ONCE(1);
> 	 
> 	+	arch_uprobe_disable_step(&uprobe->arch);
> 		put_uprobe(uprobe);
> 		utask->active_uprobe = NULL;
> 		utask->state = UTASK_RUNNING;
> 	-	arch_uprobe_disable_step(&uprobe->arch);
> 		xol_free_insn_slot(current);
> 	 
> 		spin_lock_irq(&current->sighand->siglock);
> 
> I hope your ack is still valid.
> 

Yes, Please merge this into 1/7 patch.

-- 
Thanks and Regards
Srikar

