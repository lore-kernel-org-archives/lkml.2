Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab0KJOPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 09:15:07 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36610 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816Ab0KJOPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 09:15:03 -0500
MIME-Version: 1.0
In-Reply-To: <20101110133638.GC11388@elte.hu>
References: <1289339119.2191.92.camel@laptop> <20101109221338.GA19947@suse.de>
 <1289392037.2191.105.camel@laptop> <20101110133638.GC11388@elte.hu>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 10 Nov 2010 15:14:47 +0100
Message-ID: <AANLkTikkV1pdseitAPkXTyK529vsvbaVb-RMiMY4Ao-+@mail.gmail.com>
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

On Wed, Nov 10, 2010 at 14:36, Ingo Molnar <mingo@elte.hu> wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Tue, 2010-11-09 at 14:13 -0800, Greg KH wrote:
>>
>> > You missed the embedded track at Plumbers where we talked about never
>> > adding another class to the kernel.  Please use bus_id instead for this.
>>
>> I did, it was early and I wasn't aware this all comes under the heading
>> of embedded.
>>
>> Anyway, anybody got a good example of bus_type I can 'borrow' ?
>>
>> Also, it would be really nice if you (plural) could make this subsystem thing
>> happen, calling tihngs a bus that aren't a bus just makes me upset ;-)
>
> Same here - calling events a 'bus' is like totally brain-dead IMHO. It implies
> something hardware, while many events are not related to any hardware component but
> are pure software abstractions: such as context-switches, or syscall entries, or VM
> events.

Please use a bus, regardless of the name, class is dead and you will
need stuff tha can only happen at bus. We'll fix the name later.

> So i'd rather have 'events' or 'event_source' as a 'class' temporarily, than have it
> as a 'bus' temporarily - and we get the real fix whenever the sysfs unification
> happens.

Nope, that can not work.

> I also have a question about this future plan mentioned in
> Documentation/sysfs-rules.txt:
>
>  - Hierarchy in a single device tree
>   There is only one valid place in sysfs where hierarchy can be examined
>   and this is below: /sys/devices.
>   It is planned that all device directories will end up in the tree
>   below this directory.
>
> So did i get it right, sysfs is going to convert from a VFS hiearchy/enumeration to
> a flat enumeration of entities, all listed in /dev/devices/?

I guess you mean /sys. No, /sys/devices/ is and stays as a hierarchy
and will not be flat.

> Why is that done? I think it's quite nice that the actual topology is represented
> right now via the sysfs VFS structure - so that we have things like:
>
>   /sys/devices/system/ioapic/ioapic0/

That does not change at all.

> Where there's is a proper hierarchy showing that we have a 'system', which has an
> 'ioapic', which has an ioapic numbered '0'. That entity could then grow 'events' and
> have:
>
>   /sys/devices/system/ioapic/ioapic0/events/
>
> And could show various IO-APIC events, such as (future, possible events):
>
>   /sys/devices/system/ioapic/ioapic0/events/irq/
>   /sys/devices/system/ioapic/ioapic0/events/register-read/
>   /sys/devices/system/ioapic/ioapic0/events/register-write/
>   /sys/devices/system/ioapic/ioapic0/events/affinity/
>   [...]
>
> So is the plan to get rid of such rich hiearchies and just use a flat store of
> everything in /sys/devices/?

No. Where do you get that idea from?

> My hope would be to _increase_ the depth of sysfs in the future, to express every
> meaningful hiearchy that exists in the system (be that hw hierarchy or some sw
> abstraction hierarchy). But maybe i got it all wrong so please advise.

Yeah, seems all wrong. :)

/sys/device is the hierarchy (ans will stay as it is), /sys/class,bus
(later /sys/subsystem/) is the flat list of devices per subsystem (to
find all devices of a specific subsystem). The list _points_ to
devices in /sys/devices, it does never contain any devices. You might
want re-read the last mail in this thread, where I explained the
difference between hierarchy and classification in more details.

Kay
