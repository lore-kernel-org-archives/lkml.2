Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1FTJvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 05:51:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35400 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1FTJvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 05:51:08 -0400
Date: Mon, 20 Jun 2011 10:50:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
Message-ID: <20110620095053.GA2082@n2100.arm.linux.org.uk>
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 02:53:59PM +0530, Santosh Shilimkar wrote:
> The current ARM CPU hotplug code suffers from couple of race conditions
> in CPU online path with scheduler.
> The ARM CPU hotplug code doesn't wait for hot-plugged CPU to be marked
> active as part of cpu_notify() by the CPU which brought it up before
> enabling interrupts.

Hmm, why not just move the set_cpu_online() call before notify_cpu_starting()
and add the wait after the set_cpu_online() ?
