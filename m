Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab0KJVFe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 16:05:34 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39796 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab0KJVFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 16:05:32 -0500
Subject: Re: [RFC][PATCH] perf: sysfs type id
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <AANLkTiku7UsVoYv_+6r79rvGPJU7OU=VGDiaYo0H=82y@mail.gmail.com>
References: <1289339119.2191.92.camel@laptop>
	 <AANLkTi=ojOnLyRO4hTgYdCCXLsN0wUeTcme=5h8-mjdz@mail.gmail.com>
	 <1289398207.2191.117.camel@laptop> <1289398763.2191.121.camel@laptop>
	 <AANLkTimQ7w38wzrYT4MgjHFr6LCVj2M5fB11-n3XCD2w@mail.gmail.com>
	 <1289421164.2084.56.camel@laptop>
	 <AANLkTiku7UsVoYv_+6r79rvGPJU7OU=VGDiaYo0H=82y@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 10 Nov 2010 22:05:35 +0100
Message-ID: <1289423135.2084.63.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-10 at 21:53 +0100, Stephane Eranian wrote:
> On Wed, Nov 10, 2010 at 9:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2010-11-10 at 21:08 +0100, Stephane Eranian wrote:
> >> Would that be by passing the full filename to the tool?
> >
> > possible, or something like <pmu-name>:<event-name>, cpu:cycles would
> > map to /sys/class/pmu/cpu/events/cycles (given the previous patch).
> >
> >
> Ok, but I think you're proposal is missing one bit. You are addressing
> the class (or type) of PMU, but you are not addressing the naming of
> an instance.
> 
> Let's take an example, suppose you have counters on a graphic card.
> Your system has two such graphic cards. In your scheme you would
> end up with a sys/class/pmu/gfx/.....
> 
> But now, suppose I want to count cycles on the first graphic card.
> Seems to me you need to expose the instances as well. The instance
> number needs to be passed in the attr struct somehow.
> 
> You can either create multiple subdir under gfx, or have this info somewhere
> else in the sysfs tree, if people really care about class vs. instance.
> 
> I can see users doing:
> $ perf stat -e gfx@1::cycles ...  -> sys/class/gfx/1/event/cycles
> 
> The reason I am using :: here is because libpfm4 is already using
> this as a separator for PMU type vs. event.


right, so the idea is to have these pmu devices hooked into the existing
sysfs topology, my proposed patch misses that bit because I wanted to
get something out before having to dig through the topology code trying
to figure out how all that works.

So the 'cpu' pmu device would be linked from:

  /sys/devices/system/cpu/pmu -> /sys/class/pmu/cpu

and gfx things would be linked like:

  /sys/devices/pci0000:00/0000:00:1e.0/0000:0b:01.0/drm/card0/pmu -> /sys/class/pmu/radeon0


