Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab1A0KcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 05:32:13 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45100 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab1A0KcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 05:32:12 -0500
Date: Thu, 27 Jan 2011 15:55:27 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH 2.6.37-rc5-tip 5/20]  5: Uprobes:
 register/unregister probes.
Message-ID: <20110127102527.GT19725@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20101216095817.23751.76989.sendpatchset@localhost6.localdomain6>
 <1295957744.28776.722.camel@laptop>
 <20110126075558.GB19725@linux.vnet.ibm.com>
 <1296036708.28776.1138.camel@laptop>
 <20110126153036.GN19725@linux.vnet.ibm.com>
 <1296056756.28776.1247.camel@laptop>
 <20110126165645.GP19725@linux.vnet.ibm.com>
 <1296061949.28776.1343.camel@laptop>
 <20110127100157.GS19725@linux.vnet.ibm.com>
 <1296123817.15234.57.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1296123817.15234.57.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-01-27 11:23:37]:

> On Thu, 2011-01-27 at 15:31 +0530, Srikar Dronamraju wrote:
> > > > >  - validate that the vma is indeed a map of the right inode
> > > > 
> > > > We can add a check in write_opcode( we need to pass the inode to
> > > > write_opcode).
> > > 
> > > sure..
> > > 
> > > > >  - validate that the offset of the probe corresponds with the stored
> > > > > address
> > > > 
> > > > I am not clear on this. We would have derived the address from the
> > > > offset. So is that we check for
> > > >  (vaddr == vma->vm_start + uprobe->offset)
> > > 
> > > Sure, but the vma might have changed since you computed the offset -)
> > 
> > If the vma has changed then it would fail the 2nd validation i.e vma
> > corresponds to the uprobe inode right. If the vma was unmapped and
> > mapped back at the same place, then I guess we are okay to probe.
> 
> It can be unmapped and mapped back slightly different. A map of the same
> file doesn't need to mean its in the exact same location or has the
> exact same pgoffset.
> 
> 

If its not at the exact same location, then our third validation of
checking that (vaddr == vma->vm_start + uprobe->offset)  should fail
right?

Also should it be (vaddr == uprobe->offset + vma->vm_start -
vma->pgoff << PAGE_SHIFT) ?

-- 
Thanks and Regards
Srikar
