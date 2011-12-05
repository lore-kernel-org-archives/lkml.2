Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab1LERhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:37:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab1LERhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:37:07 -0500
Date: Mon, 5 Dec 2011 09:36:40 -0800
From: tip-bot for Ferenc Wagner <wferi@niif.hu>
Message-ID: <tip-3f7787b36cf2d99f3dbc8a0be85b92a5530a9a76@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, wferi@niif.hu, mingo@elte.hu, venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, wferi@niif.hu, venki@google.com, mingo@elte.hu
In-Reply-To: <8ed5c66c02041226e8cf8b4d5d6b41e543d90bd6.1321626272.git.wferi@niif.hu>
References: <8ed5c66c02041226e8cf8b4d5d6b41e543d90bd6.1321626272.git.wferi@niif.hu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cleanups] x86: Replace the EVT_TO_HPET_DEV() macro with an inline function
Git-Commit-ID: 3f7787b36cf2d99f3dbc8a0be85b92a5530a9a76
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:36:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f7787b36cf2d99f3dbc8a0be85b92a5530a9a76
Gitweb:     http://git.kernel.org/tip/3f7787b36cf2d99f3dbc8a0be85b92a5530a9a76
Author:     Ferenc Wagner <wferi@niif.hu>
AuthorDate: Fri, 18 Nov 2011 15:28:22 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 13:53:36 +0100

x86: Replace the EVT_TO_HPET_DEV() macro with an inline function

The original macro worked only when applied to variables named
'evt'. While this could have been fixed by simply renaming the
macro argument, a more type-safe replacement is preferred.

Signed-off-by: Ferenc Wagner <wferi@niif.hu>
Cc: Venkatesh Pallipadi \(Venki\) <venki@google.com>
Link: http://lkml.kernel.org/r/8ed5c66c02041226e8cf8b4d5d6b41e543d90bd6.1321626272.git.wferi@niif.hu
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
