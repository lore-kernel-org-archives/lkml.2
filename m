Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab2HPNpP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:45:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab2HPNpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:45:12 -0400
Date: Thu, 16 Aug 2012 15:44:42 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, eranian@google.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 0/6] perf, tool: Allow to use hw events in PMU syntax
Message-ID: <20120816134442.GA10252@krava.brq.redhat.com>
References: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
 <20120808124214.GC959@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120808124214.GC959@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 02:42:14PM +0200, Jiri Olsa wrote:
> On Mon, Jul 09, 2012 at 10:37:44PM +0200, Jiri Olsa wrote:
> > hi,
> > here's the change to make following syntax available:
> >   perf stat -e cpu/event=instructions/u ls
> > 
> > this is identical to:
> >   perf stat -e instructions:u ls
> > 
> > v3 changes:
> >   - patches v2 1,5,6,9 are already in
> >   - patch 1 - sysfs 'events' attribute file names with dashes '-'
> >             - using 'event/umask/inv/cmask' terms assigments instead simple 'config'
> >   - patch 2 - undefined events sysfs attributes filtered out
> > 
> > v2 changes:
> >   - making the hw events translations available under the 'events',
> >     the userspace trnaslation is then done by existing term aliasing
> >     code with some little tweeks ;)
> >   - patches 1-3 are independent fixies
> > 
> > Attached patches:
> >   1/6 perf, x86: Making hardware events translations available in sysfs
> >   2/6 perf, x86: Filter out undefined events from sysfs events attribute
> >   3/6 perf, tool: Fix pmu object alias initialization
> >   4/6 perf, tool: Properly free format data
> >   5/6 perf, tool: Add support to specify hw event as pmu event term
> >   6/6 perf, test: Add automated tests for pmu sysfs translated events
> > 
> > jirka
> > ---
> >  arch/x86/kernel/cpu/perf_event.c    |   98 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tools/perf/util/parse-events-test.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++--
> >  tools/perf/util/parse-events.c      |   13 +++++++++
> >  tools/perf/util/parse-events.h      |    2 ++
> >  tools/perf/util/parse-events.y      |    9 ++++++
> >  tools/perf/util/pmu.c               |   59 ++++++++++++++++++++++++---------------
> >  6 files changed, 232 insertions(+), 24 deletions(-)
> 
> hi,
> any feedback on this?
> you can check rebased version (on Arnaldo's perf/core) here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/linux.git
> perf/sysfs_events1

please use: perf/sysfs_events2

thanks,
jirka
