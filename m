Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab2EUJIL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:08:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38289 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932291Ab2EUJIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:08:07 -0400
Date: Mon, 21 May 2012 02:07:42 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-b5e498ad67863cc877fb05e6a71ce58eda4fb2ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sam@ravnborg.org, lethal@linux-sh.org, tglx@linutronix.de,
        anna-maria@glx-um.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sam@ravnborg.org, tglx@linutronix.de, lethal@linux-sh.org,
        anna-maria@glx-um.de
In-Reply-To: <1337529587.3208.2.camel@dionysos>
References: <1337529587.3208.2.camel@dionysos>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] timers: Provide generic Kconfig switches
Git-Commit-ID: b5e498ad67863cc877fb05e6a71ce58eda4fb2ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:07:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5e498ad67863cc877fb05e6a71ce58eda4fb2ca
Gitweb:     http://git.kernel.org/tip/b5e498ad67863cc877fb05e6a71ce58eda4fb2ca
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 18 May 2012 09:59:57 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 21 May 2012 11:01:40 +0200

timers: Provide generic Kconfig switches

We really don't want all the arch code defining stuff
over and over.

[ anna-maria: Added missing GENERIC_CMOS_UPDATE switch ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Anna-Maria Gleixner <anna-maria@glx-um.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/1337529587.3208.2.camel@dionysos
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
 kernel/time/Kconfig |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index a20dc8a..f6ebc4f 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
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
