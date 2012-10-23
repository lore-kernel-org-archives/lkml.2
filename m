Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab2JWNWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:22:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59805 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab2JWNWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:22:42 -0400
Date: Tue, 23 Oct 2012 15:22:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 14/34] perf, x86: Avoid checkpointed counters causing excessive TSX aborts
Message-ID: <20121023132240.GW16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org> <1350602382-12771-15-git-send-email-andi@firstfloor.org> <1350997423.13456.21.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350997423.13456.21.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:03:43PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-10-18 at 16:19 -0700, Andi Kleen wrote:
> > @@ -1079,6 +1079,17 @@ static void intel_pmu_enable_event(struct perf_event *event)
> >  int intel_pmu_save_and_restart(struct perf_event *event)
> >  {
> >         x86_perf_event_update(event);
> > +       /*
> > +        * For a checkpointed counter always reset back to 0.  This
> > +        * avoids a situation where the counter overflows, aborts the
> > +        * transaction and is then set back to shortly before the
> > +        * overflow, and overflows and aborts again.
> > +        */
> > +       if (event->hw.config & HSW_INTX_CHECKPOINTED) {
> 
> Would an unlikely() make sense there? Most events won't have this set.

Ok.

-Andi
