Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab1JGRDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:03:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab1JGRDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:03:08 -0400
Date: Fri, 7 Oct 2011 18:58:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
Message-ID: <20111007165828.GA32319@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20110920120517.25326.57657.sendpatchset@srdronam.in.ibm.com> <1317128626.15383.61.camel@twins> <20110927131213.GE3685@linux.vnet.ibm.com> <20111005180139.GA5704@redhat.com> <20111006054710.GB17591@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111006054710.GB17591@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06, Srikar Dronamraju wrote:
>
> The patch (that I sent out as part of v5 patchset) uses per task
> pending sigqueue and start queueing the signals when the task
> singlesteps. After completion of singlestep, walks thro the pending
> signals.

Yes, I see. Doesn't look very nice ;)

> But I was thinking if I should block signals instead of queueing them in
> a different sigqueue. So Idea is to block signals just before the task
> enables singlestep and unblock after task disables singlestep.

Agreed, this looks much, much better. In both cases the task is current,
it is safe to change ->blocked.

But please avoid sigprocmask(), we have set_current_blocked().

Oleg.

