Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab2J1XfP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:35:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42149 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756927Ab2J1X2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:12 -0400
Message-Id: <20121028231551.244992820@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:22 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Robert Richter <robert.richter@amd.com>
Subject: [ 046/105] oprofile, x86: Fix wrapping bug in op_x86_get_ctrl()
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 44009105081b51417f311f4c3be0061870b6b8ed upstream.

The "event" variable is a u16 so the shift will always wrap to zero
making the line a no-op.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/oprofile/nmi_int.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 26b8a85..48768df 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -55,7 +55,7 @@ u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 	val |= counter_config->extra;
 	event &= model->event_mask ? model->event_mask : 0xFF;
 	val |= event & 0xFF;
-	val |= (event & 0x0F00) << 24;
+	val |= (u64)(event & 0x0F00) << 24;
 
 	return val;
 }


