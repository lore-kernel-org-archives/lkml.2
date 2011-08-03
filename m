Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1HCMLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 08:11:33 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42881 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1HCML0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 08:11:26 -0400
Date: Wed, 3 Aug 2011 14:11:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, robert.richter@amd.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf sched: Fix list of events, dropping
 unsupported ':r' modifier
Message-ID: <20110803121119.GC5768@somewhere.redhat.com>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
 <tip-9710118bd4e7f3406865171cb9b9c94547c1c2f9@git.kernel.org>
 <1312369161.1147.292.camel@twins>
 <20110803113706.GA5768@somewhere.redhat.com>
 <1312371741.1147.301.camel@twins>
 <20110803115703.GB5768@somewhere.redhat.com>
 <1312373135.1147.308.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312373135.1147.308.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 02:05:35PM +0200, Peter Zijlstra wrote:
> On Wed, 2011-08-03 at 13:57 +0200, Frederic Weisbecker wrote:
> > On Wed, Aug 03, 2011 at 01:42:21PM +0200, Peter Zijlstra wrote:
> > > On Wed, 2011-08-03 at 13:37 +0200, Frederic Weisbecker wrote:
> > > > On Wed, Aug 03, 2011 at 12:59:21PM +0200, Peter Zijlstra wrote:
> > > > > On Fri, 2011-01-14 at 07:25 +0000, tip-bot for Stephane Eranian wrote:
> > > > > > Looks to me like the :r modifier is not supported anymore, so remove it from
> > > > > > the list of events. 
> > > > > 
> > > > > acme, why is that anyway? -R is a fun way to save some typing, but not
> > > > > supporting :r anymore takes away the option of not getting
> > > > > PERF_SAMPLE_RAW output for every event.
> > > > 
> > > > Because it was very non obvious for people to select this -R or :r
> > > > every time they wanted to use trace events for tracing. I think
> > > > there was complaints about that. Moreover nobody seemed to use
> > > > trace events for non-tracing (perf report, top, annotate, ...)
> > > > so we decided to always have RAW records so that it works for
> > > > every cases...unless we lose events because of that.
> > > > 
> > > > We can still bring an option to force disabling of raw records.
> > > 
> > > That just doesn't compute, they still have to use -R, so what's the harm
> > > in also having :r?
> > 
> > Nope -R is the default/forced behaviour already.
> > But even if it wasn't I don't see much the point of ":r". Who wants
> > to run two trace events and only record the traces of one?
> 
> [root@westmere linux-2.6]# grep raw_samples tools/perf/builtin-record.c | head -1
> static bool                     raw_samples                     =  false;
> 
> is what tip/master is showing me..

Look at tools/perf/util/parse-events.c:parse_single_tracepoint_event()

> 
> > > Also taking away options just because it confuses people sounds like
> > > gnome, lets just not go there.
> > 
> > You're right but options should be there only to be able to override
> > sane default common uses. And not the opposite. And the common use
> > of trace events is for tracing.
> > 
> > We should rather enable tracing by default and disable it through
> > an option. Like --no-trace or so.
> 
> you smoking some expensive stuff, right?
