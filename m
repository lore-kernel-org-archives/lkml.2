Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919Ab2ERLYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 07:24:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36052 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754523Ab2ERLYf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 07:24:35 -0400
Message-ID: <1337340263.573.31.camel@twins>
Subject: Re: [PATCH 1/2] perf: Add persistent event facilities
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 18 May 2012 13:24:23 +0200
In-Reply-To: <20120518110357.GH20215@aftab.osrc.amd.com>
References: <1332340496-21658-1-git-send-email-bp@amd64.org>
	 <1332340496-21658-2-git-send-email-bp@amd64.org>
	 <1337336040.573.12.camel@twins> <20120518110357.GH20215@aftab.osrc.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 13:03 +0200, Borislav Petkov wrote:
> >  - you allow an arbitrary place in debugfs; this might make finding
> > them 'interesting'. Should we put them all in the same place?
> 
> My take on this is that we want to be able to make the same events we
> have now, persistent. Basically not trace for the duration of a child
> process but in a process-agnostic way, system-wide.

This would argue against per-task persistent events.. 

> In that case, we probably want to be able to mark events as persistent,
> maybe add another node in debugfs:
> 
> (debugfs)/tracing/events/mce/mce_record/attr
> 
> which can be used for flags or whatever, or something to that effect... 

( while mce is a user of persistent events, it seems to me in general
persistent events should not be related to mce )

However you raise a valid point about keeping track of what events are
spooled into that buffer.

Note the plural there, it might be very desirable to allow multiple
events into a single persistent buffer.


