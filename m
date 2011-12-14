Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab1LNC4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 21:56:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63111 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab1LNC4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 21:56:47 -0500
X-Authority-Analysis: v=2.0 cv=QrfcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=3I5gx53VNj0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=IC_izjxyg4O3JNxrCjIA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1323831406.23971.14.camel@gandalf.stny.rr.com>
Subject: Re: [RFC][PATCH] writeback: Unduplicate writeback reason
From: Steven Rostedt <rostedt@goodmis.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Curt Wohlgemuth <curtw@google.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 13 Dec 2011 21:56:46 -0500
In-Reply-To: <20111214014903.GA25931@localhost>
References: <20111214003150.GA14520@localhost>
	 <1323825240.23971.11.camel@gandalf.stny.rr.com>
	 <20111214014903.GA25931@localhost>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-14 at 09:49 +0800, Wu Fengguang wrote:
> Hi Steven,
> 
> On Wed, Dec 14, 2011 at 09:14:00AM +0800, Steven Rostedt wrote:
> > Names of the writeback reasons are used in both the main kernel as well
> > as for parsing the tracepoint format file. Instead of duplicating the
> > names in two locations making it likely that they may become out of
> > sync, use some macro magic to make sure all the names stay in sync. Any
> > update only needs to happen in one spot for it to take place in all
> > locations.
>  
> It looks a bit hacky,

One of my professors showed me this trick a long time ago when I was
going for my Masters. It was actually the trick I based the entire
TRACE_EVENT() macro magic on :)

>  but does the nice job of de-duplicating code.
> And it compiles. So I like it and would like to take it with the below
> rename :-)
> 
> > Note, this is an RFC patch, and it probably needs much better comments
> > (well, it currently has no comments), and the C() macro probably should
> > have a different name too.
> 
> C => WB_ENUM_REASONS_ITEM? It may look unpleasantly long, however is
> unique enough to make the many #define/#undef safe. 

Sure. Acked-by: Steven Rostedt <rostedt@goodmis.org>

Note, there's one buggy issue still. That the enums names still trip up
trace-cmd. But that's fine, because I have a plan to fix that too. But
that will be on the ftrace said.

Thanks!

-- Steve


