Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab0GOCvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:51:43 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40611 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab0GOCvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:51:40 -0400
Subject: Re: [PATCH 01/11] x86: Fix vtime/file timestamp inconsistencies
From: john stultz <johnstul@us.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20100715101317.CB56.A69D9226@jp.fujitsu.com>
References: <20100714113527.EA8A.A69D9226@jp.fujitsu.com>
	 <1279124344.1831.13.camel@work-vm>
	 <20100715101317.CB56.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 14 Jul 2010 19:51:38 -0700
Message-ID: <1279162298.3372.65.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-15 at 10:51 +0900, KOSAKI Motohiro wrote:
> > On Wed, 2010-07-14 at 11:40 +0900, KOSAKI Motohiro wrote:
> > > Hi
> > > 
> > > > Due to vtime calling vgettimeofday(), its possible that an application
> > > > could call  time();create("stuff",O_RDRW);  only to see the file's
> > > > creation timestamp to be before the value returned by time.
> > > 
> > > Just dumb question.
> > > 
> > > Almost application are using gettimeofday() instead time(). It mean
> > > your fix don't solve almost application.
> > 
> > Correct,  filesystem timestamps and gettimeofday can still seem
> > inconsistently ordered. But that is expected.
> > 
> > Because of granularity differences (one interface is only tick
> > resolution, the other is clocksource resolution), we can't interleave
> > the two interfaces (time and gettimeofday, respectively) and expect to
> > get ordered results.
> 
> hmmm...
> Yes, times() vs gettimeofday() mekes no sense. nobody want this. but
> I don't understand why we can ignore gettimeofday() vs file-tiemstamp.

Oh.. and another bit worth mentioning again:
clock_gettime(CLOCK_REALTIME_COARSE, ...) provides tick-granular output
that should be able to be correctly interleaved with filesystem
timestmaps. 

So if there's an application that is using gettimeofday() for logging
and having problems trying to map the log timestmaps with filesystem
timestamps, they can use clock_gettime(CLOCK_REALTIME_COARSE,...) to do
so correctly.

thanks
-john


