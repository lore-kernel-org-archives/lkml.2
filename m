Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396Ab2EINWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:22:52 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49916 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab2EINWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:22:50 -0400
Date: Wed, 9 May 2012 15:22:37 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [EDAC ABI v13 04/25] events/hw_event: Create a Hardware Events
 Report Mecanism (HERM)
Message-ID: <20120509132237.GD22737@aftab.osrc.amd.com>
References: <1334608729-30803-1-git-send-email-mchehab@redhat.com>
 <1334608729-30803-5-git-send-email-mchehab@redhat.com>
 <20120509121326.GA22737@aftab.osrc.amd.com>
 <4FAA6802.9070506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FAA6802.9070506@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Tony.

On Wed, May 09, 2012 at 09:50:10AM -0300, Mauro Carvalho Chehab wrote:
> Em 09-05-2012 09:13, Borislav Petkov escreveu:
> > Inserting the latest version:
> > 
> >> From 4afb0250415e87b983f5937d456c83407fe96264 Mon Sep 17 00:00:00 2001
> >> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> >> Date: Thu, 23 Feb 2012 08:10:34 -0300
> >> Subject: [PATCH] events/hw_event: Create a Hardware Events Report Mecanism
> >>  (HERM)
> > 
> > Ok, let's face it: this is just a single trace_mc_error tracepoint,
> > nothing else. Let's drop the HERM bullshit bingo and call the thing by
> > it's name: "Add yet another tracepoint to report DRAM ECC errors".
> 
> This name is nice and helps to distinguish this mechanism among others,
> and will help to distinguish between HARM-aware userspace tools from the
> existing ones.

This may be so but it is not a mechanism - it is simply using a kernel
facility - a tracepoint - and that's it.

Now, if you really want to have a generic mechanism for RAS, used
by all the kernel, then I don't have a problem with you adding it
to include/ras/hw_event.h or somewhere in that vicinity along with
making it generic enough for other users and then taking care of it and
developing it to address users' needs.

But simply growing stuff here and there for a specific use case is not
the way to go.

[ … ]

> >> diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
> >> new file mode 100644
> >> index 000000000000..1fabfe21e29a
> >> --- /dev/null
> >> +++ b/include/trace/events/hw_event.h
> >> @@ -0,0 +1,107 @@
> >> +#undef TRACE_SYSTEM
> >> +#define TRACE_SYSTEM hw_event
> >> +
> >> +#if !defined(_TRACE_HW_EVENT_MC_H) || defined(TRACE_HEADER_MULTI_READ)
> >> +#define _TRACE_HW_EVENT_MC_H
> >> +
> >> +#include <linux/tracepoint.h>
> >> +#include <linux/edac.h>
> >> +#include <linux/ktime.h>
> >> +
> >> +/*
> >> + * Hardware Anomaly Report Mecanism (HARM) events
> >> + *
> >> + * Those events are generated when hardware detected a corrected or
> >> + * uncorrected event, and are meant to replace the current API to report
> >> + * errors defined on both EDAC and MCE subsystems.
> >> + *
> >> + * FIXME: Add events for handling memory errors originated from the
> >> + *        MCE subsystem.
> >> + */
> >> +
> >> +DECLARE_EVENT_CLASS(hw_event_class,
> > 
> > Ok, event classes are for sharing tracepoints which have the same
> > TP_PROTO, TP_ARGS.. etc arguments as Steven's (CCed) article on lwn
> > points out.
> 
> Other trace mechanisms will be added. One of them is the MCA-based tracepoint,
> that got removed while no consensus is reached on that.

You're missing the point: are the other tracepoints using "const char
*type" and "unsigned int instance" as arguments? No.

IOW, go look at http://lwn.net/Articles/381064/ for an example what the
trace event class is. Hint: sched_wakeup and sched_wakeup_new.

> > I don't see this here and besides, why in the hell would you need a
> > trace event which only announces that the mechanism starts?? A common,
> > run-of-the-mill printk is more than enough here.
> 
> A daemon monitoring this trace may need to know when the trace mechanism
> started, in order to what might be lost before the event init.

Yes, the trace has started when the daemon reads the first sample from the
buffer, no need for explicitly letting us know it has.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
