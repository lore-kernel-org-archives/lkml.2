Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2DVVCF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 17:02:05 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:48292 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab2DVVCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 17:02:03 -0400
Message-ID: <4F9471B9.5050007@tilera.com>
Date: Sun, 22 Apr 2012 23:01:45 +0200
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: linux-arch
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [patch 00/18] SMP: Boot and CPU hotplug refactoring - Part 1
References: <20120420122120.097464672@linutronix.de>
In-Reply-To: <20120420122120.097464672@linutronix.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-20 at 13:05 +0000, Thomas Gleixner wrote:
> [...]
> This first part moves the idle thread management for non-boot cpus
> into the core. fork_idle() is called in a workqueue as it is
> implemented in a few architectures already. This is necessary when not
> all cpus are brought up by the early boot code as otherwise we would
> take a ref on the user task VM of the thread which brings the cpu up
> via the sysfs interface.
> 
> This converts all architectures except m32r, mn10300, tile and UM to
> the new core facility. These architecture are calling fork_idle() in
> the very early boot code in smp_prepare_cpus() for unknown reasons.
> I haven't analyzed yet, whether this is on purpose or can be moved
> over to the generic facility. It'd be nice if the responsible maintainers
> could look into that as well.

I will take a look at this for the tile architecture later this week; I'm
out on vacation until Wednesday.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

--
To unsubscribe from this list: send the line "unsubscribe linux-arch" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

