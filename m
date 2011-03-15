Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758231Ab1CORvN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 13:51:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab1CORvJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 13:51:09 -0400
Subject: Re: [PATCH v2 2.6.38-rc8-tip 5/20] 5: Uprobes: register/unregister
 probes.
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1300211262.9910.295.camel@gandalf.stny.rr.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314133454.27435.81020.sendpatchset@localhost6.localdomain6>
	 <alpine.LFD.2.00.1103151439400.2787@localhost6.localdomain6>
	 <20110315171536.GA24254@linux.vnet.ibm.com>
	 <1300211262.9910.295.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 15 Mar 2011 18:50:11 +0100
Message-ID: <1300211411.2203.290.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 13:47 -0400, Steven Rostedt wrote:
> On Tue, 2011-03-15 at 22:45 +0530, Srikar Dronamraju wrote:
> > > > +   }
> > > > +   list_for_each_entry_safe(mm, tmpmm, &tmp_list, uprobes_list) {
> > > > +           down_read(&mm->mmap_sem);
> > > > +           if (!install_uprobe(mm, uprobe))
> > > > +                   ret = 0;
> > > 
> > > Installing it once is success ?
> > 
> > This is a little tricky. My intention was to return success even if one
> > install is successful. If we return error, then the caller can go
> > ahead and free the consumer. Since we return success if there are
> > currently no processes that have mapped this inode, I was tempted to
> > return success on atleast one successful install.
> 
> What about an all or nothing approach. If one fails, remove all that
> were installed, and give up.

That sounds like a much saner semantic and is what we generally do in
the kernel.
