Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab1FIFzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 01:55:05 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50122 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab1FIFzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 01:55:02 -0400
Date: Thu, 9 Jun 2011 11:17:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 13/22] 13: uprobes: Handing int3 and
 singlestep exception.
Message-ID: <20110609054754.GD6123@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607130051.28590.68088.sendpatchset@localhost6.localdomain6>
 <20110608221141.GB9965@wicker.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110608221141.GB9965@wicker.gateway.2wire.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > + */
> > +int uprobe_post_notifier(struct pt_regs *regs)
> > +{
> > +	struct uprobe *uprobe;
> > +	struct uprobe_task *utask;
> > +
> > +	if (!current->mm || !current->utask || !current->utask->active_uprobe)
> > +		/* task is currently not uprobed */
> > +		return 0;
> > +
> > +	utask = current->utask;
> > +	uprobe = utask->active_uprobe;
> > +	if (!uprobe)
> > +		return 0;
> > +
> > +	set_thread_flag(TIF_UPROBE);
> > +	return 1;
> > +}
> 
> Looks like this can be simplified.  If current->utask->active_uprobe is
> non-null then surely the assignment to uprobe will be too?
> 

Yes, the two lines where we check for !uprobe and return are redundant
and can be removed. Will be corrected in the next patchset.

-- 
Thanks and Regards
Srikar
