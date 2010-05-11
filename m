Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab0EKUcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:32:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47493 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703Ab0EKUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:32:34 -0400
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
In-Reply-To: <20100420153023.GA9351@redhat.com>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6>
	 <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
	 <20100413183537.GA17538@redhat.com>
	 <20100415093506.GA2064@linux.vnet.ibm.com>
	 <20100419193139.GA24080@redhat.com>
	 <20100420124358.GA20675@linux.vnet.ibm.com>
	 <20100420153023.GA9351@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 22:32:18 +0200
Message-ID: <1273609938.1810.81.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-20 at 17:30 +0200, Oleg Nesterov wrote:
> > >     - I don't really understand why ->handler_in_interrupt is really
> > >       useful, but never mind.
> >
> > There is a small overhead when running the handlers in task context.
> 
> Sure, but
> 
> > overhead of task over interrupt =  (1.016851 - .907400) = .109451 usec
> > % additional overhead = (.109451/.907400) * 100 = 12.062%
> 
> this overhead looks very minor. To me, it is better to simplify the
> code, at least in the first version.
> 
> That said, this is up to you, I am not asking you to remove this
> optimization. Just imho. 

Right so what I've suggested several times it to simply call the same
handler in both contexts. If it returns -EFAULT, set TIF_UPROBE or
whatever and try again from task context.



