Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab1KXJvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:51:32 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59492 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab1KXJva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:51:30 -0500
Date: Thu, 24 Nov 2011 15:19:56 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20111124094956.GC28065@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <hYuXv-26J-3@gated-at.bofh.it>
 <hYuXw-26J-5@gated-at.bofh.it>
 <i0nRU-7eK-11@gated-at.bofh.it>
 <603b0079-5f54-4299-9a9a-a5e237ccca73@l23g2000pro.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <603b0079-5f54-4299-9a9a-a5e237ccca73@l23g2000pro.googlegroups.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112409-6078-0000-0000-000004CAF119
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +       mutex_unlock(uprobes_hash(inode));
> > +       put_uprobe(uprobe);
> > +
> > +reg_out:
> > +       iput(inode);
> > +       return ret;
> > +}
> 
> So if this function returns an error the caller is responsible for
> cleaning up consumer, otherwise we take responsibility.

The caller is always responsible to cleanup the consumer. 
The only field we touch in the consumer is the next; thats because 
we use to link up the consumers.

-- 
Thanks and Regards
Srikar

