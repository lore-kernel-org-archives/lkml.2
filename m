Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227Ab1DZOG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:06:29 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35971 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab1DZOG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:06:28 -0400
Date: Tue, 26 Apr 2011 16:05:57 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@amd64.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/18] perf: Add persistent event facilities
Message-ID: <20110426140557.GA24614@aftab>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
 <1303576100-425-3-git-send-email-bp@amd64.org>
 <1303815470.20212.260.camel@twins>
 <20110426124510.GB15076@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426124510.GB15076@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 08:45:10AM -0400, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Sat, 2011-04-23 at 18:28 +0200, Borislav Petkov wrote:
> > > From: Borislav Petkov <borislav.petkov@amd.com>
> > > 
> > > Add a barebones implementation for registering persistent events with
> > > perf. For that, we don't destroy the buffers when they're unmapped and
> > > we map them read-only so that multiple agents can access them.
> > > 
> > > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > > ---
> > >  include/linux/perf_event.h |   22 ++++++++++++++++-
> > >  kernel/events/Makefile     |    2 +-
> > >  kernel/events/core.c       |   30 ++++++++++++++++++----
> > >  kernel/events/persistent.c |   56 ++++++++++++++++++++++++++++++++++++++++++++
> > >  4 files changed, 102 insertions(+), 8 deletions(-)
> > >  create mode 100644 kernel/events/persistent.c
> > > 
> > > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > > index ee9f1e7..37bfae1 100644
> > > --- a/include/linux/perf_event.h
> > > +++ b/include/linux/perf_event.h
> > > @@ -216,8 +216,9 @@ struct perf_event_attr {
> > >                                 precise_ip     :  2, /* skid constraint       */
> > >                                 mmap_data      :  1, /* non-exec mmap data    */
> > >                                 sample_id_all  :  1, /* sample_type all events */
> > > +                               persistent     :  1, /* event always on */
> > 
> > But how will you find it again?
> > 
> > Persistent yells filesystem to me, and while we didn't use relayfs for 
> > various reasons, I think we do need something like it at the current stage.
> 
> eventfs or sysfs?
> 
> We need VFS space for event hierarchy enumeration anyway (and move the current 
> debugfs bits there). Persistent events could show up in that hiearachy as well.

I think we talked about this already in conjunction with moving event
hierarchy to sysfs - there you can have a "persistent" node too so you
can find it.

Here's what we talked about then:

https://lkml.org/lkml/2010/11/11/10

this and the following messages.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
