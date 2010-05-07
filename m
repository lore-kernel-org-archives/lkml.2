Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab0EGLlH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 07:41:07 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:63527 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab0EGLlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 07:41:05 -0400
MIME-Version: 1.0
In-Reply-To: <20100507112102.GC21498@rakim.wolfsonmicro.main>
References: <20100505185225.GA4411@srcf.ucam.org>
	 <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
	 <m2oa55d774e1005051356n3610d780ra42200c1785e02bd@mail.gmail.com>
	 <20100505234025.GB4838@opensource.wolfsonmicro.com>
	 <l2kd6200be21005052125rc43217a2r8c65bc98e7a5d3d4@mail.gmail.com>
	 <20100507100406.GA21498@rakim.wolfsonmicro.main>
	 <w2kd6200be21005070357r9aad2896l355168a23bf85eae@mail.gmail.com>
	 <20100507112102.GC21498@rakim.wolfsonmicro.main>
Date: Fri, 7 May 2010 04:41:02 -0700
Message-ID: <t2od6200be21005070441sec3111f3k550ba03553abcc8c@mail.gmail.com>
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
> On Fri, May 07, 2010 at 03:57:37AM -0700, Arve Hjønnevåg wrote:
>> 2010/5/7 Mark Brown <broonie@opensource.wolfsonmicro.com>:
>
>> > As discussed elsewhere in the thread a suspend blocker is not desirable
>> > here - the AP is not doing anything useful on a voice call so blocking
>> > the suspend will just waste power unless runtime PM is good enough to
>> > mean opportunistic suspend isn't adding anything anyway.  It will avoid
>> > the immediate issue with loosing audio but it's not really what we want
>> > to happen.
>
>> I was talking about audio from the AP. Why would you ever turn off
>> another core's audio path on suspend?
>
> This goes back to the thing about a full system suspend being a
> sledgehammer which doesn't give enough information about what's going
> on when it's used like this.  As discussed we need a way to know that
> the connections involved are able to stay live during suspend (on a
> large proportion of systems suspend is going to mean that the relevant
> bits of the board will loose power so need to be shut down) and that

Are you trying to use the same driver on systems that can support
audio while suspend and on systems where this is impossible? If audio
cannot work while suspended, supporting opportunistic suspend is easy.
You block suspend while audio is active.

If the hardware does support some audio paths while suspended, I'll
ask again, is there a reason to turn them off on suspend?

> that the intention of the user is that they should do so (this isn't
> clear in the general system, especially not if the suspend is initiated
> manually).
>
> With a runtime PM approach this is trivial - we just turn off anything
> that isn't in use at the current time.  I'll need to extend ASoC to add
> information about what to do on suspend to the existing power data.
>
OK, but is this at all related to opportunistic suspend?

-- 
Arve Hjønnevåg
