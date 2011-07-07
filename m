Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab1GGOXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:23:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34984 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1GGOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:23:46 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=MR-b7LisxJQA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=VwQbUJbxAAAA:8 a=Mb2r8BVGg9d1b0zkf84A:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/2] [GIT PULL][v3.0] tracing: Add refcount for system
 filter and enable
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110707141525.GA19193@elte.hu>
References: <20110706211931.764277374@goodmis.org>
	 <20110707141525.GA19193@elte.hu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 07 Jul 2011 10:23:28 -0400
Message-ID: <1310048608.26417.204.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 16:15 +0200, Ingo Molnar wrote:
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > Ingo,
> > 
> > Please pull the latest tip/perf/urgent tree, which can be found at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > tip/perf/urgent
> > 
> > Head SHA1: 57f124ca21d216fca3ba3995235c15855f9b9980
> > 
> > 
> > Steven Rostedt (2):
> >       tracing: Add ref_count to event systems for freeing
> >       tracing: Have enable system events use the subsystem_open routine
> > 
> > ----
> >  kernel/trace/trace.h               |    1 +
> >  kernel/trace/trace_events.c        |  113 ++++++++++++++++++++++++++++++------
> >  kernel/trace/trace_events_filter.c |    6 ++
> >  3 files changed, 102 insertions(+), 18 deletions(-)
> 
> Hm, i'm wondering, when was this bug introduced?
> 

It was introduced a while ago, I believe by this commit:

commit dc82ec98a4727fd51b77e92d05fe7d2db3dcc11c
Date:   Thu Jul 9 16:22:22 2009 +0800
tracing/filter: Remove empty subsystem and its directory


-- Steve


