Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0ENQG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:06:56 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:38243 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab0ENQGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:06:54 -0400
To: Matthew Garrett <mjg@redhat.com>
Cc: Tony Lindgren <tony@atomide.com>, Alan Stern <stern@rowland.harvard.edu>,
       Paul Walmsley <paul@pwsan.com>,
       Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       magnus.damm@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       =?iso-8859-1?Q?Beno=EEt?= Cousson <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
References: <alpine.DEB.2.00.1005122118530.7624@utopia.booyaka.com>
	<Pine.LNX.4.44L0.1005131002380.1695-100000@iolanthe.rowland.org>
	<20100513191717.GA3428@atomide.com>
	<20100513192522.GA19256@srcf.ucam.org>
	<20100513194205.GC3428@atomide.com>
	<20100513195349.GB19722@srcf.ucam.org>
	<20100513200003.GE3428@atomide.com>
	<20100513200814.GA20254@srcf.ucam.org>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Fri, 14 May 2010 09:06:50 -0700
In-Reply-To: <20100513200814.GA20254@srcf.ucam.org> (Matthew Garrett's message of "Thu\, 13 May 2010 21\:08\:14 +0100")
Message-ID: <878w7mpiw5.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett <mjg@redhat.com> writes:

> On Thu, May 13, 2010 at 01:00:04PM -0700, Tony Lindgren wrote:
>
>> The system stays running because there's something to do. The system
>> won't suspend until all the processors hit the kernel idle loop and
>> the next_timer_interrupt_critical() returns nothing.
>
> At which point an application in a busy loop cripples you. I think we 
> could implement your suggestion more easily by just giving untrusted 
> applications an effectively infinite amount of timer slack, 
>
> but it still doesn't handle the case where an app behaves
> excrutiatingly badly.

Is design for exruciatingly bad apps a design requirement?

If so, opportunistic suspend + suspend blockers fails as well.  An app
could easily hold a suspend blocker during its entire execution
crippling PM.

Using opportunistic suspend may possibly allow you contain bad
apps/drivers, but at the cost of having to patch already working and
trusted apps and known-working kernel code with suspend blockers.

IMO, rather than accepting a solution that allows bad apps to run
wild, it would be much better to _continue_ focus on tools for finding
and containing bad apps.  This approach has the added bonus of solving
problems on *every* linux-based system, not just Android.

Kevin
