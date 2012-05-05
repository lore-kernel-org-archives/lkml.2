Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab2EESpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 14:45:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab2EESpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 14:45:35 -0400
Date: Sat, 5 May 2012 11:45:10 -0700
From: tip-bot for Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Message-ID: <tip-d1d0589a565a2528a044cfd680141c3e2db18d0a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        akpm@linux-foundation.org, philipp@redfish-solutions.com,
        gurligebis@gentoo.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, gurligebis@gentoo.org,
        philipp@redfish-solutions.com, tglx@linutronix.de
In-Reply-To: <20120504210146.62186A018B@akpm.mtv.corp.google.com>
References: <20120504210146.62186A018B@akpm.mtv.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] arch/x86/platform/geode/net5501.c:
  change active_low to 0 for LED driver
Git-Commit-ID: d1d0589a565a2528a044cfd680141c3e2db18d0a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 05 May 2012 11:45:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1d0589a565a2528a044cfd680141c3e2db18d0a
Gitweb:     http://git.kernel.org/tip/d1d0589a565a2528a044cfd680141c3e2db18d0a
Author:     Bjarke Istrup Pedersen <gurligebis@gentoo.org>
AuthorDate: Fri, 4 May 2012 14:01:45 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 4 May 2012 14:40:07 -0700

arch/x86/platform/geode/net5501.c: change active_low to 0 for LED driver

It seems that there was an error with the active_low = 1 for the
LED, since it should be set to 0 (meaning that active is high,
since 0 is false, hence the confusion.

The wiki article about it confuses it, since it contradicts itself,
regarding what turns on the LED.

I have tested 3.4-rc2 on my net5501 with this patch, and it makes the LED
behave correctly, where "none" turns it off, and "default-on" turns it on,
when echoed onto the trigger "file" in /sys/class/leds.

Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Link: http://lkml.kernel.org/r/20120504210146.62186A018B@akpm.mtv.corp.google.com
Cc: Philip Prindeville <philipp@redfish-solutions.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/platform/geode/net5501.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/geode/net5501.c b/arch/x86/platform/geode/net5501.c
index 66d377e..646e3b5 100644
--- a/arch/x86/platform/geode/net5501.c
+++ b/arch/x86/platform/geode/net5501.c
@@ -63,7 +63,7 @@ static struct gpio_led net5501_leds[] = {
 		.name = "net5501:1",
 		.gpio = 6,
 		.default_trigger = "default-on",
-		.active_low = 1,
+		.active_low = 0,
 	},
 };
 
