Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab1GXUzh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 16:55:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:33612 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751849Ab1GXUzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 16:55:36 -0400
Date: Sun, 24 Jul 2011 20:55:22 GMT
From: tip-bot for Daniel Drake <dsd@laptop.org>
Message-ID: <tip-07d5b38e14b7ff98eb52e4a6db4e20abcc608da3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dsd@laptop.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dsd@laptop.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110724173430.BE03C9D401C@zog.reactivated.net>
References: <20110724173430.BE03C9D401C@zog.reactivated.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/olpc] x86, olpc-xo15-sci: Enable EC wakeup capability
Git-Commit-ID: 07d5b38e14b7ff98eb52e4a6db4e20abcc608da3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 24 Jul 2011 20:55:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  07d5b38e14b7ff98eb52e4a6db4e20abcc608da3
Gitweb:     http://git.kernel.org/tip/07d5b38e14b7ff98eb52e4a6db4e20abcc608da3
Author:     Daniel Drake <dsd@laptop.org>
AuthorDate: Sun, 24 Jul 2011 18:34:30 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 24 Jul 2011 20:16:05 +0200

x86, olpc-xo15-sci: Enable EC wakeup capability

Some recent changes to the way that ACPI handles wakeup flags
means that the XO15EC ACPI device is not wakeup-capable by
default so device_set_wakeup_enable() does nothing.

Use device_init_wakeup() to mark the device as wakeup capable,
and to enable wakeups.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Link: http://lkml.kernel.org/r/20110724173430.BE03C9D401C@zog.reactivated.net
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/olpc/olpc-xo15-sci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/olpc/olpc-xo15-sci.c b/arch/x86/platform/olpc/olpc-xo15-sci.c
index a5990eb..2b235b7 100644
--- a/arch/x86/platform/olpc/olpc-xo15-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo15-sci.c
@@ -120,7 +120,7 @@ static int xo15_sci_add(struct acpi_device *device)
 
 	/* Enable wake-on-EC */
 	if (device->wakeup.flags.valid)
-		device_set_wakeup_enable(&device->dev, true);
+		device_init_wakeup(&device->dev, true);
 
 	return 0;
 }
