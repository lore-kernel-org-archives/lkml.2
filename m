Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab2IVWUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 18:20:23 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:36377 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab2IVWUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 18:20:20 -0400
Date: Sat, 22 Sep 2012 22:20:19 +0000 (UTC)
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
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
In-Reply-To: <20120922195253.GD2934@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1209222214120.22590@utopia.booyaka.com>
References: <20120920000351.GI2455@linux.vnet.ibm.com> <alpine.DEB.2.00.1209200753450.3801@utopia.booyaka.com> <F95344A7-3351-4E6B-BF61-37E591AF16A2@ti.com> <20120920220130.GN2449@linux.vnet.ibm.com> <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com>
 <alpine.DEB.2.00.1209211740170.8839@utopia.booyaka.com> <20120921212054.GE2454@linux.vnet.ibm.com> <alpine.DEB.2.00.1209212240190.31812@utopia.booyaka.com> <20120922000537.GH2454@linux.vnet.ibm.com> <alpine.DEB.2.00.1209221813330.10663@utopia.booyaka.com>
 <20120922195253.GD2934@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul

On Sat, 22 Sep 2012, Paul E. McKenney wrote:

> Strangely enough, I believe that I have inadvertently fixed this in
> my -rcu tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/next
> 
> Nevertheless, if you get a chance to try it, I would be interested to
> hear if my guess is correct.

Yes, good news: the stall warnings go away with that branch.

> The trick is that a kthread drives the grace period in -rcu, regardless 
> of whether or not there are callbacks.

This is "rcu: Move quiescent-state forcing into kthread" ?

Added some debugging into rcu_gp_kthread() after that commit and can 
confirm that the quiescent-state forcing loop does start a few times when 
there are zero callbacks pending (modulo any races in my measurement 
code).

> However, the backport would not be something that -stable would be happy
> with, so I will be putting together a fix for mainline.  This thing
> has been in the kernel since about 2004, not sure why you didn't hit
> it earlier.

One other data point in that regard - noticed the warnings don't appear 
when the board is booted with:

commit 4fa3b6cb1bc8c14b81b4c8ffdfd3f2500a7e9367
Author: Paul E. McKenney <paul.mckenney@linaro.org>
Date:   Tue Jun 5 15:53:53 2012 -0700

    rcu: Fix qlen_lazy breakage

...


- Paul
