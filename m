Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab0CWL0V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:26:21 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:59321 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0CWL0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:26:20 -0400
Date: Tue, 23 Mar 2010 16:56:15 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v1 4/10] User Space Breakpoint Assistance Layer
Message-ID: <20100323112615.GB16818@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100320142455.11427.76925.sendpatchset@localhost6.localdomain6>
 <20100320142541.11427.98291.sendpatchset@localhost6.localdomain6>
 <20100322214009.bb90d6e2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100322214009.bb90d6e2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > User Space Breakpoint Assistance Layer (USER_BKPT)
> > 
> 
> A quick scan, just to show I was paying attention ;)

Thanks for taking a look and commenting on the code.

> 
> > +int user_bkpt_read_vm(struct task_struct *tsk, unsigned long vaddr,
> > +						void *kbuf, int nbytes)
> > +{
> > +	if (tsk == current) {
> > +		int nleft = copy_from_user(kbuf, (void __user *) vaddr,
> > +				nbytes);
> > +		return nbytes - nleft;
> > +	} else
> > +		return access_process_vm(tsk, vaddr, kbuf, nbytes, 0);
> > +}
> 
> copy_from_user() takes and returns an unsigned long arg but this
> function is converting these to and from ints.  That's OK if we're 100%
> sure that we'll never get or return an arg >2G.  Otherwise things could
> get ghastly.  Please have a think.  (Dittoes for some other functionss
> around here).
> 

nbytes would not be greater than the maximum size of a instruction for
that architecture. Hence I dont see it going above 2G. However I will
take a relook.


I will rework the rest of the comments as suggested by you.
It would be part of the next version.

--
Thanks and Regards
Srikar
