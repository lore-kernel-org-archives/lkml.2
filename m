Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab1LAXAT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 18:00:19 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:58917 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755172Ab1LAXAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 18:00:17 -0500
X-Sasl-enc: NEkFB9TgnCaHCcmsB/xvaKfRhmuONNX4mVyae6FnrO5y 1322780416
Date: Thu, 1 Dec 2011 14:41:28 -0800
From: Greg KH <greg@kroah.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
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
Message-ID: <20111201224128.GB3716@kroah.com>
References: <1322775683-8741-1-git-send-email-mathieu.desnoyers@efficios.com>
 <1322775683-8741-2-git-send-email-mathieu.desnoyers@efficios.com>
 <20111201215700.GA16782@infradead.org>
 <20111201221337.GB3365@kroah.com>
 <20111201221940.GD10552@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201221940.GD10552@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 05:19:40PM -0500, Mathieu Desnoyers wrote:
> * Greg KH (greg@kroah.com) wrote:
> > On Thu, Dec 01, 2011 at 04:57:00PM -0500, Christoph Hellwig wrote:
> > > On Thu, Dec 01, 2011 at 04:41:13PM -0500, Mathieu Desnoyers wrote:
> > > > LTTng needs this symbol exported. It calls it to ensure its tracing
> > > > buffers and allocated data structures never trigger a page fault. This
> > > > is required to handle page fault handler tracing and NMI tracing
> > > > gracefully.
> > > 
> > > We:
> > > 
> > >  a) don't export symbols unless they have an intree-user
> > 
> > lttng is now in-tree in the drivers/staging/ area.  See linux-next for
> > details if you are curious.
> > 
> > >  b) especially don't export something as lowlevel as this one.
> > 
> > Mathieu, there's nothing else you can do to get this information?  Or
> > does lttng really want such lowlevel data?
> 
> LTTng calls vmalloc_sync_all() to make sure it won't crash the system
> (due to recursive page fault) when hooking on the page fault handler and
> on any hook that would happen to sit in a function hit by NMI context.
> So it really goes beyond just extracting information for this one I'm
> afraid: it's a matter of execution correctness.

Ok, fair enough.

Christoph, is there any other way to achive something like this without
this symbol being exported that you know of?

thanks,

greg k-h
