Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab2IHHwh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 03:52:37 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:46648 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab2IHHwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 03:52:34 -0400
Date: Sat, 8 Sep 2012 13:19:04 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes: Do not (ab)use
 TIF_SINGLESTEP/user_*_single_step() for single-stepping
Message-ID: <20120908074904.GS30238@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120903152525.GA9028@redhat.com>
 <20120903152613.GA9078@redhat.com>
 <20120907151111.GQ30238@linux.vnet.ibm.com>
 <20120907155057.GA1669@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120907155057.GA1669@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12090807-3864-0000-0000-000004893BA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-07 17:50:57]:

> On 09/07, Srikar Dronamraju wrote:
> >
> > Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
> Thanks!
> 
> (and thanks, I'll fix the typo in 2/7 you pointed out)
> 
> > >  void arch_uprobe_enable_step(struct arch_uprobe *auprobe)
> > >  {
> > > -	struct uprobe_task	*utask		= current->utask;
> > > -	struct arch_uprobe_task	*autask		= &utask->autask;
> > > +	struct task_struct *task = current;
> >
> > Any particular reason to use task instead of current?
> 
> No particular reason, and I think in this case asm will be the same.
> 
> Please let me know if you prefer to remove this variable, I'll redo
> this patch.

No, the patch is fine.

I have no problem with the additional variable, I was just curious if
you had any other plans that needed that a exta variable that alls.

-- 
thanks and regards
Srikar

