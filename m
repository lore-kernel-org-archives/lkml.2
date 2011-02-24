Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1BXH2b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 02:28:31 -0500
Received: from hera.kernel.org ([140.211.167.34]:35018 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752692Ab1BXH2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 02:28:30 -0500
Date: Thu, 24 Feb 2011 07:28:06 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, arjan@linux.intel.com, john.stultz@linaro.org,
        tglx@linutronix.de, jacob.jun.pan@linux.intel.com, mingo@elte.hu
Reply-To: john.stultz@linaro.org, mingo@redhat.com, hpa@zytor.com,
        alan@linux.intel.com, linux-kernel@vger.kernel.org,
        arjan@linux.intel.com, tglx@linutronix.de,
        jacob.jun.pan@linux.intel.com, mingo@elte.hu
In-Reply-To: <1298506046-439-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1298506046-439-1-git-send-email-jacob.jun.pan@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mrst: Fix apb timer rating when lapic timer is used
Message-ID: <tip-7b62dbec908a29f448047099bedb5c64c9cb8808@git.kernel.org>
Git-Commit-ID: 7b62dbec908a29f448047099bedb5c64c9cb8808
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 24 Feb 2011 07:28:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b62dbec908a29f448047099bedb5c64c9cb8808
Gitweb:     http://git.kernel.org/tip/7b62dbec908a29f448047099bedb5c64c9cb8808
Author:     Jacob Pan <jacob.jun.pan@linux.intel.com>
AuthorDate: Wed, 23 Feb 2011 16:07:26 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 24 Feb 2011 08:22:43 +0100

x86/mrst: Fix apb timer rating when lapic timer is used

Need to adjust the clockevent device rating for the structure
that will be registered with clockevent system instead of the
temporary structure.

Without this fix, APB timer rating will be higher than LAPIC
timer such that it can not be released later to be used as the
broadcast timer.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
LKML-Reference: <1298506046-439-1-git-send-email-jacob.jun.pan@linux.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apb_timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 51ef31a..51d4e16 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -284,7 +284,7 @@ static int __init apbt_clockevent_register(void)
 	memcpy(&adev->evt, &apbt_clockevent, sizeof(struct clock_event_device));
 
 	if (mrst_timer_options == MRST_TIMER_LAPIC_APBT) {
-		apbt_clockevent.rating = APBT_CLOCKEVENT_RATING - 100;
+		adev->evt.rating = APBT_CLOCKEVENT_RATING - 100;
 		global_clock_event = &adev->evt;
 		printk(KERN_DEBUG "%s clockevent registered as global\n",
 		       global_clock_event->name);
