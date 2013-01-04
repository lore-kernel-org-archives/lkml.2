Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3ADWrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 17:47:37 -0500
Received: from mail-la0-f74.google.com ([209.85.215.74]:35450 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3ADWre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 17:47:34 -0500
Subject: [PATCH] x86: Don't print extended CMOS year when reading RTC
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 04 Jan 2013 15:41:47 -0700
Message-ID: <20130104224146.15189.14874.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We shouldn't print the current century every time we read the RTC.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/kernel/rtc.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 801602b..2e8f3d3 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -149,7 +149,6 @@ unsigned long mach_get_cmos_time(void)
 	if (century) {
 		century = bcd2bin(century);
 		year += century * 100;
-		printk(KERN_INFO "Extended CMOS year: %d\n", century * 100);
 	} else
 		year += CMOS_YEARS_OFFS;
 

