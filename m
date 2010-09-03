Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab0ICUKO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 16:10:14 -0400
Received: from cantor.suse.de ([195.135.220.2]:45184 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab0ICUKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 16:10:13 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Fri, 3 Sep 2010 22:10:08 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: Jean Pihet <jean.pihet@newoldbits.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        Arjan Van De Ven <arjan@linux.intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org
References: <AANLkTikvbn3+JPc7pnGZk-H4B71MHTu+-vjuzfJw_7PC@mail.gmail.com> <201009032005.08268.trenn@suse.de> <20100903195555.GA1663@elte.hu>
In-Reply-To: <20100903195555.GA1663@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009032210.08524.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 September 2010 21:55:55 Ingo Molnar wrote:
> 
> * Thomas Renninger <trenn@suse.de> wrote:
> 
> > Hi Jean,
> > 
> > Summary at the beginning if people stop reading on the details
> > below...:
> > Nice work!
> > You have my vote to get this merged.
> > I think it's up to Ingo to push it.
> 
> Well, the patch that got posted:
> 
>   [PATCH] tracing, perf: add more power related events
> 
> Only adds tracepoints to power.h, but doesnt actually use them anywhere 
> ...
> 
> Is there a companion patch i missed?
Yep.
Jean has nicely made up a tiny website he refered to in his mail:
http://www.omappedia.com/wiki/Power_Management_Debug_and_Profiling
There he shows the whole big patch and states:
Since the patch touches generic files (in include/trace/events/power.h), it is split in parts:
    * generic code: submitted to the LKML, cf. http://marc.info/?l=linux-kernel&m=128195697205096&w=4 ,
    * ARM/OMAP specific code for the already existing events: to be submitted to l-o, cf. http://www.spinics.net/lists/linux-omap/msg35357.html,
    * ARM/OMAP specific code for the new events, to be submitted once the generic code is accepted. 

> Also, it would be nice to add it to x86 and to OMAP at once, and 
> synchronize up all the power events
I can add sleep state events to x86 acpi parts, but even these are, as said, not
that interesting as they might be on ARM ultra mobile use cases.

> - and check how existing tools like 
> powertop make use of such events - and sync it all up.
Does powertop use these events?

> We dont want to 
> have inconsistent, architecture-dependent events in the end, for obvious 
> reasons.
Jean also shows screenshots at the link above
how perf timechart or the the corresponding
gui app PyTimechart still works together with these.
I can't see how the new events should break an existing app, they should
just ignore events they are not aware of.

     Thomas
