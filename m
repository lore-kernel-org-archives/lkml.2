Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab2H2XyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 19:54:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:47706 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab2H2XyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 19:54:08 -0400
Date: Thu, 30 Aug 2012 00:53:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] ARM: smp: Fix cpu_up() racing with sys_reboot
Message-ID: <20120829235353.GW18957@n2100.arm.linux.org.uk>
References: <1345608229-5707-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345608229-5707-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 09:03:49PM -0700, Stephen Boyd wrote:
> Nothing stops a process from hotplugging in a CPU concurrently
> with a sys_reboot() call. In such a situation we could have
> ipi_cpu_stop() mark a cpu as 'offline' and _cpu_up() ignore the
> fact that the CPU is not really offline and call the
> CPU_UP_PREPARE notifier. When this happens stop_machine code will
> complain that the cpu thread already exists and BUG_ON().

This puts us at odds with x86, which is a bad thing without first
investigating whether a generic solution which fixes all arches would
be more appropriate.

A better solution may be to mark those CPUs as being not-present,
which will prevent them being hot-plugged back.
