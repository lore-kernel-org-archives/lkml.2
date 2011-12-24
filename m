Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1LXCff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 21:35:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:48072 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1LXCfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 21:35:33 -0500
Date: Sat, 24 Dec 2011 03:35:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCHvFIXED 7/7] ftrace, perf: Add filter support for function
 trace event
Message-ID: <20111224023527.GE28309@somewhere.redhat.com>
References: <1324468136-3997-1-git-send-email-jolsa@redhat.com>
 <1324493791-5688-1-git-send-email-jolsa@redhat.com>
 <1324493791-5688-8-git-send-email-jolsa@redhat.com>
 <20111221220756.GL17668@somewhere>
 <20111222125558.GB1646@m.brq.redhat.com>
 <20111222152609.GC1646@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222152609.GC1646@m.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 04:26:09PM +0100, Jiri Olsa wrote:
> On Thu, Dec 22, 2011 at 01:55:58PM +0100, Jiri Olsa wrote:
> > On Wed, Dec 21, 2011 at 11:07:58PM +0100, Frederic Weisbecker wrote:
> > > On Wed, Dec 21, 2011 at 07:56:31PM +0100, Jiri Olsa wrote:
> > > > Adding support to filter function trace event via perf
> > > > interface. It is now possible to use filter interface
> > > > in the perf tool like:
> > > > 
> > > >   perf record -e ftrace:function --filter="(ip == mm_*)" ls
> > > > 
> > > > The filter syntax is restricted to the the 'ip' field only,
> > > > and following operators are accepted '==' '!=' '||', ending
> > > > up with the filter strings like:
> > > > 
> > > >   "ip == f1 f2 ..." || "ip != f3 f4 ..." ...
> > > 
> > > Having the functions seperated like this sort of violates the
> > > grammar of the filtering interface.
> > > 
> > > The typical way to do this would have been to stringify the
> > > functions: ip == "f1 f2"
> > > 
> > > I feel a bit uncomfortable with "ip == f1 f2" scheme but perhaps
> > > we can live with that. Especially as otherwise that would
> > > require us to type "ip == \"f1 f2\"" for the whole filtering expression.
> > 
> > ugh, just realized there's a problem with this in the patch actually,
> > and it's not working as expected. I'll send out new version soon.. 
> > 
> > thanks,
> > jirka
> > 
> > > 
> > > Thoughts?
> 
> how about this one.. ;)
> 
> for some reason I presumed ftrace_set_filter would deal with ' '
> as a filter separator.. but it needs to be done before we use
> this function... (ftrace_set_notrace respectively)
> 
> so now you could use one of following:
> 
> perf record -e ftrace:function --filter '(ip == do_execve,sys_*,ext*)' ls
> perf record -e ftrace:function --filter '(ip == "do_execve,sys_*,ext*")' ls
> perf record -e ftrace:function --filter '(ip == "do_execve sys_* ext*")' ls

Nice! ;)

Thanks!
