Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2BKWzN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 17:55:13 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56457 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752389Ab2BKWzK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 17:55:10 -0500
Message-ID: <1329000910.325.55.camel@deadeye>
Subject: [PATCH 4/5] intel_idle: Revert change of auto_demotion_flags for
 Nehalem
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org
Date: Sat, 11 Feb 2012 22:55:10 +0000
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

Commit b66b8b9a4a79087dde1b358a016e5c8739ccf186 ('intel-idle: convert
to x86_cpu_id auto probing') added a distinction between Nehalem and
Westemere processors and changed auto_demotion_flags for the former to
0.  This was not explained in the commit message, so change it back.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
I have very little idea what I'm doing here...

Ben.

 drivers/idle/intel_idle.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index a238649..1c15e9b 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -331,10 +331,6 @@ static void auto_demotion_disable(void *dummy)
 
 static const struct idle_cpu idle_cpu_nehalem = {
 	.state_table = nehalem_cstates,
-};
-
-static const struct idle_cpu idle_cpu_westmere = {
-	.state_table = nehalem_cstates,
 	.auto_demotion_disable_flags = NHM_C1_AUTO_DEMOTE | NHM_C3_AUTO_DEMOTE,
 };
 
@@ -358,12 +354,12 @@ static const struct x86_cpu_id intel_idle_ids[] = {
 	ICPU(0x1a, idle_cpu_nehalem),
 	ICPU(0x1e, idle_cpu_nehalem),
 	ICPU(0x1f, idle_cpu_nehalem),
-	ICPU(0x25, idle_cpu_westmere),
-	ICPU(0x2c, idle_cpu_westmere),
-	ICPU(0x2e, idle_cpu_westmere),
+	ICPU(0x25, idle_cpu_nehalem),
+	ICPU(0x2c, idle_cpu_nehalem),
+	ICPU(0x2e, idle_cpu_nehalem),
 	ICPU(0x1c, idle_cpu_atom),
 	ICPU(0x26, idle_cpu_lincroft),
-	ICPU(0x2f, idle_cpu_westmere),
+	ICPU(0x2f, idle_cpu_nehalem),
 	ICPU(0x2a, idle_cpu_snb),
 	ICPU(0x2d, idle_cpu_snb),
 	{}
-- 
1.7.9



