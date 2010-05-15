Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab0EODkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 23:40:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:2269 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab0EODkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 23:40:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=cUHYGyn0irsQz5o4qn2ZTc48IKkrrngJjPDURFi+qWxRxz+8AqhJjHYEm1dL2uamG
	8E0dWXddOgAyuo1+poo+Q==
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1005142256070.11498-100000@netrider.rowland.org>
References: <AANLkTil-Ky5L84JF7xn6su8VMtglBpZwCNIh7VgBiHgL@mail.gmail.com>
	 <Pine.LNX.4.44L0.1005142256070.11498-100000@netrider.rowland.org>
Date: Fri, 14 May 2010 20:40:08 -0700
Message-ID: <AANLkTinwJdPneNSlAeTml5fHW2LFy53Dz3DRf95y1Bcl@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
From: Brian Swetland <swetland@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Lindgren <tony@atomide.com>,
       Matthew Garrett <mjg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       magnus.damm@gmail.com, "Theodore Ts'o" <tytso@mit.edu>,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>,
       =?UTF-8?Q?Beno=C3=AEt_Cousson?= <b-cousson@ti.com>,
       linux-omap@vger.kernel.org, Vitaly Wool <vitalywool@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 7:58 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 14 May 2010, Brian Swetland wrote:
>
>> It provides useful functionality -- you apparently disagree, but the
>> wakelock/suspendblock model is in use, shipping, and solving problems
>> for quite a lot of android devices that have been shipping for a while
>> now.  We actively go to lowest power state in idle (on omap, msm,
>> etc), and use drivers that aggressively declock and depower modules
>> (similar to runtime pm), but we have found that using the
>> opportunistic suspend model combined with wakelocks allows us to
>> attain even lower average power consumption in always-connected,
>> actively-syncing devices.
>
> Can you explain this in more detail?  Are you saying that some devices
> go on generating interrupts and causing timers to be scheduled, even
> though what they're doing isn't important enough to prevent the system
> from powering down?

In tickless mode, the time until next timer is a signed int, so the
longest the kernel will ever sleep is ~2 seconds at a go.  In
practice, userspace entities often have polling behavior that can
trigger more often than that, and I've observed some kernel periodic
timers (haven't cataloged them recently) that happen more often than
once a second.

When we go to full suspend, we know that only specific wakeup sources
(keyboard gpios, baseband voice/ip events, rtc alarms, etc) are going
to wake us up.

Brian
