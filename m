Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab2IUSJC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 14:09:02 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:34542 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2IUSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 14:09:00 -0400
Date: Fri, 21 Sep 2012 18:08:59 +0000 (UTC)
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
In-Reply-To: <20120920232114.GO2449@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
References: <alpine.DEB.2.00.1209122237080.7275@utopia.booyaka.com> <20120913011208.GT4257@linux.vnet.ibm.com> <alpine.DEB.2.00.1209131839000.23318@utopia.booyaka.com> <20120920000351.GI2455@linux.vnet.ibm.com> <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com>
 <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com> <20120920220130.GN2449@linux.vnet.ibm.com> <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com> <20120920232114.GO2449@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc Frederic Weisbecker - context is here: 

   http://marc.info/?l=linux-kernel&m=134749030206016&w=2

On Thu, 20 Sep 2012, Paul E. McKenney wrote:

> Fair point.  I am wondering whether there is some path into the idle
> loop that somehow avoids telling RCU that the CPU has in face entered
> idle.  There needs to be an rcu_idle_enter() call on the way to idle,
> otherwise RCU CPU stall warnings are expected behavior.

As far as I know, our only idle entry point is in 
arch/arm/common/process.c:cpu_idle().

Looking at the x86 idle entry, they call rcu_idle_{enter,exit}() inside 
{stop,start}_critical_timings().  Making that change here didn't help.

Also tried commenting out the code from the stop_critical_timings() call 
to the WARN_ON(irqs_disabled()), and adding a local_irq_enable().  That 
also didn't help, which suggests that the problem is not caused by the 
OMAP-specific PM idle code.


- Paul
