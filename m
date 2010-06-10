Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab0FJQQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:16:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:59967 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab0FJQQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:16:36 -0400
Subject: Re: [PATCH 1/5] perf: Provide a proper stop action for software
 events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@google.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20100610161234.GA5255@nowhere>
References: <1276141760-11590-1-git-send-regression-fweisbec@gmail.com>
	 <1276141760-11590-2-git-send-regression-fweisbec@gmail.com>
	 <1276166813.2077.96.camel@twins> <1276168242.2077.134.camel@twins>
	 <20100610161234.GA5255@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 10 Jun 2010 18:16:16 +0200
Message-ID: <1276186576.2077.554.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 18:12 +0200, Frederic Weisbecker wrote:
> On Thu, Jun 10, 2010 at 01:10:42PM +0200, Peter Zijlstra wrote:
> > On Thu, 2010-06-10 at 12:46 +0200, Peter Zijlstra wrote:
> > > 
> > > Something like the below would work, the only 'problem' is that it grows
> > > hw_perf_event.
> > 
> > If we do the whole PAUSEd thing right, we'd not need this I think.
> 
> 
> It's not needed, and moreover software_pmu:stop/start() can be the same
> than software:pmu:disable/enable() without the need to add another check
> in the fast path.
> 
> But we need perf_event_stop/start() to work on software events. And in fact
> now that we use the hlist_del_init, it's safe, but a bit wasteful in
> the period reset path. That's another problem that is not critical, but
> if you want to solve this by ripping the differences between software and
> hardware (which I agree with), we need a ->reset_period callback.
> 
Why? ->start() should reprogram the hardware, so a
->stop()/poke-at-state/->start() cycle is much more flexible.
