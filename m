Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758486Ab0EEUnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:43:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48275 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab0EEUnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:43:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Date: Wed, 5 May 2010 22:44:03 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: tytso@mit.edu, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "Arve Hj?nnev?g" <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
References: <20100505185225.GA4411@srcf.ucam.org> <20100505195534.GD18762@thunk.org> <20100505202637.GH7139@rakim.wolfsonmicro.main>
In-Reply-To: <20100505202637.GH7139@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005052244.03225.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 May 2010, Mark Brown wrote:
> On Wed, May 05, 2010 at 03:55:34PM -0400, tytso@mit.edu wrote:
> 
> > I confess I've completely lost track of (a) what problem you are
> > trying to solve, and (b) how this might relate to some change that
> > you'd like to see in the suspend block API.  Could you do a quick
> > summary and recap?  I've gone over the entire thread, and it's still
> > not clear what change you're advocating for in suspend blockers.
> 
> The issue isn't suspend blockers, it's the opportunistic suspend stuff
> that goes along with them.  When that is in use the system suspends
> vastly more aggressively, including in situations where a runtime PM
> based approach like mainline had been adopting would not suspend since
> some devices still need to be active, the classic case being keeping the
> audio subsystem and baseband live when in a phone call.  This problem
> did not appear to have been considered as things stood.  
> 
> I'm not really advocating a change in what's there.  What I'm looking
> for is some sort of agreement as to how subsystems and drivers that need
> to not act on suspend requests from the core in these situations should
> do that.  If there is a generic solution it'd probably be an additional
> mostly orthogonal interface rather than a change to what's being
> proposed here.
> 
> What we look like we're converging on is a subsystem/driver local
> solution since it doesn't look like a terribly widespread problem.
> That's totally OK, it's just that as I have said I don't want to go off
> and do that without the general PM community being aware of it so we
> avoid anyone running into nasty surprises further down the line.

To me, the above may be summarized that in your opinion some components of
the system will generally need to stay powered when it's suspended
opportunistically, so we need an interface to specify which components they are.
Is that correct?

Rafael
