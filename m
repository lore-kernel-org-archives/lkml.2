Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab1KXOwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:52:49 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:44227 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1KXOwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:52:47 -0500
Date: Thu, 24 Nov 2011 20:21:39 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>, tulasidhard@gmail.com
Subject: Re: Fwd: uprobes: register/unregister probes.
Message-ID: <20111124145139.GK28065@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <hYuXv-26J-3@gated-at.bofh.it>
 <hYuXw-26J-5@gated-at.bofh.it>
 <i0nRU-7eK-11@gated-at.bofh.it>
 <603b0079-5f54-4299-9a9a-a5e237ccca73@l23g2000pro.googlegroups.com>
 <20111124070303.GB28065@linux.vnet.ibm.com>
 <1322128199.2921.3.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322128199.2921.3.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112414-3352-0000-0000-000000F6B5C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2011-11-24 10:49:59]:

> On Thu, 2011-11-24 at 12:33 +0530, Srikar Dronamraju wrote:
> > > On Fri, 2011-11-18 at 16:37 +0530, Srikar Dronamraju wrote:
> > > > +int register_uprobe(struct inode *inode, loff_t offset,
> > > > +                               struct uprobe_consumer *consumer)
> > > > +{
> > > > +       struct uprobe *uprobe;
> > > > +       int ret = -EINVAL;
> > > > +
> > > > +       if (!consumer || consumer->next)
> > > > +               return ret;
> > > > +
> > > > +       inode = igrab(inode);
> > > 
> > > So why are you dealing with !consumer but not with !inode? and why
> > > does
> > > it make sense to allow !consumer at all?
> > > 
> > 
> > 
> > I am not sure if I got your comment correctly.
> > 
> > I do check for inode just after the igrab.
> 
> No you don't, you check the return value of igrab(), but you crash hard
> when someone calls register_uprobe(.inode=NULL).
> 

Okay. will add a check for inode before we do the igrab.

> > I am actually not dealing with !consumer.
> > If the consumer is NULL, then we dont have any handler to run so why
> > would we want to register such a probe?
> 
> Why allow someone calling register_uprobe(.consumer=NULL) to begin with?
> That doesn't make any sense.
> 
> > Also if consumer->next is Non-NULL, that means that this consumer was
> > already used.  Reusing the consumer, can result in consumers list getting
> > broken into two.
> 
> Yeah, although at that point why be nice about it? Just but a WARN_ON()
> in or so.
> 

I thought you werent happy with prints and WARN_ON/BUG_ON unless it was
really really necessary. If we were to have a WARN_ON for a wrong
consumer passed, then we would need a warn_On for NULL inode too.

So I think we should leave this as is.

Unless I have commented, I agree to your comments sent in other threads
and will resolve them accordingly.

-- 
Thanks and Regards
Srikar

