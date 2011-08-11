Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab1HKUDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:03:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:38920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753516Ab1HKUC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:02:59 -0400
Subject: Re: [PATCH v3 1/2] cpumask: introduce cpumask for hotpluggable CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Turquette <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, gregkh@suse.de,
        amit.kucheria@linaro.org
Date: Thu, 11 Aug 2011 22:02:37 +0200
In-Reply-To: <1313092487-15858-1-git-send-email-mturquette@ti.com>
References: <1313006614-28702-1-git-send-email-mturquette@ti.com>
	 <1313092487-15858-1-git-send-email-mturquette@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313092957.26866.7.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 12:54 -0700, Mike Turquette wrote:
> On some platforms it is possible to have some CPUs which support CPU
> hotplug and some which do not.  Currently the prescence of an 'online'
> sysfs entry in userspace is adequate for applications to know that a CPU
> supports hotplug, but there is no convenient way to make the same
> determination in the kernel.
> 
> To better model this relationship this patch introduces a new cpumask to
> track CPUs that support CPU hotplug operations.
> 
> This new cpumask is populated at boot-time and remains static for the
> life of the machine.  Bits set in the mask indicate a CPU which supports
> hotplug, but make no guarantees about whether that CPU is currently
> online or not.  Likewise a cleared bit in the mask indicates either a
> CPU which cannot hotplug or a lack of a populated CPU.
> 
> The purpose of this new cpumask is to aid kernel code which uses CPU to
> take CPUs online and offline.  Possible uses are as a thermal event
> mitigation technique or as a power capping mechanism. 

Nacked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

the kernel really shouldn't be using hotplug for this (nor should
userspace really). hot-unplugging random cpus wrecks things like
cpusets. Furthermore hotplug does way too much work to use as a simple
means to idle a cpu.

Even the availability of this mask is wrong, since that implies the
information is useful, which per the above it is not, the kernel
shouldn't care about this full-stop.

The only reason for the OS to unplug a CPU is imminent and unavoidable
hardware failure. Thermal capping is not that (and yes ACPI-4.0 is a
broken piece of shit).


