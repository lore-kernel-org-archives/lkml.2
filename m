Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935682Ab1JFGEn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 02:04:43 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37136 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935657Ab1JFGEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 02:04:41 -0400
Date: Thu, 6 Oct 2011 11:17:10 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 26/26]   uprobes: queue signals while
 thread is singlestepping.
Message-ID: <20111006054710.GB17591@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com>
 <20110920120517.25326.57657.sendpatchset@srdronam.in.ibm.com>
 <1317128626.15383.61.camel@twins>
 <20110927131213.GE3685@linux.vnet.ibm.com>
 <20111005180139.GA5704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20111005180139.GA5704@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2011-10-05 20:01:39]:

> Srikar, I am still reading this series, need more time to read this
> patch, but:

Okay, 

> 
> On 09/27, Srikar Dronamraju wrote:
> >
> > I did a rethink and implemented this patch a little differently using
> > block_all_signals, unblock_all_signals. This wouldnt need the
> > #ifdeffery + no changes in kernel/signal.c
> 
> No, Please don't. block_all_signals() must be killed. This interface
> simply do not work. At all. It is buggy as hell. I guess I should ping
> David Airlie again.
> 

I could use sigprocmask instead of block_all_signals.

The patch (that I sent out as part of v5 patchset) uses per task
pending sigqueue and start queueing the signals when the task
singlesteps. After completion of singlestep, walks thro the pending
signals.

But I was thinking if I should block signals instead of queueing them in
a different sigqueue. So Idea is to block signals just before the task
enables singlestep and unblock after task disables singlestep.

Instead of using block_all_signals, I could use sigprocmask to achieve
the same.

Which approach do you suggest or do you have any other approach to look
at?

-- 
Thanks and Regards
Srikar


