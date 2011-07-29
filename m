Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab1G2P6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 11:58:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:62613 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752108Ab1G2P6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 11:58:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,287,1309762800"; 
   d="scan'208";a="2363019"
Message-ID: <4E32D86B.70301@linux.intel.com>
Date: Fri, 29 Jul 2011 08:57:31 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [ANNOUNCE] 3.0-rt6 (kgdb working)
References: <alpine.LFD.2.02.1107282213000.31246@ionos>
In-Reply-To: <alpine.LFD.2.02.1107282213000.31246@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/28/2011 02:43 PM, Thomas Gleixner wrote:
> Dear RT Folks,
> 
> I'm pleased to announce the 3.0-rt6 release.
> 
> Changes versus 3.0-rt4 (I pushed out a rt5 w/o announce)
> 
>   * pin_cpu fix (Yong Zhang)
> 
>   * Various compile fixes (Yong Zhang & myself)
> 
>   * Serial fix for omap
> 
>   * Clocksource lockless watchdog reset
> 
>   * Reenabled CONFIG_RCU_BOOST (problem is unreproducible and maybe
>     related to NO_HZ, which is still disabled. Paul is working on it!)
> 
>   * KGDB work^Whackaround (Jason Wessel)
> 
>     The kgdb workaround is really a hack and wants to be replaced by a
>     proper overhaul for the console/tty maze.
>     See: kgb-serial-hackaround.patch

I just confirmed that this resolves the issue I was seeing while trying
to single step through futex_requeue() on a 2 socket E5680.

Thanks Thomas and Jason,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
