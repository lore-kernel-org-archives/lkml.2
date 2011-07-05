Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab1GEIwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 04:52:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:39566 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1GEIv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 04:51:59 -0400
Subject: Re: [RFC] [PATCH] perf: Attaching an event to a specific PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20110704175927.GZ4590@erda.amd.com>
References: <20110703150430.GV4590@erda.amd.com>
	 <1309716271.3282.6.camel@twins>  <20110704175927.GZ4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 10:51:45 +0200
Message-ID: <1309855905.3282.42.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-04 at 19:59 +0200, Robert Richter wrote:

> First of all, it follows the idea of grouping events. Attaching events
> to a specific pmu is not different from attaching them to a specific
> event group. It is actually the same if we think of one group for
> events that may be scheduled on only one pmu. Thus, treating a pmu
> like a group event is the logical step for intuitive usage of the
> perf_open syscall. This way we have symmetrical implementations for
> binding events to groups or pmus.

That's not a good analogy. Grouping is about events being together, not
about events being on a particular pmu.

> Device nodes are the general approach for controlling devices from
> user-space, they are integral part of the Linux device driver model.
> With a device file descriptor opened from a device node we can
> explicitly point to a pmu device.

Yeah, but we already have a /sys interface, so this ship has sailed.

> Representing a device with a device node is common programming
> practice. Usage of device nodes is not deprecated. There are existing
> frameworks to easily create such devices. With dynamically device node
> allocation and udev there are solutions for drawbacks of /dev. Why not
> having a device node for pmus? What are your concerns using /dev?

Its impossible to represent events using that /dev interface,
furthermore we already have a /sys interface, so this is pure
duplication of a 

> The implementation only needs about 150 lines of kernel code. It is
> straight and separated. There is nothing special what makes it hard to
> read or maintain. The code is using typical kernel device allocation
> methods. Do you think this patch makes kernel code too complex?

It adds a redundant interface.

> Beside of that, using /sys/ is racy. There is no protection against
> unregistering the pmu. Probably this might not cause big problems in
> practice, but it can be done better. With open/close we can protect
> the pmu from being removed.

Why can't the open/close of the sysfs file provide the same? It just
means you have to close after sys_perf_event_open()

> Overall, my approach improves the perf design. It adds a better and
> more intuitve access to perf from user space with clear and common
> methods and interfaces. Please let me know the concerns you have.

Its redundant, this interface ship has sailed, its not going to happen.
