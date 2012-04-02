Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2DBORk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:17:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:25552 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab2DBORk convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 2 Apr 2012 10:17:40 -0400
Message-Id: <4F79D120020000780007C031@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 02 Apr 2012 15:17:36 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: allow multiple values to be specified with
 "hpet="
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is particularly to be able to specify "hpet=force,verbose", as
"force" ought to be a primary candidate for also wanting to use
"verbose".

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/kernel/hpet.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- 3.4-rc1-x86-hpet.orig/arch/x86/kernel/hpet.c
+++ 3.4-rc1-x86-hpet/arch/x86/kernel/hpet.c
@@ -94,13 +94,18 @@ static int hpet_verbose;
 
 static int __init hpet_setup(char *str)
 {
-	if (str) {
+	while (str) {
+		char *next = strchr(str, ',');
+
+		if (next)
+			*next++ = 0;
 		if (!strncmp("disable", str, 7))
 			boot_hpet_disable = 1;
 		if (!strncmp("force", str, 5))
 			hpet_force_user = 1;
 		if (!strncmp("verbose", str, 7))
 			hpet_verbose = 1;
+		str = next;
 	}
 	return 1;
 }



