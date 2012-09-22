Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab2IVSmK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 14:42:10 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:36192 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2IVSmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 14:42:09 -0400
Date: Sat, 22 Sep 2012 18:42:08 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>, fweisbec@gmail.com
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
In-Reply-To: <20120921195717.GD2454@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1209221836070.10663@utopia.booyaka.com>
References: <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com> <20120920000351.GI2455@linux.vnet.ibm.com> <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com> <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com> <20120920220130.GN2449@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com> <20120920232114.GO2449@linux.vnet.ibm.com> <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com> <20120921185827.GC2454@linux.vnet.ibm.com> <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com>
 <20120921195717.GD2454@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012, Paul E. McKenney wrote:

> Could you please point me to a recipe for creating a minimal userspace?
> Just in case it is the userspac erather than the architecture/hardware
> that makes the difference.

Tony's suggestion is pretty good.  Note that there may also be differences 
in kernel timers -- either between x86 and ARM architectures, or loaded 
device drivers -- that may confound the problem.

> Just to make sure I understand the combinations:
> 
> o	All stalls have happened when running a minimal userspace.
> o	CONFIG_NO_HZ=n suppresses the stalls.
> o	CONFIG_RCU_FAST_NO_HZ (which depends on CONFIG_NO_HZ=y) has
> 	no observable effect on the stalls.
> 
> Did I get that right, or am I missing a combination?

That's correct.

> Indeed, rcu_idle_gp_timer_func() is a bit strange in that it is 
> cancelled upon exit from idle, and therefore should (almost) never 
> actually execute. Its sole purpose is to wake up the CPU.  ;-)

Right.  Just curious, what would wake up the kernel from idle to handle a 
grace period expiration when CONFIG_RCU_FAST_NO_HZ=n?  On a very idle 
system, the time between timer ticks could potentially be several tens of 
seconds.


- Paul
