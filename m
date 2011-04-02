Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1DBB3w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 21:29:52 -0400
Received: from mout.perfora.net ([74.208.4.195]:56560 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173Ab1DBB3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 21:29:51 -0400
Date: Fri, 1 Apr 2011 21:29:09 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
Message-ID: <20110402012909.GA2779@fibrous.localdomain>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6> <20110401143338.15455.98645.sendpatchset@localhost6.localdomain6> <20110402002633.GA13277@fibrous.localdomain> <20110402005353.GA17416@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110402005353.GA17416@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:/PRKobKLKkxciyBwIl3mlyqXxD9jr1vUW+Q6uzNx0Bd
 Y7ZIHanbj3u/rKWaB57Dp8BHiLC8ugPWHnV86waKZ0teBfs95t
 IPM0eswl1MDIIWdCT6tg6mUaXxEqv2W+dAUAYF7BzzhaQIKp+U
 0eGEDYpbnuGJ50wJ53llSL3CoRY8q9EmmLoeijHEZGL60Y5kTD
 q3FreBKLrpTgnySI0tOtinb9obFWukhXI76C5WvGtc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 02, 2011 at 06:23:53AM +0530, Srikar Dronamraju wrote:
> > > +
> > > +		mm = vma->vm_mm;
> > > +		if (!valid_vma(vma)) {
> > > +			mmput(mm);
> > > +			continue;
> > > +		}
> > > +
> > > +		vaddr = vma->vm_start + offset;
> > > +		vaddr -= vma->vm_pgoff << PAGE_SHIFT;
> > 
> > What happens here when someone passes an offset that is out of bounds
> > for the vma?  Looks like we could oops when the kernel tries to set a
> > breakpoint.  Perhaps check wrt ->vm_end?
> > 
> 
> If the offset is wrong, install_uprobe will fail, since
> grab_cache_page() should not be able to find that page for us.
> And hence we return gracefully.

Hummm.  But grab_cache_page() just wraps find_or_create_page(), so I don't
think it will do what you want.


> I will surely test this case and I am happy to add a check for
> vm_end.

Thanks!


-- 
steve

