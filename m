Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0EGMZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:25:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46137 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753673Ab0EGMZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:25:23 -0400
Date: Fri, 7 May 2010 13:25:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Brian Swetland <swetland@google.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Matthew Garrett <mjg@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100507122520.GD21498@rakim.wolfsonmicro.main>
References: <20100505185225.GA4411@srcf.ucam.org>
 <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
 <m2oa55d774e1005051356n3610d780ra42200c1785e02bd@mail.gmail.com>
 <20100505234025.GB4838@opensource.wolfsonmicro.com>
 <l2kd6200be21005052125rc43217a2r8c65bc98e7a5d3d4@mail.gmail.com>
 <20100507100406.GA21498@rakim.wolfsonmicro.main>
 <w2kd6200be21005070357r9aad2896l355168a23bf85eae@mail.gmail.com>
 <20100507112102.GC21498@rakim.wolfsonmicro.main>
 <81818215-44A2-4B74-A43F-E2644C950F5C@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81818215-44A2-4B74-A43F-E2644C950F5C@mit.edu>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 07:29:47AM -0400, Theodore Tso wrote:

> This sounds like it may be something unique to your board/product.  Or
> am I missing something?

I suspect you're missing something here - I'm approaching this as one of
the maintainers of the embedded audio subsystem for the kernel.  I need
to worry about any system running Linux which has an embedded style
audio subsystem.  The problem might be unique to audio, but I can't say
that for certain.

> One of the challenges with PM in the embedded world is that everybody
> seems to have slightly different assumptions, and hardware that doesn't
> behave the same way.

This isn't really a problem for audio - we've already got a subsystem
which copes well with pretty much all systems and does runtime PM that's
equivalent to suspending already, which is half the problem here.  If we
had less generalisation this would probably not have come up.

> More than once this discussion has wandered off into the weeds wrt to
> whether this patch series is ready to be merged, since there are so many
> drivers blocked on it....

Once more, my main objective here has been to make sure that when this
is merged we've got a joined up story about how people think this hangs
together, which I think we have now.  As I say now that we have that
understanding I don't see any reason to block merge.

It's unfortunate that I only noticed that this was actually wakelocks
very late in the day but I think I can get an implementation which
handles paths that ignore suspends done quickly.
