Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283Ab2JWQzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 12:55:53 -0400
Received: from rs130.luxsci.com ([72.32.115.17]:48992 "EHLO rs130.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932939Ab2JWQzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 12:55:51 -0400
Message-ID: <5086CC02.6070801@firmworks.com>
Date: Tue, 23 Oct 2012 06:55:30 -1000
From: Mitch Bradley <wmb@firmworks.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Jon Hunter <jon-hunter@ti.com>
CC: Sebastien Guiriec <s-guiriec@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/4] ARM: dts: omap5: Update GPIO with address space
 and interrupts
References: <1350981432-6750-1-git-send-email-s-guiriec@ti.com> <1350981432-6750-2-git-send-email-s-guiriec@ti.com> <5086AE8E.60106@ti.com>
In-Reply-To: <5086AE8E.60106@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Lux-Comment: Message q9NGtVOQ027466 sent by user #11875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 4:49 AM, Jon Hunter wrote:

> Therefore, I believe it will improve search time and hence, boot time if
> we have interrupt-parent defined in each node.

I strongly suspect (based on many years of performance tuning, with
special focus on boot time) that the time difference will be completely
insignificant.  The total extra time for walking up the interrupt tree
for every interrupt in a large system is comparable to the time it takes
to send a few characters out a UART.  So you can get more improvement
from eliminating a single printk() than from globally adding per-node
interrupt-parent.

Furthermore, the cost of processing all of the interrupt-parent
properties is probably similar to the cost of the avoided tree walks.

CPU cycles are very fast compared to I/O register accesses, say a factor
of 100.  Now consider that many modern devices contain embedded
microcontrollers (SD cards, network interface modules, USB hubs and
devices, ...), and those devices usually require various delays measured
in milliseconds, to ensure that the microcontroller is ready for the
next initialization step.  Those delays are extremely long compared to
CPU cycles.  Obviously, some of that can be overlapped by careful
multithreading, but that isn't free either.

The bottom line is that I'm pretty sure that adding per-node
interrupt-parent would not be worthwhile from the standpoint of speeding
up boot time.
