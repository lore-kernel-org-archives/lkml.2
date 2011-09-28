Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1I1Nzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:55:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33758 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417Ab1I1Nzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:55:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Wed, 28 Sep 2011 15:58:05 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110928145144.3d074db9aa9b6f858e0dc4fb@canb.auug.org.au> <CACVXFVMrPNZupCQnBMBXsSA1OH=15m9QBKhXT1Of+LghZbKn0Q@mail.gmail.com>
In-Reply-To: <CACVXFVMrPNZupCQnBMBXsSA1OH=15m9QBKhXT1Of+LghZbKn0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281558.05289.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 28, 2011, Ming Lei wrote:
> Hi Stephen and Rafael,
> 
> Sorry, the attachment patch can fix the build failure, which is
> caused by unset CONFIG_RUNTIME_PM.

First off, that's CONFIG_PM_RUNTIME.  Second, why do you want to build
rpm-traces.c at all if CONFIG_PM_RUNTIME is unset?

Rafael


> On Wed, Sep 28, 2011 at 12:51 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Hi Rafael,
> >
> > After merging the pm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >
> > In file included from include/trace/ftrace.h:567:0,
> >                 from include/trace/define_trace.h:96,
> >                 from include/trace/events/rpm.h:99,
> >                 from kernel/trace/rpm-traces.c:15:
> > include/trace/events/rpm.h: In function 'ftrace_raw_event_rpm_internal':
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'usage_count'
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'disable_depth'
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'runtime_auto'
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'request_pending'
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'irq_safe'
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'child_count'
> > In file included from include/trace/ftrace.h:771:0,
> >                 from include/trace/define_trace.h:96,
> >                 from include/trace/events/rpm.h:99,
> >                 from kernel/trace/rpm-traces.c:15:
> > include/trace/events/rpm.h: In function 'perf_trace_rpm_internal':
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'usage_count'
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'disable_depth'
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'runtime_auto'
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'request_pending'
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'irq_safe'
> > include/trace/events/rpm.h:16:1: error: 'struct dev_pm_info' has no member named 'child_count'
> >
> > Presumably caused by commit 53b615ccca56 ("PM / Runtime: Introduce trace
> > points for tracing rpm_* functions").
> >
> > I have used the pm tree from next-20110927 for today.
> > --
> > Cheers,
> > Stephen Rothwell                    sfr@canb.auug.org.au
> > http://www.canb.auug.org.au/~sfr/
> >
> 

