Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2DZK0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 06:26:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab2DZK0q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 06:26:46 -0400
Date: Thu, 26 Apr 2012 12:10:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, eranian@google.com,
        robert.richter@amd.com
Subject: Re: [PATCHv2 0/6] perf, tool: event parsing enhancements/fixes
Message-ID: <20120426101030.GA1659@m.brq.redhat.com>
References: <1335371102-11358-1-git-send-email-jolsa@redhat.com>
 <87liljf2gi.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87liljf2gi.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 03:10:21PM +0900, Namhyung Kim wrote:
> Hi,
> 
> On Wed, 25 Apr 2012 18:24:56 +0200, Jiri Olsa wrote:
> > Hi,
> > adding some enhancements/fixies for perf event parsing.
> >
> > v2 changes:
> >    - rebased to current tip tree
> >    - 2/6 - ommitting pmu tests in case there's no pmu sysfs record
> 
> Nice! It bothered me somewhat so I was thinking about fixing it.
> I guess we have a same problem on x86 rdpmc test too?

right.. I haven't seen that code, so not sure how hard the fix would be

jirka

> 
> Thanks,
> Namhyung
> 
> 
> >    - 6/6 - default the pmu event name to raw 0x<perf_event_attr::config>
> >
> > Attached patches:
> >   1/6 perf, tool: Split term type into value type and term type
> >   2/6 perf, tool: Move parse event automated tests to separated object
> >   3/6 perf, tool: Add support for displaying event parser debug info
> >   4/6 perf, tool: Use allocated list for each parsed event
> >   5/6 perf, tool: Separate 'mem:' event scanner bits
> >   6/6 perf, tool: Add hardcoded name term for pmu events
> >
> > thanks,
> > jirka
> > ---
> >  tools/perf/Makefile                 |   13 +-
> >  tools/perf/builtin-test.c           |  552 +------------------------------
> >  tools/perf/util/parse-events-test.c |  625 +++++++++++++++++++++++++++++++++++
> >  tools/perf/util/parse-events.c      |  114 +++++--
> >  tools/perf/util/parse-events.h      |   42 ++-
> >  tools/perf/util/parse-events.l      |   26 ++-
> >  tools/perf/util/parse-events.y      |   93 ++++--
> >  tools/perf/util/pmu.c               |   74 +++--
> >  8 files changed, 883 insertions(+), 656 deletions(-)
