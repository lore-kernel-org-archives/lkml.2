Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1I1OSE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:18:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45663 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab1I1OSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:18:02 -0400
Date: Wed, 28 Sep 2011 16:17:57 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, eric.dumazet@gmail.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, nhorman@tuxdriver.com
Subject: Re: [PATCHv2 1/2] perf tools: Collect tracing event data files
 directly
Message-ID: <20110928141754.GT18553@somewhere>
References: <20110925133406.GB2702@jolsa.brq.redhat.com>
 <1317028312-5156-1-git-send-email-jolsa@redhat.com>
 <1317028312-5156-2-git-send-email-jolsa@redhat.com>
 <1317044192.26514.1.camel@gandalf.stny.rr.com>
 <20110926145606.GA8886@jolsa.brq.redhat.com>
 <20110928135525.GS18553@somewhere>
 <1317218589.4588.4.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317218589.4588.4.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:03:08AM -0400, Steven Rostedt wrote:
> On Wed, 2011-09-28 at 15:55 +0200, Frederic Weisbecker wrote:
> > On Mon, Sep 26, 2011 at 04:56:06PM +0200, Jiri Olsa wrote:
> > > On Mon, Sep 26, 2011 at 09:36:31AM -0400, Steven Rostedt wrote:
> > > > On Mon, 2011-09-26 at 11:11 +0200, Jiri Olsa wrote:
> > > > > Changing the way the event files are searched by quering specified
> > > > > event files directly, instead of walking the events directory.
> > > > > 
> > > > > Hopefully this way is more straightforward and faster.
> > > > 
> > > > Have you looked at my code I posted earlier that uses the libparsevents?
> > > > 
> > > > It uses globs such that you could do -e sched:sched* and it will enable
> > > > all sched events.
> > > 
> > > ops, haven't seen those changes yet..
> > > I think I can go only with 2/2 patch, if the 1/2 collides with your changes
> > 
> > But it seems Steve's patches are not completely uncontroversial because
> > of some crazy disagreements on where the libparsevent.so should lay (tools generic
> > or tied to perf).
> 
> Which to me seems to be a silly road block, in which I never got a clear
> answer for.

Yeah we need to sort that out with Ingo.

> 
> > 
> > So until we get that situation solved, we should continue to move forward.
> 
> Sure, but it just forks the code even more, and it's almost to the point
> where maintaining a fork will just be easier, not to mention quicker to
> get out to the distros.

Right. May be Jiri can have a look at what trace-cmd does there.
