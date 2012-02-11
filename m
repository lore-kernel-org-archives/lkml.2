Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2BKWqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 17:46:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56358 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753592Ab2BKWqR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 17:46:17 -0500
Message-ID: <1329000377.325.49.camel@deadeye>
Subject: [PATCH 1/5] x86/cpu: Fix overrun check in arch_print_cpu_modalias()
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Sat, 11 Feb 2012 22:46:17 +0000
In-Reply-To: <1329000256.325.48.camel@deadeye>
References: <1329000256.325.48.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snprintf() does not return a negative value when truncating.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/match.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 940e2d4..2dfa52b 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -67,7 +67,7 @@ ssize_t arch_print_cpu_modalias(struct device *dev,
 	for (i = 0; i < NCAPINTS*32; i++) {
 		if (boot_cpu_has(i)) {
 			n = snprintf(buf, size, ",%04X", i);
-			if (n < 0) {
+			if (n >= size) {
 				WARN(1, "x86 features overflow page\n");
 				break;
 			}
-- 
1.7.9



