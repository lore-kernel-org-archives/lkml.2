Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0EGK5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:57:40 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50141 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab0EGK5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:57:39 -0400
MIME-Version: 1.0
In-Reply-To: <20100507100406.GA21498@rakim.wolfsonmicro.main>
References: <20100505185225.GA4411@srcf.ucam.org>
	 <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
	 <m2oa55d774e1005051356n3610d780ra42200c1785e02bd@mail.gmail.com>
	 <20100505234025.GB4838@opensource.wolfsonmicro.com>
	 <l2kd6200be21005052125rc43217a2r8c65bc98e7a5d3d4@mail.gmail.com>
	 <20100507100406.GA21498@rakim.wolfsonmicro.main>
Date: Fri, 7 May 2010 03:57:37 -0700
Message-ID: <w2kd6200be21005070357r9aad2896l355168a23bf85eae@mail.gmail.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/7 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Wed, May 05, 2010 at 09:25:18PM -0700, Arve Hjønnevåg wrote:
>> On Wed, May 5, 2010 at 4:40 PM, Mark Brown
>
>> > This really does depend heavily on system design and the intended
>> > function of the suspend on the part of the initiator.  In many systems
>> > suspend will remove sufficient power to stop audio running even if it
>> > were desired, and there's the idea with existing manually initiated
>> > suspends that the system should stop what it's doing and go into a low
>> > power, low responsiveness state.  Some systems will initiate a suspend
>> > with active audio paths (especially those to or from the AP) which they
>> > expect to be stopped.
>
>> You can support both in the same driver in some cases (without a
>> switch). If the hardware cannot wake the system when it needs more
>> audio buffers, then the driver needs to block suspend while audio is
>> playing. Since suspend blockers only block opportunistic suspend, the
>> driver can also implement suspend to stop audio playback and it will
>> only be called for forced suspend.
>
> As discussed elsewhere in the thread a suspend blocker is not desirable
> here - the AP is not doing anything useful on a voice call so blocking
> the suspend will just waste power unless runtime PM is good enough to
> mean opportunistic suspend isn't adding anything anyway.  It will avoid
> the immediate issue with loosing audio but it's not really what we want
> to happen.
>

I was talking about audio from the AP. Why would you ever turn off
another core's audio path on suspend?

-- 
Arve Hjønnevåg
