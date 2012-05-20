Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283Ab2ETP7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 11:59:53 -0400
Received: from www.tglx.de ([62.245.132.106]:60257 "EHLO Tesla.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab2ETP7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 11:59:52 -0400
Subject: Re: [patch 01/24] timers: Provide generic Kconfig switches
From: Anna-Maria Gleixner <anna-maria@glx-um.de>
To: Paul Mundt <lethal@linux-sh.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20120518231432.GH24355@linux-sh.org>
References: <20120518163020.548627576@glx-um.de>
	 <20120518163104.499615021@glx-um.de>  <20120518231432.GH24355@linux-sh.org>
Content-Type: text/plain; charset="us-ascii"
Date: Sun, 20 May 2012 17:59:47 +0200
Message-ID: <1337529587.3208.2.camel@dionysos>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
X-TGLX-Spam-Score: -1.0
X-TGLX-Spam-Level: -
X-TGLX-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-05-19 at 08:14 +0900, Paul Mundt wrote:
> On Fri, May 18, 2012 at 04:45:43PM -0000, Anna-Maria Gleixner wrote:
> > +# Clockevents broadcasting infrastructure
> > +config GENERIC_CLOCKEVENTS_BROADCAST
> > +	bool
> > +	depends on GENERIC_CLOCKEVENTS
> > 
> Looks like you've missed GENERIC_CMOS_UPDATE.

Looks like the author of the patch missed it. Find an updated version
below.

Thanks,

	Anna-Maria
------------>
Subject: timers: Provide generic Kconfig switches
From: Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 18 May 2012 09:59:57 +0200

From: Thomas Gleixner <tglx@linutronix.de>

We really don't want all the arch code defining stuff
over and over.

[ anna-maria: Added missing GENERIC_CMOS_UPDATE switch ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
---
 kernel/time/Kconfig |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: linux/kernel/time/Kconfig
===================================================================
--- linux.orig/kernel/time/Kconfig
+++ linux/kernel/time/Kconfig
@@ -33,3 +33,38 @@ config GENERIC_CLOCKEVENTS_BUILD
 
 config GENERIC_CLOCKEVENTS_MIN_ADJUST
 	bool
+
+# Options selectable by arch Kconfig
+
+# Watchdog function for clocksources to detect instabilities
+config CLOCKSOURCE_WATCHDOG
+	bool
+
+# Architecture has extra clocksource data
+config ARCH_CLOCKSOURCE_DATA
+	bool
+
+# Timekeeping vsyscall support
+config GENERIC_TIME_VSYSCALL
+	bool
+
+# ktime_t scalar 64bit nsec representation
+config KTIME_SCALAR
+	bool
+
+# Old style timekeeping
+config ARCH_USES_GETTIMEOFFSET
+	bool
+
+# The generic clock events infrastructure
+config GENERIC_CLOCKEVENTS
+	bool
+
+# Clockevents broadcasting infrastructure
+config GENERIC_CLOCKEVENTS_BROADCAST
+	bool
+	depends on GENERIC_CLOCKEVENTS
+
+# Generic update of CMOS clock
+config GENERIC_CMOS_UPDATE
+	bool


