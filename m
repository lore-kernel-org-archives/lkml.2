Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab1KRO2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:28:45 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:36876 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902Ab1KRO2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:28:44 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: "Venkatesh Pallipadi \(Venki\)" <venki@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND] [PATCH] Replace the dangerous EVT_TO_HPET_DEV macro with an inline function
References: <083ba7e7209fbaeec09b5e0e94c575f969042da5.1294326889.git.wferi@niif.hu>
Message-Id: <8ed5c66c02041226e8cf8b4d5d6b41e543d90bd6.1321626272.git.wferi@niif.hu>
Date: Fri, 18 Nov 2011 15:28:22 +0100
In-Reply-To: <083ba7e7209fbaeec09b5e0e94c575f969042da5.1294326889.git.wferi@niif.hu>
	(Ferenc Wagner's message of "Thu, 6 Jan 2011 16:22:55 +0100")
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The original macro worked only when applied to variables named 'evt'.
While this could have been fixed by simply renaming the macro argument,
a more type-safe replacement is preferred.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
---
 arch/x86/kernel/hpet.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index b946a9e..52aae9a 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -32,8 +32,6 @@
 #define HPET_MIN_CYCLES			128
 #define HPET_MIN_PROG_DELTA		(HPET_MIN_CYCLES + (HPET_MIN_CYCLES >> 1))
 
-#define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
-
 /*
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
@@ -55,6 +53,11 @@ struct hpet_dev {
 	char				name[10];
 };
 
+inline struct hpet_dev *EVT_TO_HPET_DEV(struct clock_event_device *evtdev)
+{
+	return container_of(evtdev, struct hpet_dev, evt);
+}
+
 inline unsigned int hpet_readl(unsigned int a)
 {
 	return readl(hpet_virt_address + a);
-- 
1.6.5

