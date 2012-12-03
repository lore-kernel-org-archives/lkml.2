Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2LCOzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 09:55:43 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43605 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932126Ab2LCOfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:35:52 -0500
Message-Id: <20121203143200.281795375@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 03 Dec 2012 14:33:14 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Len Brown <len.brown@intel.com>
Subject: [ 88/89] intel_idle: initial IVB support
In-Reply-To: <20121203143146.549859007@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

commit 6edab08c24f9141d69cfa4683a0a027d86ab303e upstream.

>From an OS point of view, IVB looks like SNB, but quicker.

Signed-off-by: Len Brown <len.brown@intel.com>
[bwh: Backported to 3.2: add model number to the switch in
 intel_idle_probe(), as there is no device ID table]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/idle/intel_idle.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -163,6 +163,38 @@ static struct cpuidle_state snb_cstates[
 		.enter = &intel_idle },
 };
 
+static struct cpuidle_state ivb_cstates[MWAIT_MAX_NUM_CSTATES] = {
+	{ /* MWAIT C0 */ },
+	{ /* MWAIT C1 */
+		.name = "C1-IVB",
+		.desc = "MWAIT 0x00",
+		.flags = CPUIDLE_FLAG_TIME_VALID,
+		.exit_latency = 1,
+		.target_residency = 1,
+		.enter = &intel_idle },
+	{ /* MWAIT C2 */
+		.name = "C3-IVB",
+		.desc = "MWAIT 0x10",
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 59,
+		.target_residency = 156,
+		.enter = &intel_idle },
+	{ /* MWAIT C3 */
+		.name = "C6-IVB",
+		.desc = "MWAIT 0x20",
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 80,
+		.target_residency = 300,
+		.enter = &intel_idle },
+	{ /* MWAIT C4 */
+		.name = "C7-IVB",
+		.desc = "MWAIT 0x30",
+		.flags = CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.exit_latency = 87,
+		.target_residency = 300,
+		.enter = &intel_idle },
+};
+
 static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
 	{ /* MWAIT C0 */ },
 	{ /* MWAIT C1 */
@@ -386,6 +418,10 @@ static int intel_idle_probe(void)
 		cpuidle_state_table = snb_cstates;
 		break;
 
+	case 0x3A:	/* IVB */
+		cpuidle_state_table = ivb_cstates;
+		break;
+
 	default:
 		pr_debug(PREFIX "does not run on family %d model %d\n",
 			boot_cpu_data.x86, boot_cpu_data.x86_model);


