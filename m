Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422904Ab2LGAgr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:36:47 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58648 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422886Ab2LGAgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:36:45 -0500
X-Sasl-enc: CIbydZX1n4v+kHdMC5XJivkkCOJQ/SDiYLstmlWfEKe+ 1354840604
Date: Thu, 6 Dec 2012 16:36:43 -0800
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [v3.0 stable version][PATCH 1/2] ring-buffer: Fix NULL pointer
 if rb_set_head_page() fails
Message-ID: <20121207003643.GA30526@kroah.com>
References: <20121130161238.909829067@goodmis.org>
 <20121130161333.983378567@goodmis.org>
 <1354292203.6276.159.camel@gandalf.local.home>
 <20121206201326.GA10874@kroah.com>
 <1354830115.17101.28.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354830115.17101.28.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2012 at 04:41:55PM -0500, Steven Rostedt wrote:
> On Thu, 2012-12-06 at 12:13 -0800, Greg KH wrote:
> > On Fri, Nov 30, 2012 at 11:16:43AM -0500, Steven Rostedt wrote:
> > > The function rb_set_head_page() searches the list of ring buffer
> > > pages for a the page that has the HEAD page flag set. If it does
> > > not find it, it will do a WARN_ON(), disable the ring buffer and
> > > return NULL, as this should never happen.
> > > 
> > > But if this bug happens to happen, not all callers of this function
> > > can handle a NULL pointer being returned from it. That needs to be
> > > fixed.
> > > 
> > > Cc: stable@vger.kernel.org # 3.0+
> > > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > > ---
> > >  kernel/trace/ring_buffer.c |    9 +++++++--
> > >  1 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > I don't understand why you sent these to stable@ right now, I don't see
> > them in Linus's tree, so why are they needed here?
> 
> Answer below.
> 
> > 
> > Care to resend them when they hit Linus's tree?
> 
> I'll try to remember, but I will most likely forget :-)
> 
> I wrote the patches for each stable version while they were still fresh
> in my mind. I posted them so they would be there when they get into
> mainline and be easier to port for stable. By the time they are in
> mainline, they will be completely out of my mind :-)

Ok, if they are that important, consider them forgotten from my mind as
well :)

greg k-h
