Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab2LFVmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 16:42:00 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2827 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965247Ab2LFVl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 16:41:57 -0500
X-Authority-Analysis: v=2.0 cv=f9bK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Tlwa9QaMYFAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=gHdz8N29LIkA:10 a=VwQbUJbxAAAA:8 a=A1MkK4SXD2WQ7tJ_US8A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1354830115.17101.28.camel@gandalf.local.home>
Subject: Re: [v3.0 stable version][PATCH 1/2] ring-buffer: Fix NULL pointer
 if rb_set_head_page() fails
From: Steven Rostedt <rostedt@goodmis.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 06 Dec 2012 16:41:55 -0500
In-Reply-To: <20121206201326.GA10874@kroah.com>
References: <20121130161238.909829067@goodmis.org>
	 <20121130161333.983378567@goodmis.org>
	 <1354292203.6276.159.camel@gandalf.local.home>
	 <20121206201326.GA10874@kroah.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-06 at 12:13 -0800, Greg KH wrote:
> On Fri, Nov 30, 2012 at 11:16:43AM -0500, Steven Rostedt wrote:
> > The function rb_set_head_page() searches the list of ring buffer
> > pages for a the page that has the HEAD page flag set. If it does
> > not find it, it will do a WARN_ON(), disable the ring buffer and
> > return NULL, as this should never happen.
> > 
> > But if this bug happens to happen, not all callers of this function
> > can handle a NULL pointer being returned from it. That needs to be
> > fixed.
> > 
> > Cc: stable@vger.kernel.org # 3.0+
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/trace/ring_buffer.c |    9 +++++++--
> >  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> I don't understand why you sent these to stable@ right now, I don't see
> them in Linus's tree, so why are they needed here?

Answer below.

> 
> Care to resend them when they hit Linus's tree?

I'll try to remember, but I will most likely forget :-)

I wrote the patches for each stable version while they were still fresh
in my mind. I posted them so they would be there when they get into
mainline and be easier to port for stable. By the time they are in
mainline, they will be completely out of my mind :-)

Also, it seems that Ingo has been so busy with NUMA, that my patches
have been forgotten about. I may have to push to Linus directly :-/

-- Steve


