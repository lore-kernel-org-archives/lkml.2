Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab1BXFhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 00:37:25 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:33608 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab1BXFhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 00:37:23 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.44
X-Originating-IP: 173.50.155.44
Message-ID: <4D65EE74.1050709@pbjtriplett.org>
Date: Wed, 23 Feb 2011 21:36:52 -0800
From: Burt Triplett <burt@pbjtriplett.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101226 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, x86@kernel.org, discuss@lesswatts.org
Subject: [announce] Intel BIOS Implementation Test Suite (BITS)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel is pleased to announce the BIOS Implementation Test Suite (BITS),
a bootable pre-OS environment for testing BIOSes and in particular their
initialization of Intel processors, hardware, and technologies. BITS can
verify your BIOS against many Intel recommendations. In addition, BITS
includes Intel's official reference code as provided to BIOS, which you
can use to override your BIOS's hardware initialization with a
known-good configuration, and then boot an OS.

BITS functionality fits in three broad categories:

- Testing: run test suites to check how the BIOS configured your
   platform hardware.
- Configuration: override the BIOS hardware configuration using a
   known-good configuration, such as by running Intel reference code
- Exploration: experimental tools and information gathering

BITS consists of a modified GRUB2 bootloader, with many additional
commands to probe and manipulate hardware configuration, as well as
scripts using these commands to test and reconfigure hardware.  GRUB2
already provided a very capable pre-OS runtime environment, including
many features commonly found in standard libraries, as well as a
scripting language, command line, and menu system; thanks to the GRUB2
developers for the great platform to build on.

To support the functionality we needed in BITS, we added:

- Support for initializing and running code on all CPUs in an SMP
   system.

- Many new commands for manipulating hardware resources such as
   model-specific registers (MSRs), CPUID, PCI and PCI Express devices,
   and memory addresses; in all cases these operations occur from a
   designated CPU, allowing access to CPU-specific resources and
   asymmetrically mapped system resources.

- Many new commands supporting the hardware configuration and BIOS
   test-suite infrastructure, including a full C expression evaluator for
   integer values (so you don't have to resort to implementing more
   commands in C just to shift, mask, and otherwise twiddle bits).

In addition to those changes to GRUB2 itself, BITS includes
configuration files which build a menu exposing the various BITS
functionality, including the test suites, hardware configuration, and
exploratory tools.  These scripts detect your system's CPU, and provide
menu entries for all the available functionality on your hardware
platform.  You can also access all of the new commands we've added
directly via the command line.

The current version of BITS focuses primarily on CPU configuration and
power management. It includes extensive support for Intel® processors
based on the microarchitecture code name Nehalem and newer, which
includes Intel Core i7, i5, and i3 desktop and mobile processors, and
corresponding Intel Xeon server processors.

Some examples of what you can currently do with BITS:

- Detect if your BIOS properly configures processor power management.

- Run Intel's power management reference code to override your BIOS's
   configuration.  This includes writing the ACPI tables for P-states and
   C-states, replacing those normally provided by your BIOS.  In
   particular, you can even turn off power management in your BIOS
   entirely, use BITS to initialize it, and then chainload Linux and run
   powertop to see full P-state and C-state support via cpufreq and
   cpuidle.

- Detect the frequency and duration of BIOS System Management
   Interrupts.  This tool shows the average duration of SMIs (grouped by
   orders of magnitude), the time between a few SMIs in each group, and
   the worst-case latency observed.

- Check how long a CPU core and the entire processor package spend in
   C-states (sleep states), by directly checking the CPU's residency
   counters (when available on your platform).  You can compare this
   C-state residency measured in a pre-OS environment to what you observe
   under Linux, to help attribute unexpectedly low C-state residency
   between Linux background tasks or configuration and BIOS
   configuration.

For more examples of using BITS, see the screenshots page at
<http://biosbits.org/screenshots/>.

Many pieces of functionality implemented in BITS demonstrate the use of
newly disclosed and documented hardware information, now provided in the
Intel 64 and IA-32 Architectures Software Developer's Manuals (SDM).

You can get BITS from the BITS homepage at <http://biosbits.org/>.  We
appreciate any feedback you might have on BITS, including questions,
comments, bug reports, feature requests, or patches.  In particular, the
BITS infrastructure makes it possible to implement a wide variety of
tests via simple text configuration files, and perform experimentation
directly on the GRUB command line; give it a try and let us know what
you think!
