Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2ADWuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 17:50:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:46716 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab2ADWuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 17:50:14 -0500
Subject: Re: perf_events: proposed fix for broken intr throttling (repost)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, gleb@redhat.com,
        asharma@fb.com, vince@deater.net, wcohen@redhat.com
In-Reply-To: <CABPqkBSR4a7PCyYxhE0kpepc3f0f6Rh6JU55_A3ubWYnN+G3iA@mail.gmail.com>
References: <20120104143945.GA4783@quad> <1325712298.3084.5.camel@laptop>
	 <CABPqkBSR4a7PCyYxhE0kpepc3f0f6Rh6JU55_A3ubWYnN+G3iA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jan 2012 23:49:56 +0100
Message-ID: <1325717396.3084.12.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 21:33 +0000, Stephane Eranian wrote:
> > I don't think it needs that, I do dislike the unconditional iterate all
> > events thing though. Maybe we can set some per-cpu state indicating
> > someone got throttled (rare under normal operation -- you'd hope) and
> > only iterate to unthrottle when we find this set.
> >
> Could try that too.
> 
> > I think the event scheduling resulting from migration will already
> > re-enable the event, avoiding the loss of unthrottle due to that..
> > although it would be good to verify that.
> >
> Yes, you're not dead forever, but still it is not acceptable as is. 

Oh for sure, I didn't mean it like that. What I was getting at is a
counter getting throttled on one cpu, setting the per-cpu variable,
getting migrated and not getting unthrottled due to now living on
another cpu which doesn't have the per-cpu thing set.

If the scheduling resulting from the migration already unthrottles that
scenario can't happen.

