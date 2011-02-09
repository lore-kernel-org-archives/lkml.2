Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab1BIL6T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:58:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33240 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751663Ab1BIL6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:58:17 -0500
Date: Wed, 9 Feb 2011 11:58:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Frank Rowand <frank.rowand@am.sony.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Remove CONFIG_PM altogether, enable power management
 all the time
Message-ID: <20110209115837.GA12333@opensource.wolfsonmicro.com>
References: <4D51D341.3040209@am.sony.com>
 <20110209114137.GA10163@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110209114137.GA10163@opensource.wolfsonmicro.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 11:41:37AM +0000, Mark Brown wrote:

> Hrm, that's pretty surprising.  It'd be interesting to know how much of
> that is due to the PM core itself and how much of that is from drivers.
> For the drivers CONFIG_PM isn't really the option they should be using
> in the first place - they mostly want some combination of PM_SLEEP and
> PM_RUNTIME for the specific functionality.  I'm running some checks now.

OK, on ARM with slightly more than an allnoconfig (allnoconfig itself
wouldn't build) I see:

   text	   data	    bss	    dec	    hex	filename
1361476	  71360	 167320	1600156	 186a9c	vmlinux.nopm
1364228	  71520	 167480	1603228	 18769c	vmlinux

   2752     160     160    3072

so 3K from CONFIG_PM there, mostly from the ARM VIC management code
which I suspect really wants to be under one of the more specific PM
options, though obviously this comes back to the issue with bitrotted
ifdefs for PM whcih pervades the kernel.
