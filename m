Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689Ab1BILln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 06:41:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48461 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752071Ab1BILlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 06:41:42 -0500
Date: Wed, 9 Feb 2011 11:41:38 +0000
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
Message-ID: <20110209114137.GA10163@opensource.wolfsonmicro.com>
References: <4D51D341.3040209@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D51D341.3040209@am.sony.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 08, 2011 at 03:35:29PM -0800, Frank Rowand wrote:

> For 2.6.38-rc4, x86_64, CONFIG_NR_CPUS=4:

> size vmlinux
>    text     data       bss       dec      hex  filename
> 
> 6553910  3555020   9994240  20103170  132c002  vmlinux    with    CONFIG_PM
> 6512652  3553116   9994240  20060008  1321768  vmlinux    without CONFIG_PM
> 
>   41258     1904         0     43162                      delta

> That is big enough for me to care.

Hrm, that's pretty surprising.  It'd be interesting to know how much of
that is due to the PM core itself and how much of that is from drivers.
For the drivers CONFIG_PM isn't really the option they should be using
in the first place - they mostly want some combination of PM_SLEEP and
PM_RUNTIME for the specific functionality.  I'm running some checks now.

>  > CONFIG_PM_SLEEP=y

Raphael's patch will make this a user visible option in place of raw
CONFIG_PM by default so you'd be able to turn that off.
