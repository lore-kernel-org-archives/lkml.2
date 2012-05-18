Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966412Ab2ERMzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 08:55:24 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:39484 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab2ERMzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 08:55:23 -0400
Date: Fri, 18 May 2012 14:55:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
Message-ID: <20120518125505.GK20215@aftab.osrc.amd.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
 <1332340496-21658-2-git-send-email-bp@amd64.org>
 <1337336040.573.12.camel@twins>
 <20120518110357.GH20215@aftab.osrc.amd.com>
 <1337340263.573.31.camel@twins>
 <20120518115957.GB19785@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518115957.GB19785@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 01:59:57PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, 2012-05-18 at 13:03 +0200, Borislav Petkov wrote:
> > > >  - you allow an arbitrary place in debugfs; this might make finding
> > > > them 'interesting'. Should we put them all in the same place?
> > > 
> > > My take on this is that we want to be able to make the same events we
> > > have now, persistent. Basically not trace for the duration of a child
> > > process but in a process-agnostic way, system-wide.
> > 
> > This would argue against per-task persistent events.. 
> 
> Yeah, 'persistency' is something that's per CPU at minimum.

Yeah, forget the per-task thing - that's me not understanding the code
fully. They need to be per CPU and "taskless."

> > Note the plural there, it might be very desirable to allow 
> > multiple events into a single persistent buffer.
> 
> very, very, very much so. One (per CPU) buffer, with many events 
> multiplexed into it.

Which begs the other question: mce could use buffers which are RO - at
least, I don't see a usecase where we want to delete entries from them -
but other persistent events users might want to delete those events to
free up the buffers.

It is an interesting question how we handle that RO/RW thing? Maybe per
event and do something of a kernel-side filtering which Peter didn't
like in Robert's IBS stuff.

Hmmm...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
