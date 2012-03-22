Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964987Ab2CVMlY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 08:41:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757831Ab2CVMlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 08:41:21 -0400
Date: Thu, 22 Mar 2012 09:40:49 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
Message-ID: <20120322124049.GE21163@infradead.org>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
 <1332269081.18960.444.camel@twins>
 <20120321104214.GB1632@m.brq.redhat.com>
 <20120321151119.GC21163@infradead.org>
 <20120321222724.GA1835@m.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120321222724.GA1835@m.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Mar 21, 2012 at 11:27:24PM +0100, Jiri Olsa escreveu:
> On Wed, Mar 21, 2012 at 12:11:19PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Mar 21, 2012 at 11:42:14AM +0100, Jiri Olsa escreveu:
> > > On Tue, Mar 20, 2012 at 07:44:41PM +0100, Peter Zijlstra wrote:
> > > > If so, we need some option like:
> > > > 
> > > >   perf record -e "{cpu-clock,cache-misses,cache-references}:1"
> > > > 
> > > > to mean, only sample on cpu-clock but use PERF_SAMPLE_READ and
> > > > PERF_FORMAT_GROUP to read all siblings on every cpu-clock sample.
> > > > 
> > > > Now the disadvantage is that {} needs quotes on bash, the advantage is
> > > > that its completely natural on how to construct groups, without weird
> > > > --group/--group parsed. Also it provides a place for group modifiers.
> > > 
> > > how about '=group' keyword followed by ':' modifier
> > >   perf record -e "cpu-clock,cache-misses,cache-references=group:1"
> > > 
> > > or '=$groupname' and use the group name in output like
> > >   perf stat -e "task-clock,context-switches=krava:1" ls
> > > 
> > >      Performance counter stats for 'ls':
> > > 
> > >           1.003695 task-clock/krava          #    0.083 CPUs utilized          
> > >                  0 context-switches/krava    #    0.000 K/sec                  
> > > 
> > 
> > Humm, interesting, perhaps putting the group name before the =event_list
> > will be more intuitive?
> > 
> > I.e.:
> > 
> >   perf stat -e "krava=task-clock,context-switches:1" ls
> 
> yep, I put it at the end because of the ':' modifier stuff.
> We have it for each event, and it'd be in conflict having
> it at the end..
> 
> maybe we could put it like:
>    perf stat -e "krava:1=task-clock,context-switches" ls
> 
> or put some other separator instead of ':' ... but ':' is the best ;)

That thought crossed my mind as well, indeed it seems more intuitive:
everything before the '=' defines the group wide attributes (name,
modifiers, whatevever else we need later) after it, the evlist, where
each evsel can have its own attributes.

- Arnaldo
