Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496Ab0EGOAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:00:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58458 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751990Ab0EGOAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:00:23 -0400
Date: Fri, 7 May 2010 15:00:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: Brian Swetland <swetland@google.com>,
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
Message-ID: <20100507140020.GE21498@rakim.wolfsonmicro.main>
References: <20100505185225.GA4411@srcf.ucam.org>
 <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
 <m2oa55d774e1005051356n3610d780ra42200c1785e02bd@mail.gmail.com>
 <20100505234025.GB4838@opensource.wolfsonmicro.com>
 <l2kd6200be21005052125rc43217a2r8c65bc98e7a5d3d4@mail.gmail.com>
 <20100507100406.GA21498@rakim.wolfsonmicro.main>
 <w2kd6200be21005070357r9aad2896l355168a23bf85eae@mail.gmail.com>
 <20100507112102.GC21498@rakim.wolfsonmicro.main>
 <t2od6200be21005070441sec3111f3k550ba03553abcc8c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <t2od6200be21005070441sec3111f3k550ba03553abcc8c@mail.gmail.com>
X-Cookie: Exercise caution in your daily affairs.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 04:41:02AM -0700, Arve Hjønnevåg wrote:
> 2010/5/7 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > This goes back to the thing about a full system suspend being a
> > sledgehammer which doesn't give enough information about what's going
> > on when it's used like this.  As discussed we need a way to know that
> > the connections involved are able to stay live during suspend (on a
> > large proportion of systems suspend is going to mean that the relevant
> > bits of the board will loose power so need to be shut down) and that

> Are you trying to use the same driver on systems that can support
> audio while suspend and on systems where this is impossible? If audio

Yes, each chip in the audio subsystem gets its own device driver.  All
Linux systems using a given CODEC share the device specific driver code
(modulo out of tree code, obviously).  Further, the power management is
mostly abstracted out of the individual device drivers into the embedded
audio core so the individual drivers don't really take any decisions
about power for themselves.

> cannot work while suspended, supporting opportunistic suspend is easy.
> You block suspend while audio is active.

Right, but that's not really an interesting case here.

> If the hardware does support some audio paths while suspended, I'll
> ask again, is there a reason to turn them off on suspend?

As the mail you're replying to says:

> > that the intention of the user is that they should do so (this isn't
> > clear in the general system, especially not if the suspend is initiated
> > manually).

this all comes down to the intention of the user when they initiated the
suspend.

> > With a runtime PM approach this is trivial - we just turn off anything
> > that isn't in use at the current time.  I'll need to extend ASoC to add
> > information about what to do on suspend to the existing power data.

> OK, but is this at all related to opportunistic suspend?

Well, opportunistic suspend is essentially blurring the lines between a
suspend and runtime PM - it's using suspend as part of the automatic
drive down into the lowest possible power state.  I'm just saying that
in a pure runtime PM model this issue doesn't come up since the suspend
semantic is much clearer.
