Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066Ab1AKM27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:28:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:47441 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab1AKM26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:28:58 -0500
Date: Tue, 11 Jan 2011 12:28:34 GMT
From: tip-bot for Alek Du <alek.du@intel.com>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, alek.du@intel.com, jacob.jun.pan@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, alek.du@intel.com,
        jacob.jun.pan@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110111105439.24448.69863.stgit@bob.linux.org.uk>
References: <20110111105439.24448.69863.stgit@bob.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/gpio: Implement x86 gpio_to_irq convert function
Message-ID: <tip-718c45bd1aa80c4e23a0ee204c973e3014e94708@git.kernel.org>
Git-Commit-ID: 718c45bd1aa80c4e23a0ee204c973e3014e94708
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 Jan 2011 12:28:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  718c45bd1aa80c4e23a0ee204c973e3014e94708
Gitweb:     http://git.kernel.org/tip/718c45bd1aa80c4e23a0ee204c973e3014e94708
Author:     Alek Du <alek.du@intel.com>
AuthorDate: Tue, 11 Jan 2011 10:55:32 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 Jan 2011 12:46:15 +0100

x86/gpio: Implement x86 gpio_to_irq convert function

We need this for x86 MID platforms where GPIO interrupts are
used. No special magic is needed so the default 1:1 behaviour
will do nicely.

Signed-off-by: Alek Du <alek.du@intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
LKML-Reference: <20110111105439.24448.69863.stgit@bob.linux.org.uk>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/gpio.h |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/gpio.h b/arch/x86/include/asm/gpio.h
index 49dbfdf..91d915a 100644
--- a/arch/x86/include/asm/gpio.h
+++ b/arch/x86/include/asm/gpio.h
@@ -38,12 +38,9 @@ static inline int gpio_cansleep(unsigned int gpio)
 	return __gpio_cansleep(gpio);
 }
 
-/*
- * Not implemented, yet.
- */
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return -ENOSYS;
+	return __gpio_to_irq(gpio);
 }
 
 static inline int irq_to_gpio(unsigned int irq)
