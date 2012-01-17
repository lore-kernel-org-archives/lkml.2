Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253Ab2AQC3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 21:29:15 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52444 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2AQC3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 21:29:14 -0500
Date: Tue, 17 Jan 2012 03:29:09 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCH 2/7] ftrace: Add enable/disable ftrace_ops control
 interface
Message-ID: <20120117022905.GE24200@somewhere.redhat.com>
References: <1324493791-5688-1-git-send-email-jolsa@redhat.com>
 <1325495060-6402-1-git-send-email-jolsa@redhat.com>
 <1325495060-6402-3-git-send-email-jolsa@redhat.com>
 <20120117014209.GB24200@somewhere.redhat.com>
 <1326766055.7642.181.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326766055.7642.181.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 09:07:35PM -0500, Steven Rostedt wrote:
> On Tue, 2012-01-17 at 02:42 +0100, Frederic Weisbecker wrote:
> >  
> > > diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> > > index 523640f..0d43a2b 100644
> > > --- a/include/linux/ftrace.h
> > > +++ b/include/linux/ftrace.h
> > > @@ -35,12 +35,14 @@ enum {
> > >  	FTRACE_OPS_FL_ENABLED		= 1 << 0,
> > >  	FTRACE_OPS_FL_GLOBAL		= 1 << 1,
> > >  	FTRACE_OPS_FL_DYNAMIC		= 1 << 2,
> > > +	FTRACE_OPS_FL_CONTROL		= 1 << 3,
> > 
> > Please comment the role of this flag. In fact it would be nice to have
> > a comment that explains all these. GLOBAL and DYNAMIC don't actually give
> > much clues alone.
> 
> Someone else asked about commenting these (was it you?).

Probably, as I asked you the meaning of that GLOBAL on irc :)

> I probably should, as it is confusing to what they are used for.

Yeah that would be nice.

> I just figured every just figures it out by looking at the code ;-)

That's often what happens when the reader of the code is also the writer :)
Also, there is no user that doesn't have FTRACE_OPS_FL_GLOBAL yet, so
it's hard to find a counter example.
