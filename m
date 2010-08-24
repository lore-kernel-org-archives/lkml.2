Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab0HXQXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 12:23:01 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45996 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab0HXQW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 12:22:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N/ccwRun+dbLegLN8537yTgKBnR2X8sjHkSJlG9VXDgBBcNNerU8AiPYOFM52ZeiHw
         kDRxFYTsee4T4QGRaazc4JD2wHT+L49VVsRlYAvYxLBq3YOMqA7XX6/r785QsODRKL/a
         LipQ7SPivn1+dtn9cNe+lwe5y0QjP9++WvcaE=
Date: Tue, 24 Aug 2010 20:22:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH -v3] perf, x86: try to handle unknown nmis with running
	perfctrs
Message-ID: <20100824162252.GB5723@lenovo>
References: <9g472epksbkxhgmw6a3qh8r5.1282316687153@email.android.com> <20100820152510.GA4167@elte.hu> <20100823085339.GA26713@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100823085339.GA26713@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 10:53:39AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Don Zickus <dzickus@redhat.com> wrote:
> > 
> > > I'll test tip later today to see if I can reproduce it.
> > > 
> > > Cheers,
> > > Don
> > > 
> > > Ingo Molnar <mingo@elte.hu> wrote:
> > > 
> > > >
> > > >it's not working so well, i'm getting:
> > > >
> > > > Uhhuh. NMI received for unknown reason 00 on CPU 9.
> > > > Do you have a strange power saving mode enabled?
> > > > Dazed and confused, but trying to continue
> > > >
> > > >on a nehalem box, after a perf top and perf stat run.
> > 
> > FYI, it does not trigger on an AMD box.
> 
> Ok, to not hold up the perf/urgent flow i zapped these two commits for 
> the time being:
> 
>  4a31beb: perf, x86: Fix handle_irq return values
>  8e3e42b: perf, x86: Try to handle unknown nmis with an enabled PMU
> 
> We can apply them if they take a form that dont introduce a different 
> kind of (and more visible) regression.
> 
> Thanks,
> 
> 	Ingo
> 

Btw, guys, I fail to see how new nmi_watchdog work, we have
default_do_nmi
  if (!(reason & 0xc0)) {
    if (notify_die(DIE_NMI, "nmi", regs, reason, 2, SIGINT) == == NOTIFY_STOP)
      return
    if (nmi_watchdog_tick(regs, reason))
      return

but perf_event_nmi_handler returns NOTIFY_STOP when watchdog is perf event
and nmi_watchdog_tick _never_ called, or (most probably) I miss something?

	-- Cyrill
