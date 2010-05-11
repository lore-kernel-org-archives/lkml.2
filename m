Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab0EKVBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 17:01:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59963 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab0EKVBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 17:01:47 -0400
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
From: Peter Zijlstra <peterz@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>
In-Reply-To: <20100511205759.GD14992@redhat.com>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6>
	 <20100331155228.4181.61294.sendpatchset@localhost6.localdomain6>
	 <20100413183537.GA17538@redhat.com>
	 <20100415093506.GA2064@linux.vnet.ibm.com>
	 <20100419193139.GA24080@redhat.com>
	 <20100420124358.GA20675@linux.vnet.ibm.com>
	 <20100420153023.GA9351@redhat.com> <1273609938.1810.81.camel@laptop>
	 <20100511205759.GD14992@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 23:01:44 +0200
Message-ID: <1273611704.1810.136.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-11 at 16:57 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Tue, May 11, 2010 at 10:32:18PM +0200, Peter Zijlstra wrote:
> > [...]
> > Right so what I've suggested several times it to simply call the same
> > handler in both contexts. If it returns -EFAULT, set TIF_UPROBE or
> > whatever and try again from task context.
> 
> That could work, but random partial execution & restart of the handler
> will make it tricky to write a single handler that reliably produces
> results.  It would likely need a flag to indicate that it failed
> previously so as to throw away partial results.

Or it shouldn't leave half-assed state around to begin with.

