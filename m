Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3AEKoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 05:44:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40527 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3AEKoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 05:44:20 -0500
Date: Sat, 5 Jan 2013 10:36:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Srivatsa Vaddagiri <vatsa@codeaurora.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-s390@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, mhocko@suse.cz, srivatsa.bhat@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/2] cpuhotplug/nohz: Remove offline cpus from
	nohz-idle state
Message-ID: <20130105103627.GU2631@n2100.arm.linux.org.uk>
References: <1357268318-7993-1-git-send-email-vatsa@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357268318-7993-1-git-send-email-vatsa@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 06:58:38PM -0800, Srivatsa Vaddagiri wrote:
> I also think that the
> wait_for_completion() based wait in ARM's __cpu_die() can be replaced with a
> busy-loop based one, as the wait there in general should be terminated within
> few cycles.

Why open-code this stuff when we have infrastructure already in the kernel
for waiting for stuff to happen?  I chose to use the standard infrastructure
because its better tested, and avoids having to think about whether we need
CPU barriers and such like to ensure that updates are seen in a timely
manner.

My stance on a lot of this idle/cpu dying code is that much of it can
probably be cleaned up and merged into a single common implementation -
in which case the use of standard infrastructure for things like waiting
for other CPUs do stuff is even more justified.
