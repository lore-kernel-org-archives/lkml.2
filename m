Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab2J1TMq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 15:12:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35806 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab2J1TMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 15:12:44 -0400
Date: Sun, 28 Oct 2012 20:12:43 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, eranian@google.com,
        mingo@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 31/33] perf, tools: Support generic events as pmu event names v2
Message-ID: <20121028191243.GO16230@one.firstfloor.org>
References: <1351283415-13170-1-git-send-email-andi@firstfloor.org> <1351283415-13170-32-git-send-email-andi@firstfloor.org> <20121027194200.GD1039@krava.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121027194200.GD1039@krava.redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 09:42:00PM +0200, Jiri Olsa wrote:
> On Fri, Oct 26, 2012 at 01:30:13PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Extend the parser/lexer to allow generic event names like
> > "instructions" as a sysfs supplied PMU event name.
> > 
> > This resolves the problem that cpu/instructions/ gives a parse
> > error, even when the kernel supplies a "instructions" event
> > 
> > This is useful to add sysfs specified qualifiers to these
> > events, for example cpu/instructions,intx=1/ and needed
> > for the TSX events
> > 
> > Simply extend the grammar to handle this case. The lexer
> > needs minor changes to save the original string.
> 
> ops, I think you need to check recent changes:

Note I wrote and posted all this before you posted last week, but the wheels
of perf review grind so slowly that you overtook me.

Peter Z., to be honest all these later patches are just caused by not having
generic TSX events/modifiers and you not liking my original approach.

I'm now at 10+ patches for the sysfs stuff and counting and have conflicts
with parallel work by Jiri and in general it's still all somewhat hacky and
actually far more code than the original patches.

I'm very tempted to go back to the original approach with generic
events and modifiers, that was far simpler and cleaner and really
did work better, and it was a far less intrusive patchkit.

Comments?

-Andi

