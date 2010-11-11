Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab0KKGkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 01:40:04 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61371 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab0KKGkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 01:40:03 -0500
MIME-Version: 1.0
In-Reply-To: <20101110150057.GB14496@elte.hu>
References: <1289339119.2191.92.camel@laptop> <20101109221338.GA19947@suse.de>
 <1289392037.2191.105.camel@laptop> <20101110133638.GC11388@elte.hu>
 <AANLkTikkV1pdseitAPkXTyK529vsvbaVb-RMiMY4Ao-+@mail.gmail.com> <20101110150057.GB14496@elte.hu>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 11 Nov 2010 07:39:44 +0100
Message-ID: <AANLkTi=cHYZMtDTTzCTCQqTyDLP9unyGOG5MW1AW055K@mail.gmail.com>
Subject: Re: sysfs: Add an 'events' class. (was: Re: [RFC][PATCH] perf: sysfs
 type id)
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 16:00, Ingo Molnar <mingo@elte.hu> wrote:
> * Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>> > Same here - calling events a 'bus' is like totally brain-dead IMHO. It implies
>> > something hardware, while many events are not related to any hardware component
>> > but are pure software abstractions: such as context-switches, or syscall
>> > entries, or VM events.
>>
>> Please use a bus, regardless of the name, class is dead and you will need stuff
>> tha can only happen at bus. We'll fix the name later.
>
> When is that 'later' supposed to happen? git annotate says that the
> renaming/unification comments/plans were added:
>
> 46336009        (Kay Sievers    2007-06-08 13:36:37 -0700       105)  symlinks pointing to the unified /sys/devices tree.
>
> ... about 3 and a half years ago.

If all works out as planned, we will do it during the next weeks.
Depends on a bit what Greg and I are dragged into, which is always
kind of unpredictable. It's 'just' a cleanup and stuff that's broken
always comes first, and comes a lot. :)

> Btw., where will thinks like /sys/kernel/slab/ end up? It would be useful (in the
> long run) to have:
>
>  /sys/kernel/slab/uid_cache/events/
>
> To describe/control events for the uid_cache SLAB cache alone.

It will probably stay as it is, they are not 'struct device' devices,
but raw kobjects. It's a completely unconnected custom tree, which is
not related to the driver core or anything similar.

It's more like its own filesystem. Stuff you put there can not show up
in /sys/class,bus,subsystem unless someone wants convert all of it to
real devices, let them show up in /sys/devices, and assign it a
subsystem (bus).

Kay
