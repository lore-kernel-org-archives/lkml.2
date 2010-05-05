Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab0EEU0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:26:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57986 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757481Ab0EEU0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:26:41 -0400
Date: Wed, 5 May 2010 21:26:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: tytso@mit.edu, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505202637.GH7139@rakim.wolfsonmicro.main>
References: <20100505185225.GA4411@srcf.ucam.org>
 <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
 <20100505192208.GB5085@srcf.ucam.org>
 <20100505195249.GC11441@sirena.org.uk>
 <20100505195534.GD18762@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505195534.GD18762@thunk.org>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 03:55:34PM -0400, tytso@mit.edu wrote:

> I confess I've completely lost track of (a) what problem you are
> trying to solve, and (b) how this might relate to some change that
> you'd like to see in the suspend block API.  Could you do a quick
> summary and recap?  I've gone over the entire thread, and it's still
> not clear what change you're advocating for in suspend blockers.

The issue isn't suspend blockers, it's the opportunistic suspend stuff
that goes along with them.  When that is in use the system suspends
vastly more aggressively, including in situations where a runtime PM
based approach like mainline had been adopting would not suspend since
some devices still need to be active, the classic case being keeping the
audio subsystem and baseband live when in a phone call.  This problem
did not appear to have been considered as things stood.  

I'm not really advocating a change in what's there.  What I'm looking
for is some sort of agreement as to how subsystems and drivers that need
to not act on suspend requests from the core in these situations should
do that.  If there is a generic solution it'd probably be an additional
mostly orthogonal interface rather than a change to what's being
proposed here.

What we look like we're converging on is a subsystem/driver local
solution since it doesn't look like a terribly widespread problem.
That's totally OK, it's just that as I have said I don't want to go off
and do that without the general PM community being aware of it so we
avoid anyone running into nasty surprises further down the line.
