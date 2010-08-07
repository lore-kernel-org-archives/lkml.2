Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab0HGRRd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 13:17:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62284 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514Ab0HGRRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 13:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=suU4sV9206BBbUGsTItwpKsotPo3exjM8we5TgmGivtQ7leh9lnrA2MGIOEEyB33qW
         rDCEw4i39fB68s+eowSTtuUaDs6J8jrCV3EAWvihARx9AyCkx2g6xO9PeedANGThCzeH
         /SqYqhWTTTVdLljZopxcgVaapUl9g5AnVtNPo=
From: Namhyung Kim <namhyung@gmail.com>
To: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: add missing __percpu markup in arch/x86/kernel/acpi/cstate.c
Date: Sun,  8 Aug 2010 02:17:29 +0900
Message-Id: <1281201449-31158-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpu_cstate_entry is a percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/kernel/acpi/cstate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index fb7a5f0..fb16f17 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -61,7 +61,7 @@ struct cstate_entry {
 		unsigned int ecx;
 	} states[ACPI_PROCESSOR_MAX_POWER];
 };
-static struct cstate_entry *cpu_cstate_entry;	/* per CPU ptr */
+static struct cstate_entry __percpu *cpu_cstate_entry;	/* per CPU ptr */
 
 static short mwait_supported[ACPI_PROCESSOR_MAX_POWER];
 
-- 
1.7.0.4

