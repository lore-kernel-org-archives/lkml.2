Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1DURTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 13:19:11 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38759 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755108Ab1DURTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 13:19:10 -0400
Date: Thu, 21 Apr 2011 22:33:55 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 15/26] 15: uprobes: Handing int3 and
 singlestep exception.
Message-ID: <20110421170355.GH10698@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143527.15455.32854.sendpatchset@localhost6.localdomain6>
 <1303220359.8345.1.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1303220359.8345.1.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-04-19 15:39:19]:

> On Fri, 2011-04-01 at 20:05 +0530, Srikar Dronamraju wrote:
> > +               probept = uprobes_get_bkpt_addr(regs);
> > +               down_read(&mm->mmap_sem);
> > +               for (vma = mm->mmap; vma; vma = vma->vm_next) {
> > +                       if (!valid_vma(vma))
> > +                               continue;
> > +                       if (probept < vma->vm_start || probept > vma->vm_end)
> > +                               continue;
> > +                       u = find_uprobe(vma->vm_file->f_mapping->host,
> > +                                       probept - vma->vm_start);
> > +                       break;
> > +               }
> 
> Why the linear vma walk? Surely the find_vma() suffices since there can
> only be one vma that matches a particular vaddr.


Agree, will incorporate.

-- 
Thanks and Regards
Srikar
> 
> > +               up_read(&mm->mmap_sem); 
