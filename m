Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0ENAaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:30:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34313 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756048Ab0ENA37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:29:59 -0400
Date: Fri, 14 May 2010 01:29:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Brian Swetland <swetland@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <gregkh@suse.de>,
       Daniel Walker <dwalker@fifo99.com>, Matthew Garrett <mjg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, Arve Hj?nnev?g <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Tony Lindgren <tony@atomide.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Alan Stern <stern@rowland.harvard.edu>, magnus.damm@gmail.com,
       "Theodore Ts'o" <tytso@mit.edu>, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, Beno?t Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100514002956.GB4798@opensource.wolfsonmicro.com>
References: <1272667021-21312-1-git-send-email-arve@android.com> <20100513214653.GA21120@suse.de> <20100513222748.GA3240@opensource.wolfsonmicro.com> <201005140046.33508.rjw@sisk.pl> <20100513233608.GA1582@sirena.org.uk> <r2qa55d774e1005131648i1702d3b2ob6bc823e4a4a113c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <r2qa55d774e1005131648i1702d3b2ob6bc823e4a4a113c@mail.gmail.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 04:48:40PM -0700, Brian Swetland wrote:
> On Thu, May 13, 2010 at 4:36 PM, Mark Brown

> Current published trees are based on .32 (used for the coming-soon
> froyo release that's been in late QA for a while now) and forward
> development is moving to .34 post final (or in the case of tegra2,
> tracking .34-rc series as it happens).  We've been actively snapping
> up to track mainline since we started doing this around 2.6.16.  We'd

Yeah, I had noticed the development stuff was more up to date - it'll be
good once it gets out of QA and into general use since system
integrators do seem to pick up your new releases fairly quickly.

> *love* to be able to get more stuff sanely upstream instead of
> maintaining branches and rebasing every other mainline release or so.

Having greatly cut down the number of out of tree drivers I'm carrying I
can only say that it's great when it happens :)

> I'd love to have a separate discussion on using standard linux
> embedded audio for mobile devices -- one of my goals for 2010 is to
> try to migrate from our "one off" approach on MSM to making use of

Probably best to do that, this thread is already quite big enough
without going off on a tangent.  FWIW we can usually be found in
#alsa-soc on freenode as well as on the lists.  A couple of pointers
which might help your research, though:

> ALSA and standard interfaces.  I have a lot of questions about handing
> encoded data (mp3/aac/etc) that will be processed by the DSP, how to

This usually doesn't go through ALSA at all (the ALSA APIs can't cope
with variable bitrate data), the data currently goes via DSP specific
APIs and gets injected into the ALSA domain in much the same way as data
from the baseband.

> approach routing control, and how to best interact with the
> user/kernel interface, etc.

Routing control for embedded systems is done by exposing the routing
control to userspace via ALSA controls which can be set by apps - using
a GUI to configure the routes interactively is a massive usability win
in development.  Abstraction for generic user-visible apps is intended
to be handled by a layer on top of that:

	http://www.slimlogic.co.uk/?p=40

which is currently in development but I believe is expected to come to
fruition this year (Liam is driving this one).
