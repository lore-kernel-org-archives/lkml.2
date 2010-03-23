Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab0CWRG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 13:06:27 -0400
Received: from tac.ki.iif.hu ([193.6.222.43]:38292 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0CWRGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:06:25 -0400
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] hpet: Replace the dangerous EVT_TO_HPET_DEV macro with an inline function
Date: Tue, 23 Mar 2010 18:06:21 +0100
Message-ID: <87r5nb0xyq.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
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
index ee4fa1b..0e84d3c 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -27,8 +27,6 @@
 #define HPET_DEV_FSB_CAP		0x1000
 #define HPET_DEV_PERI_CAP		0x2000
 
-#define EVT_TO_HPET_DEV(evt) container_of(evt, struct hpet_dev, evt)
-
 /*
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
@@ -50,6 +48,11 @@ struct hpet_dev {
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
1.5.6.5

