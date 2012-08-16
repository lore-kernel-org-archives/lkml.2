Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343Ab2HPUzt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 16:55:49 -0400
Received: from mail.x86-64.org ([217.9.48.20]:53189 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab2HPUzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 16:55:47 -0400
Date: Thu, 16 Aug 2012 22:55:39 +0200
From: Borislav Petkov <bp@amd64.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [RFC PATCH -v2 0/4] Persistent events
Message-ID: <20120816205539.GA16308@aftab.osrc.amd.com>
References: <1345139123-15212-1-git-send-email-bp@amd64.org>
 <20120816141253.0142ddd0@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816141253.0142ddd0@lwn.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jon,

On Thu, Aug 16, 2012 at 02:12:53PM -0600, Jonathan Corbet wrote:
> On Thu, 16 Aug 2012 19:45:19 +0200
> Borislav Petkov <bp@amd64.org> wrote:
> 
> > off and on I get some free time to work on that, here's the latest
> > incarnation. It contains review feedback from the earlier round.
> 
> Can I add one small request for the next round?  I've looked through the
> patches and the code a bit, and I still have absolutely no clue of what a
> "persistent event" is or why I might want one.  Now, admittedly, I'm
> slower than most, but it still might not hurt to add some overall
> description of what this is for...?

yeah, maybe the naming is not the most fitting one but here's the basic
idea:

Normally, you enable perf events for a duration of time where you trace
your workload and then you disable them. In contrast, persistent events
are perf events which you enable at system boot and they remain enabled
- thus persistent - during the whole system lifetime.

The machinery logs all events and carries them out to userspace. Much
like the blackbox of a plane which records system events during the
whole flight.

And the usecase here is that we want the machine check code to log
machine checks during the whole system lifetime using the perf/trace
events infrastructure. And this happens regardless of whether there's a
userspace consumer of the logged data. Normally, we'll have one though
:).

MCA and the trace_mce_record() tracepoint is thus is the first user of
the persistent events but there might be others.

Please follow this thread:
http://marc.info/?l=linux-kernel&m=133234057614885 for some more
thoughts on the idea.

Of course, this whole thing is basically a rough draft and we're still
hammering out the details as we go.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
