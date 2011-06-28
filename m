Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab1F1P5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:57:53 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:41188 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758383Ab1F1P4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:56:20 -0400
Date: Tue, 28 Jun 2011 19:56:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
Message-ID: <20110628155615.GI1159@sun>
References: <20110623124918.GC13050@sun>
 <20110627190358.GQ3765@redhat.com>
 <20110627193201.GB1159@sun>
 <CABPqkBTE_6ma70ZQbbz1NnznCGB7YO74kmL+=fP66qFVvVFLBw@mail.gmail.com>
 <20110628152827.GE1159@sun>
 <CABPqkBQSWFa0eSTdx+DeOERaT2wA+2tYbUPereztL7FznF4j7g@mail.gmail.com>
 <20110628154044.GF1159@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110628154044.GF1159@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 07:40:44PM +0400, Cyrill Gorcunov wrote:
> On Tue, Jun 28, 2011 at 05:32:27PM +0200, Stephane Eranian wrote:
> > On Tue, Jun 28, 2011 at 5:28 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > > On Tue, Jun 28, 2011 at 05:24:36PM +0200, Stephane Eranian wrote:
> > > ...
> > >> >
> > >> > Yeah, not the _best_ place. Not sure too where to put it, patches are welcome ;)
> > >> >
> > >> No matter what, this file has to remain in a file that's common to all arch.
> > >
> > > well, hard to say, Stephane, nmi-watchdog is x86 specific as far as I know.
> > >
> > Sorry I was talking about the weak function() not the file.
> > 
> 
> Yes, I get it ;) I mean that this __weak function is always called from x86 site
> and outside of CONFIG_HARDLOCKUP_DETECTOR doesn't make much sense that is why I
> placed it there in first place. Though it look somehow... maybe "strange"
> I would say, that's why I agreed with Don it's not the best place.
> 
> 	Cyrill

As Don just pointed me (it's a shame that I forget about sparc since I remember
someone, maybe even Don,  was already pointing me that nmi-watchdog
is NOT x86 only thing! :) So yes Stephane, you're of course right, this weak
definition better to live in common place. I think if decide to change its
place -- better in a separate patch.

	Cyrill
