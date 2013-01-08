Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab3AHE1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 23:27:54 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36399 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3AHE1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 23:27:52 -0500
X-IronPort-AV: E=Sophos;i="4.84,428,1355126400"; 
   d="scan'208";a="18367372"
Date: Mon, 7 Jan 2013 20:27:50 -0800
From: Srivatsa Vaddagiri <vatsa@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
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
Message-ID: <20130108042750.GA18214@quicinc.com>
Reply-To: Srivatsa Vaddagiri <vatsa@codeaurora.org>
References: <1357268318-7993-1-git-send-email-vatsa@codeaurora.org>
 <20130105103627.GU2631@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130105103627.GU2631@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux <linux@arm.linux.org.uk> [2013-01-05 10:36:27]:

> On Thu, Jan 03, 2013 at 06:58:38PM -0800, Srivatsa Vaddagiri wrote:
> > I also think that the
> > wait_for_completion() based wait in ARM's __cpu_die() can be replaced with a
> > busy-loop based one, as the wait there in general should be terminated within
> > few cycles.
> 
> Why open-code this stuff when we have infrastructure already in the kernel
> for waiting for stuff to happen?  I chose to use the standard infrastructure
> because its better tested, and avoids having to think about whether we need
> CPU barriers and such like to ensure that updates are seen in a timely
> manner.

I was primarily thinking of calling as few generic functions as possible on
a dead cpu. I recall several "am I running on a dead cpu?" checks
(cpu_is_offline(this_cpu) that were put in generic routines during early
versions of cpu hotplug [1] to educate code running on dead cpu, the need for
which went away though with introduction of atomic/stop-machine variant. The
need to add a RCU_NONIDLE() wrapper around ARM's cpu_die() [2] is perhaps a more
recent example of educating code running on dead cpu. As quickly we die as
possible after idle thread of dying cpu gains control, the better!

1. http://lwn.net/Articles/69040/
2. http://lists.infradead.org/pipermail/linux-arm-kernel/2012-July/107971.html

- vatsa
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
