Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1DBBDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 21:03:50 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45076 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab1DBBDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 21:03:48 -0400
Date: Sat, 2 Apr 2011 06:23:53 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2.6.39-rc1-tip 6/26]  6: Uprobes:
 register/unregister probes.
Message-ID: <20110402005353.GA17416@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143338.15455.98645.sendpatchset@localhost6.localdomain6>
 <20110402002633.GA13277@fibrous.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110402002633.GA13277@fibrous.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +		mm = vma->vm_mm;
> > +		if (!valid_vma(vma)) {
> > +			mmput(mm);
> > +			continue;
> > +		}
> > +
> > +		vaddr = vma->vm_start + offset;
> > +		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> 
> What happens here when someone passes an offset that is out of bounds
> for the vma?  Looks like we could oops when the kernel tries to set a
> breakpoint.  Perhaps check wrt ->vm_end?
> 

If the offset is wrong, install_uprobe will fail, since
grab_cache_page() should not be able to find that page for us.
And hence we return gracefully.

I will surely test this case and I am happy to add a check for
vm_end.

-- 
Thanks and Regards
Srikar
