Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab0HOFgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:36:52 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:36095 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab0HOFgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:36:51 -0400
Date: Sun, 15 Aug 2010 01:36:33 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linux Power Management List <linux-pm@lists.osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Notes from the Boston Linux Power Management Mini-summit - August 9th,
 2010
Message-id: <alpine.LFD.2.00.1008150134180.7641@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-976987972-1281850594=:7641"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-976987972-1281850594=:7641
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

A Linux Power Management "mini-summit" was held on August 9th, 2010 -
preceding the Linux Foundation's Linuxcon-Boston.

Attendees:

Len Brown - Intel
Matthew Garrett - Red Hat
Alan Stern - Harvard
Igor Stoppa - Nokia
Tuukka Tikkanen - Nokia
Paul Walmsley - PWSAN
Rafael Wysocki - U. Warsaw, Novell/SuSE Labs

Thank you to the Linux Foundation for generously providing the facilities.

The attendees are pictured at the start of Len's Linuxcon-Boston photo gallery:
http://picasaweb.google.com/lenb417/2010LinuxconBoston

We repeated the process used in 2009: http://lwn.net/Articles/345007/
where attendance was open to the community and the agenda formed by attendees.

Topics:
------
PM Year-in-Review
Suspend Performance
Linux Idle Power Checkup
Nokia Goals and Requirements
Android Suspend Blockers
Opportunistic system suspend vs Deep idle
PM-runtime IO device suspend
MRST/MDF
PM_QOS needs (another) re-write?
Linux PM SW Architecture
cgroups
Server Power Management

PM changes since Montreal mini-summit (July 2009)
-------------------------------------------------
Rafael presented a retrospective: 

I/O Runtime PM Framework
2009-08-22 – First patch merged (core-level code).
2009-12-06 – Core-level improvements & fixes.
2010-02-23 – PCI bus type support.
2010-02-26 – User space support via sysfs (power/control).
2010-03-02 – USB bus type support (Alan).
2010-03-06 – Core & PCI fixes & improvements.
2010-03-17 – Driver support for e1000e & r8169.
2010-05-10 – I2 C bus type support.
2010-05-18 – Documentation update.
2010-05-20 – USB bus type support fixes & improvements (Alan).
2010-07-19 – power/runtime_status, powertop support.
2010-07-28 – SCSI bus type support (Alan).

Rafael's I/O Runtime PM Framework Linuxcon presentation:
http://events.linuxfoundation.org/slides/2010/linuxcon2010_wysocki.pdf

Other PM-Related Development
2009-09-09 – PCI wakeup enable propagation & fixes.
2009-09-14 – Hibernate memory shrinking rework.
		w/ help from mm guys
2009-12-18 – Device suspend/resume time measurement code.
2010-01-04 – PCI per-device D3 delays.
2010-02-26 – Asynchronous suspend/resume of devices.
2010-03-06 – GFP_NOIO during suspend & hibernation.
2010-03-06 – Generic subsystem-level PM callbacks.
2010-05-06 – Major PM QoS update (by Mark Gross).
2010-06-17 – ACPI GPEs handling rework.
2010-07-12 – ACPI GPEs handling rework continued.
	as a result of run-time PM update
2010-07-19 – Wakeup events framework.
2010-07-19 – PM QoS rework with plists (by James Bottomley).
		can use from atomic context
		resulted from android discussion
All the time – Fixes & improvements (all over the place).

Rafael also provided a history of the suspend blocker upstreaming effort.

Suspend Performance
-------------------
intcall_debug displays suspend/resume device performance

Asynchronous suspend/resume of devices (currently PCI, SCSI, USB)
reduces resume time by half on (Rafael's) laptop,
though this result is very system dependent.

Graphics and rotating hard drives are the slowest part.
Intel graphics have been seen to take 1000 ms.
rotating disk drives can take 2000 ms to spin-up/down.

resume is slower than suspend
eg. On SSD+i915 box: suspend = 300ms, resume = 1000ms

Linux Idle Checkup
------------------
Len previewed his Linuxcon presentation:
http://events.linuxfoundation.org/slides/2010/linuxcon2010_brown.pdf

Linux is competitive on desktops, but trails windows and mac on notebooks.
The largest reason Linux trails is that (as shipped) Linux does
not invoke suspend automatically while the competition does.

Len needs to take a closer look at the Core2 laptop results,
which ran on a dual Intel/NVIDIA graphics box.
He also needs to take a closer look at the Arrandale results,
which includes Intel's latest processor and graphics.

Len's next check-up will include Meego and netbooks.

Nokia Goals and Requirements
----------------------------
In response to the confusion surrounding Android's requirements,
Igor proposed goals and requirements for Nokia

Nokia Goals:
------------
Easy development of pm-friendly apps (different from pm-aware)
	most simple apps are backlight-on only anyway

	powertop is good to show 1 problem,
	but not when there is a mess -- can't see causes.

	need to partition system to get good feedback.

	middleware needs to have some feedback
	on how well it is used.  (eg. coalesce
	timers for 3G aggregation)

Easy identification of problematic apps
	(those that do not conform to the desired behavior
	on a certain platform/configuration)

	eg. don't connect to ntk when it is off

	eg. 3G vs WiFi
	3G: race to halt, WiFi maybe not.

	eg. check e-mail
	resumes from idle state and does ntk query
	with out a S3 resume which turns on everything...

	Clear API for rendering and handling
	foreground/background of application.

	aggregate policy in power profile
	rather than have every application with settings.

Prevent problematic apps form compromising system power and performance
	both when idle and when executing trusted apps

	eg. bouncing cow screen-saver

	network is off for airplane mode
		application asks for network but can't get it,
			repeatedly turns on screen to tell you:-(

Preserve power and performance behavior over time (system should not age)
	even after installing random apps
	with different level of power friendliness

Nokia implementation requirements:
----------------------------------
Keep separate policies and mechanisms
	to ensure cross platform portability of high level policies

	eg: high level constraint: screen on -> strict latency requirement
	for painting the UI upon user interaction

	eg. switch between camera and video mode quickly (user is waiting)

Low level constraint: enforce minimum frequency OR lower power state

	former is portable, latter is not

Avoid introducing platform-specific knowledge / dependency on applications
	eg. knowledge about "suspend"

	eg. video encoder wants to talk in its own language,
	not in a system-specific concept such as S3.

We discussed and concluded that although some applications
need to be notified about power management events
(suspend, hibernation, resume), that notification should be
carried out entirely in user space.

We noted that the Meego approach assumes certain level of quality control
of applications landing in the app store, including their
"power management friendliness"

Android Suspend Blockers
------------------------
A large part of the day's discussion centered around the recent
Android suspend-blockers proposal.

Matthew Garrett held session on the topic at Linuxcon:
http://events.linuxfoundation.org/slides/2010/linuxcon2010_garrett.pdf

As a group, we attempted to extract requirements associated
with the suspend blocker implementation, and reviewed how those
requirements are satisfied in the suspend-blocker and
dynamic-idle approaches.

Technical requirements: 

1. Enter low power state without losing wakeup events in the kernel code

   a. If subsystem passes an event to a thread that's about to be frozen,
      the event must be able to prevent the freeze.

     - Dynamic idle doesn't have freeze-tasks -- so it doesn't
	have this problem -- the application is free to run.

     - Full system suspend needs help to do this

       - One approach is to add suspend blocks to drivers,
         subsystems, possibly kernel threads to indicate that
         there is an event to be delivered

       - Another approach is to solve this problem via the 
         recently-merged PM wakeup code, which aborts suspend in progress
	 and prevents another suspend for a period

       - Might try_to_wake_up() events solve the problem also?

   b. If a driver or subsystem has events pending, the
      driver/sub-system's suspend() function must return an error
      (and block suspend).

      - Dynamic idle: problem does not apply

      - Full system suspend: suspend() functions need to be patched to
        test if they have work pending and return an error
	(blocking suspend) 

2. How do we know when to put the system into low power state?

   a. Prevent power-unprivileged applications from keeping the
      system in a high-power state

     - Full system suspend/dynamic idle:

       - Solution: Create a power manager program that runs in user-space
         that makes the decision when to enter suspend (or to stop
         processes) based on user input

   b. Prevent power-unprivileged kernel code from keeping the
      system in a high-power state

     - Solution: fix the kernel code

3. How do we tell which drivers and programs are preventing the
   system from entering a low power state?

     - Solution: add structure to collect wakeup event statistics

          Wakeup events:
          - what wakes up a suspended system?
          - what prevents a system from entering suspend?


Opportunistic system suspend vs Deep idle
------------------------------------------
All "wake-lock" discussions end up debating the merits
of 'opportunistic suspend' vs 'dynamic idle', 
so we held multiple discussions throughout the conference
on the differences between deep idle states and system suspend.

Android's fundamental assumption is that suspend is the normal state
ie. when number of suspend blockers is zero, then suspend the system.
Rafael: Android chose system suspend over dynamic idle
	because they could save more power that way.

System suspend forces all user processes to suspend,
(even any "run-away" apps)
while idle waits for them to stop running.
Android depends upon system suspend to freeze
ill-behaved applications.

One proposal was to have suspend freeze user-space,
and have "deep/dynamic idle" enter system suspend

System suspend/resume disables/enables devices,
while idle tends to leave them alone.

System suspend usually has explicit wakeup
from a wakeup device, such as a lid, button,
magic packet or a timer.  Idle is awoken by
any interrupt from any device and it may be
able to wake and go back to sleep without
needing to wake many devices.

System suspend's resume can be heavy-weight.
On x86 we resume in 16-bit real mode.
A PC BIOS may also invoke SMM on suspend/resume.

PM-runtime IO device suspend
----------------------------
Traditionally, .suspend...
	just save/restore state
	firmware would shut off power

Now with run-time power management
we need to know how to shut off power

PM-runtime hooks may be specific to platform, or generic

MRST/MDF
--------
We reviewed Jacob Pan's MRST slides from ELC 2010:
http://elinux.org/images/e/ee/Jacob-Pan-x86MID-elc2010.pdf

PM_QOS
------
The PM QoS constraints generally apply on a per-device basis,
rather than a global basis, so it makes sense to define and store
many of them at the struct device level;

Some PM QoS constraints are applicable to almost every device
(e.g., device wakeup latency), but some PM QoS constraints are only
applicable to particular subsystems, e.g., touchscreen accuracy (example
courtesy of Mark Brown at LPC 2009).  For those, the subsystem
core/driver code should be responsible for converting a functional
constraint to something that makes sense for the underlying hardware.

So the interfaces to set PM QoS constraints must change.

For example, from the user-space interface perspective,
these should probably be set during kernel syscalls/ioctl()s
or sysfs files at the subsystem & device levels,
rather than individual global files in /dev.

Linux PM SW Architecture Discussion
-----------------------------------
Does it make sense to continue to maintain
	scheduler
	cpufreq
	cpuidle
	pm-runtime
	pm qos

	all w/o talking much to each other?

A gap:

On OMAP, bus control is independent of CPU frequency control,
so cpufreq and cpuidle don't quite fit the bill.

Perhaps a "bus-idle" analogous to "cpu-idle" may be appropriate?

cpuidle "c-states" properties may depend at run-time
upon frequency and upon other device clocks.

So perhaps more broadly...

<device>idle, for any struct device that has a meaningful
wakeup latency vs. power consumption trade-off.  Same story for frequency
drivers, e.g., <device>freq, for any struct device that has a meaningful
clock rate vs. power consumption trade-off (usually only devices that are
on variable voltage rails).

Idle definition and detection depends on the device
The bleeding edge is graphics controller power management
where currently	all is done inside driver.

*idle
	device topology
	bottom up power management

To the extent we can let subsystems, devices,
and "architectures" define their own approaches
to constraints and power saving code, everyone wins.

A top-down approach that may not work well for some subsystems,
devices, "architectures."

PM runtime is a good example of a bottom-up power management approach, 
since the action to take to put the device into a low power state is 
configurable on a per-device/per-bus/per-"architecture" basis.

cgroups
-------
classify applications so that some run together.
give different QOS to some applications

But can't replace video player b/c only the original was in cgroup
ie. currently the N900 cgroups policy is based on specific processes,
so that if they are replaced with different ones (i.e.
different media player), the replacements do not enjoy the same
treatment that the stock apps get.

mjg: dynamic idle is fine if you allow all process to run
	rather than ignoring some in a cgroup
	limiting run-time to cgroups can be problematic

Paul doubts this is a problem, for a similar problem exists
with suspend blockers, it's just that all processes stop,
rather than just the priority-inverted ones.  (Tuukka pointed this out.)
Suspend blockers solve it by hacking their apps to add user-space
wake-locks to keep the system alive; a similar method would be possible
in a selective-idle cgroup system to move the apps causing the deadlock
out of the selective-idle cgroup.  Basically, it's a user-space problem
rather than a kernel problem.

Server Power Management
-----------------------
Matthew announced that he's now spending more time on servers,
do to their importance to Red Hat's business.

Len and Matthew discussed issues seen on large Intel servers --
particularly when running RHEL5, which ticks at 1000 HZ on all processors.
80 threads * 1000 HZ = 80,000 timer ticks/sec in idle;
which burdens RHEL5 with a "measurable" power penalty.

Len showed where the power goes in a server using
a "pie chart" from his Server PM presentation
from the 2009 Linux Foundation End User Summit:
http://userweb.kernel.org/~lenb/doc/2009-EUS-Server-PM-web/mgp00007.html
He explained how that pie chart is now out of date,
but that memory continues to be a growing issue on servers.

Matthew and Len discussed the prospects for memory PM on Linux.
One approach is to track memory via NUMA nodes
and to seek opportunities to allow entire nodes to go idle.
Ideally, hardware would recognize idleness and automatically
enter power saving retention states -- automatically waking
upon access.  However, the ultimate power savings mechanism
will always be non-retention states, where the hardware
requires OS memory hot-plug to enter and exit off states.
--8323328-976987972-1281850594=:7641--
