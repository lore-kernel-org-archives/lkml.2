Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab1LAWTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:19:42 -0500
Received: from mail.openrapids.net ([64.15.138.104]:39407 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754543Ab1LAWTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:19:41 -0500
Date: Thu, 1 Dec 2011 17:19:40 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Greg KH <greg@kroah.com>
Cc: Christoph Hellwig <hch@infradead.org>, devel@driverdev.osuosl.org,
        lttng-dev@lists.lttng.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David McCullough <davidm@snapgear.com>,
        D Jeff Dionne <jeff@uClinux.org>, Greg Ungerer <gerg@snapgear.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/11] mm: export vmalloc_sync_all symbol to GPL modules
Message-ID: <20111201221940.GD10552@Krystal>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com> <1322775683-8741-2-git-send-email-mathieu.desnoyers@efficios.com> <20111201215700.GA16782@infradead.org> <20111201221337.GB3365@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201221337.GB3365@kroah.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 17:15:15 up 373 days,  3:18,  6 users,  load average: 0.03, 0.05,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH (greg@kroah.com) wrote:
> On Thu, Dec 01, 2011 at 04:57:00PM -0500, Christoph Hellwig wrote:
> > On Thu, Dec 01, 2011 at 04:41:13PM -0500, Mathieu Desnoyers wrote:
> > > LTTng needs this symbol exported. It calls it to ensure its tracing
> > > buffers and allocated data structures never trigger a page fault. This
> > > is required to handle page fault handler tracing and NMI tracing
> > > gracefully.
> > 
> > We:
> > 
> >  a) don't export symbols unless they have an intree-user
> 
> lttng is now in-tree in the drivers/staging/ area.  See linux-next for
> details if you are curious.
> 
> >  b) especially don't export something as lowlevel as this one.
> 
> Mathieu, there's nothing else you can do to get this information?  Or
> does lttng really want such lowlevel data?

LTTng calls vmalloc_sync_all() to make sure it won't crash the system
(due to recursive page fault) when hooking on the page fault handler and
on any hook that would happen to sit in a function hit by NMI context.
So it really goes beyond just extracting information for this one I'm
afraid: it's a matter of execution correctness.

This is a point I'm really anal about: the tracer should _never_ crash
the traced system, _ever_, in any foreseeable condition.

Thanks,

Mathieu

> 
> thanks,
> 
> greg k-h

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
