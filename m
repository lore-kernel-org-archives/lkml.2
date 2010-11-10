Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab0KJNhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 08:37:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45184 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768Ab0KJNhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 08:37:12 -0500
Date: Wed, 10 Nov 2010 14:36:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: sysfs: Add an 'events' class. (was: Re: [RFC][PATCH] perf: sysfs
 type id)
Message-ID: <20101110133638.GC11388@elte.hu>
References: <1289339119.2191.92.camel@laptop>
 <20101109221338.GA19947@suse.de>
 <1289392037.2191.105.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289392037.2191.105.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2010-11-09 at 14:13 -0800, Greg KH wrote:
> 
> > You missed the embedded track at Plumbers where we talked about never
> > adding another class to the kernel.  Please use bus_id instead for this.
> 
> I did, it was early and I wasn't aware this all comes under the heading
> of embedded.
> 
> Anyway, anybody got a good example of bus_type I can 'borrow' ?
> 
> Also, it would be really nice if you (plural) could make this subsystem thing 
> happen, calling tihngs a bus that aren't a bus just makes me upset ;-)

Same here - calling events a 'bus' is like totally brain-dead IMHO. It implies 
something hardware, while many events are not related to any hardware component but 
are pure software abstractions: such as context-switches, or syscall entries, or VM 
events.

So i'd rather have 'events' or 'event_source' as a 'class' temporarily, than have it 
as a 'bus' temporarily - and we get the real fix whenever the sysfs unification 
happens.

I also have a question about this future plan mentioned in 
Documentation/sysfs-rules.txt:

 - Hierarchy in a single device tree
   There is only one valid place in sysfs where hierarchy can be examined
   and this is below: /sys/devices.
   It is planned that all device directories will end up in the tree
   below this directory.

So did i get it right, sysfs is going to convert from a VFS hiearchy/enumeration to 
a flat enumeration of entities, all listed in /dev/devices/?

Why is that done? I think it's quite nice that the actual topology is represented 
right now via the sysfs VFS structure - so that we have things like:

   /sys/devices/system/ioapic/ioapic0/

Where there's is a proper hierarchy showing that we have a 'system', which has an 
'ioapic', which has an ioapic numbered '0'. That entity could then grow 'events' and 
have:

   /sys/devices/system/ioapic/ioapic0/events/

And could show various IO-APIC events, such as (future, possible events):

   /sys/devices/system/ioapic/ioapic0/events/irq/
   /sys/devices/system/ioapic/ioapic0/events/register-read/
   /sys/devices/system/ioapic/ioapic0/events/register-write/
   /sys/devices/system/ioapic/ioapic0/events/affinity/
   [...]

So is the plan to get rid of such rich hiearchies and just use a flat store of 
everything in /sys/devices/?

My hope would be to _increase_ the depth of sysfs in the future, to express every 
meaningful hiearchy that exists in the system (be that hw hierarchy or some sw 
abstraction hierarchy). But maybe i got it all wrong so please advise.

Thanks,

	Ingo
