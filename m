Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965400Ab2DLO5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 10:57:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37404 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965169Ab2DLO53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 10:57:29 -0400
Date: Thu, 12 Apr 2012 20:19:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH UPDATED 3/3] tracing: Provide trace events interface
 for uprobes
Message-ID: <20120412144927.GB21587@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120409091133.8343.65289.sendpatchset@srdronam.in.ibm.com>
 <20120409091154.8343.50489.sendpatchset@srdronam.in.ibm.com>
 <20120411103043.GB29437@linux.vnet.ibm.com>
 <4F86D264.9020004@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F86D264.9020004@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041214-6148-0000-0000-000004FD7F04
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +    # echo 'p /bin/zsh:0x46420 %ip %ax' > uprobe_events
> > +
> > +Please note: User has to explicitly calculate the offset of the probepoint
> > +in the object. We can see the events that are registered by looking at the
> > +uprobe_events file.
> > +
> > +    # cat uprobe_events
> > +    p:uprobes/p_zsh_0x46420 /bin/zsh:0x0000000000046420
> 
> Doesn't uprobe_events show the arguments of existing events?
> And also, could you add an event format of above event here?
> 

[root@f14kvm tracing]#  cat uprobe_events 
[root@f14kvm tracing]# echo 'p /bin/zsh:0x46420 %ip %ax' > uprobe_events 
[root@f14kvm tracing]#  cat uprobe_events 
p:uprobes/p_zsh_0x46420 /bin/zsh:0x00046420 arg1=%ip arg2=%ax
[root@f14kvm tracing]#  cat events/uprobes/p_zsh_0x46420/format 
name: p_zsh_0x46420
ID: 922
format:
        field:unsigned short common_type;       offset:0;       size:2; signed:0;
        field:unsigned char common_flags;       offset:2;       size:1; signed:0;
        field:unsigned char common_preempt_count;       offset:3;       size:1; signed:0;
        field:int common_pid;   offset:4;       size:4; signed:1;
        field:int common_padding;       offset:8;       size:4; signed:1;

        field:unsigned long __probe_ip; offset:12;      size:4; signed:0;
        field:u32 arg1; offset:16;      size:4; signed:0;
        field:u32 arg2; offset:20;      size:4; signed:0;

print fmt: "(%lx) arg1=%lx arg2=%lx", REC->__probe_ip, REC->arg1, REC->arg2
[root@f14kvm tracing]# 

Will update the Documentation file  with correct output of "cat
uprobe_events". Do you want the format file to be added to the
Documentation?

-- 
Thanks and Regards
Srikar

