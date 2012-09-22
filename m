Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2IVW0C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 18:26:02 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:36401 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2IVW0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 18:26:00 -0400
Date: Sat, 22 Sep 2012 22:25:59 +0000 (UTC)
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
In-Reply-To: <20120922215923.GA13161@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1209222223080.22590@utopia.booyaka.com>
References: <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com> <20120920220130.GN2449@linux.vnet.ibm.com> <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com> <20120920232114.GO2449@linux.vnet.ibm.com> <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com>
 <20120921185827.GC2454@linux.vnet.ibm.com> <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com> <20120921195717.GD2454@linux.vnet.ibm.com> <alpine.DEB.2.00.1209221836070.10663@utopia.booyaka.com> <20120922201043.GE2934@linux.vnet.ibm.com>
 <20120922215923.GA13161@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2012, Paul E. McKenney wrote:

> And here is a patch.  I am still having trouble reproducing the problem,
> but figured that I should avoid serializing things.

Thanks, testing this now on v3.6-rc6.  One question though about the patch 
description:

> All this begs the question of exactly how a callback-free grace period
> gets started in the first place.  This can happen due to the fact that
> CPUs do not necessarily agree on which grace period is in progress.
> If a CPU still believes that the grace period that just completed is
> still ongoing, it will believe that it has callbacks that need to wait
> for another grace period, never mind the fact that the grace period
> that they were waiting for just completed.  This CPU can therefore
> erroneously decide to start a new grace period.

Doesn't this imply that this bug would only affect multi-CPU systems?  

The recent tests here have been on Pandaboard, which is dual-CPU, but my 
recollection is that I also observed the warnings on a single-core 
Beagleboard.  Will re-test.


- Paul
