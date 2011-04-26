Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab1DZMpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 08:45:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44862 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab1DZMpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 08:45:32 -0400
Date: Tue, 26 Apr 2011 14:45:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@amd64.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 02/18] perf: Add persistent event facilities
Message-ID: <20110426124510.GB15076@elte.hu>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
 <1303576100-425-3-git-send-email-bp@amd64.org>
 <1303815470.20212.260.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303815470.20212.260.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Sat, 2011-04-23 at 18:28 +0200, Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > Add a barebones implementation for registering persistent events with
> > perf. For that, we don't destroy the buffers when they're unmapped and
> > we map them read-only so that multiple agents can access them.
> > 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  include/linux/perf_event.h |   22 ++++++++++++++++-
> >  kernel/events/Makefile     |    2 +-
> >  kernel/events/core.c       |   30 ++++++++++++++++++----
> >  kernel/events/persistent.c |   56 ++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 102 insertions(+), 8 deletions(-)
> >  create mode 100644 kernel/events/persistent.c
> > 
> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index ee9f1e7..37bfae1 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -216,8 +216,9 @@ struct perf_event_attr {
> >                                 precise_ip     :  2, /* skid constraint       */
> >                                 mmap_data      :  1, /* non-exec mmap data    */
> >                                 sample_id_all  :  1, /* sample_type all events */
> > +                               persistent     :  1, /* event always on */
> 
> But how will you find it again?
> 
> Persistent yells filesystem to me, and while we didn't use relayfs for 
> various reasons, I think we do need something like it at the current stage.

eventfs or sysfs?

We need VFS space for event hierarchy enumeration anyway (and move the current 
debugfs bits there). Persistent events could show up in that hiearachy as well.

Thanks,

	Ingo
