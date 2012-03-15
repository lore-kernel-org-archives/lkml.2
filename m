Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031580Ab2COQEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 12:04:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54582 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964884Ab2COQEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 12:04:48 -0400
Message-ID: <1331827471.18960.195.camel@twins>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Don Zickus <dzickus@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Mandeep Singh Baines <msb@chromium.org>
Date: Thu, 15 Mar 2012 17:04:31 +0100
In-Reply-To: <20120315155413.GE3941@redhat.com>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
	 <20120314161906.e53359d3.akpm@linux-foundation.org>
	 <20120315080232.GA17163@tiehlicka.suse.cz>
	 <20120315155413.GE3941@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 11:54 -0400, Don Zickus wrote:
> > > Why did watchdog() reset the scheduling policy seven instructions
> > > before exiting?  Seems pointless.
> > 
> > It has been introduced by Thomas in cba9bd22. To be honest I don't
> > understand why it makes a sense?
> 
> Yeah I noticed that too.  I didn't bother questioning it either when
> it
> went in.  I just assumed Thomas and Peter know scheduling a lot better
> than I do. :-) 

I just dug through my IRC logs and the reason is that running the entire
exit path as a highest priority RT task incurs a latency spike to other
tasks running on the system (313us). Since there's absolutely no point
in running the exit path as a RT task, tglx made it not do that.
