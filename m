Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab1F1P1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 11:27:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758696Ab1F1PYk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 11:24:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=A0umyqn2a68rngQOFaIlQWdqOCoDhhQmynh78WCICi2x7vKpgXk1O4eQZp3Edkvt9
	toEOEadhS1hU2Li+szseg==
MIME-Version: 1.0
In-Reply-To: <20110627193201.GB1159@sun>
References: <20110623124918.GC13050@sun>
	<20110627190358.GQ3765@redhat.com>
	<20110627193201.GB1159@sun>
Date: Tue, 28 Jun 2011 17:24:36 +0200
Message-ID: <CABPqkBTE_6ma70ZQbbz1NnznCGB7YO74kmL+=fP66qFVvVFLBw@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Add hw_watchdog_set_attr() in a sake of
 nmi-watchdog on P4
From: Stephane Eranian <eranian@google.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 9:32 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
> On Mon, Jun 27, 2011 at 03:03:58PM -0400, Don Zickus wrote:
> ...
> >
> > > Index: linux-2.6.git/kernel/watchdog.c
> > > ===================================================================
> > > --- linux-2.6.git.orig/kernel/watchdog.c
> > > +++ linux-2.6.git/kernel/watchdog.c
> > > @@ -200,6 +200,8 @@ static int is_softlockup(unsigned long t
> > >  }
> > >
> > >  #ifdef CONFIG_HARDLOCKUP_DETECTOR
> > > +void __weak hw_nmi_watchdog_set_attr(struct perf_event_attr *wd_attr) { }
> > > +
> >
> > Though I do wonder about this call in the watchdog.  I thought it might be
> > better elsewhere but not sure where.
>
> Yeah, not the _best_ place. Not sure too where to put it, patches are welcome ;)
>
No matter what, this file has to remain in a file that's common to all arch.

> >
> > Cheers,
> > Don
>
>        Cyrill
