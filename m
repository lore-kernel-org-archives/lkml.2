Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375Ab0GOEmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 00:42:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42645 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274Ab0GOEmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 00:42:05 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 01/11] x86: Fix vtime/file timestamp inconsistencies
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1279162298.3372.65.camel@localhost>
References: <20100715101317.CB56.A69D9226@jp.fujitsu.com> <1279162298.3372.65.camel@localhost>
Message-Id: <20100715133926.B8EE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Jul 2010 13:41:59 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2010-07-15 at 10:51 +0900, KOSAKI Motohiro wrote:
> > > On Wed, 2010-07-14 at 11:40 +0900, KOSAKI Motohiro wrote:
> > > > Hi
> > > > 
> > > > > Due to vtime calling vgettimeofday(), its possible that an application
> > > > > could call  time();create("stuff",O_RDRW);  only to see the file's
> > > > > creation timestamp to be before the value returned by time.
> > > > 
> > > > Just dumb question.
> > > > 
> > > > Almost application are using gettimeofday() instead time(). It mean
> > > > your fix don't solve almost application.
> > > 
> > > Correct,  filesystem timestamps and gettimeofday can still seem
> > > inconsistently ordered. But that is expected.
> > > 
> > > Because of granularity differences (one interface is only tick
> > > resolution, the other is clocksource resolution), we can't interleave
> > > the two interfaces (time and gettimeofday, respectively) and expect to
> > > get ordered results.
> > 
> > hmmm...
> > Yes, times() vs gettimeofday() mekes no sense. nobody want this. but
> > I don't understand why we can ignore gettimeofday() vs file-tiemstamp.
> 
> Oh.. and another bit worth mentioning again:
> clock_gettime(CLOCK_REALTIME_COARSE, ...) provides tick-granular output
> that should be able to be correctly interleaved with filesystem
> timestmaps. 
> 
> So if there's an application that is using gettimeofday() for logging
> and having problems trying to map the log timestmaps with filesystem
> timestamps, they can use clock_gettime(CLOCK_REALTIME_COARSE,...) to do
> so correctly.

Correct. but I disagree few bit . 1) application naturally assume time don't 
makes interleaving. so almost all applications don't have such care. 2) tick-granular fs
timestamp is only current implementaion. perhaps we will change it later. so, applications
don't want to assume fs timestamp granularity is equal to CLOCK_REALTIME_COARSE. 



