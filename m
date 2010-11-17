Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935452Ab0KQT5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:57:12 -0500
Received: from canuck.infradead.org ([134.117.69.58]:37933 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935187Ab0KQT5K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:57:10 -0500
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4CE43153.2070206@linux.vnet.ibm.com>
References: <1289339119.2191.92.camel@laptop>
	 <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com>
	 <1289398207.2191.117.camel@laptop> <1289398763.2191.121.camel@laptop>
	 <AANLkTimQ7w38wzrYT4MgjHFr6LCVj2M5fB11-n3XCD2w@mail.gmail.com>
	 <1289421164.2084.56.camel@laptop>
	 <AANLkTiku7UsVoYv_+6r79rvGPJU7OU=VGDiaYo0H=82y@mail.gmail.com>
	 <1289423135.2084.63.camel@laptop>  <4CE33F86.7040403@linux.vnet.ibm.com>
	 <1289993128.2109.714.camel@laptop>  <4CE43153.2070206@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 20:57:14 +0100
Message-ID: <1290023834.2109.1240.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 11:47 -0800, Corey Ashford wrote:
> 
> This is an interesting approach, though for the IBM WSP (aka PowerEN) 
> chip, the config_format would have to be at a deeper level than the PMU, 
> because the modifiers that affect the event, vary from event to event. 
> Either that or you'd have to provide a complex union structure.

Eew.. how uhm creative ;-), yeah, not quite sure how to deal with that,
I wasn't planning to make a directory for each event, just a single file
with the u64 in it.

> However, above you say that you want to have "a few frequently 
> used/common events".  I thought that was the job of the perf "generic 
> events".  My understanding was that the sysfs tree was the solution for 
> all events, including arch-specific, and seldom-used events. 

My intent for the sysfs bits is to replace all the static stuff encoded
in PERF_TYPE_ and PERF_COUNT_ because it simply doesn't extend to a much
more dynamic world.

And GPUs/DSPs might have radically different common events than CPUs do.

Doing exhaustive lists in sysfs is simply going to waste tons of memory
for no real gain.

>  Ingo 
> pushed back on a user-space library solution (like libpfm4) because he 
> wanted event info in sysfs (or some other mechanism by which the kernel 
> could expose event info to user space).

I can't fully remember the details of that discussion.

> If there is going to be no place in sysfs for arch-specific events, I'll 
> want to start pushing for perf to be able to use a user space library again.
> 
> How about a compromise position: all of the arch-specific events are 
> exposed to user space via sysfs iff some CONFIG_* variable to set to 
> true.  Something like CONFIG_EXPOSE_ALL_HW_PERF_EVENTS_IN_SYSFS.
> This way you would only use all that memory when it's explicitly 
> configured in. 

Ingo, any opinions?
