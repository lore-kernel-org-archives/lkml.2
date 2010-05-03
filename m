Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0ECSHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:07:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58844 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755712Ab0ECSHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:07:46 -0400
Date: Mon, 3 May 2010 19:07:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100503180741.GB2098@rakim.wolfsonmicro.main>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <87wrvl5479.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wrvl5479.fsf@deeprootsystems.com>
X-Cookie: APL hackers do it in the quad.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 09:40:26AM -0700, Kevin Hilman wrote:

> At least from the kernel perspective, both suspend blockers and
> runtime PM have the same goal.  Given that, which framework should the
> driver writer target?  Both?  Seems like duplicate effort.  Using
> suspend blockers assumes the system is in opportunitstic suspend mode
> and (at least in the keypad example given) assumes a suspend-blocker
> aware userspace (Android.) Without both, targeted power savings will
> not be acheived.

The other concern here is that for many mobile systems the actual
semantic intended by "suspend" as it's currently used is more runtime PM
like than full suspend - the classic example of this is that when
suspending while on a call in a phone you don't want to suspend the
modem or audio CODEC, you want to leave them running.  If you use a full
system suspend then the drivers for affected components have to play
guessing games (or add currently non-standard knobs for apps to twiddle)
to decide if the system intends them to actually implement the suspend
or not but with runtime PM it all falls out very naturally without any
effort on the part of the driver.

> To me, runtime PM is a generic and flexible approach that can be used
> with any userspace.  Driver writers should not have to care whether
> the system is in "opportunistic" mode or about whether userspace is
> suspend blocker capable.  They should only have to think about when
> the device is (or should be) idle.

I fully agree with this.  We do need to ensure that a runtime PM based
system can suspend the CPU core and RAM as well as system suspend can
but that seems doable.
