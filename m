Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab0GIHl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:41:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53066 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0GIHl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:41:57 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>, Tony Lindgren <tony@atomide.com>,
       Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] OMAP2: powerdomain: Add break in switch statement
Date: Fri,  9 Jul 2010 09:40:53 +0200
Message-Id: <1278661253-22185-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:cT+6V19s3d9MQYJ/+ZFl32gpVjpZRZG979Ez/nhNxL9
 K7dGtINLPmOr3mUOFstwsI3XqC3m7mtA/hURDU2qctuOSTrnej
 slenchMpKfyGefUujyVbaYXLVXtxfhGIVO9vab7qoHbwutfAct
 J8muTQRkL7cO7bmVfZO6sQn8lPYtGhrKtpTDWDd4/MA9s81k0b
 g7MGrgXKEG3zR8MZSQTAw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing break at end of switch statement. At the moment it is a
fall through to WARN_ON(1) and return -EEXIST.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/powerdomain.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index a2904aa..6527ec3 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -875,6 +875,7 @@ int pwrdm_read_mem_retst(struct powerdomain *pwrdm, u8 bank)
 		break;
 	case 4:
 		m = OMAP_MEM4_RETSTATE_MASK;
+		break;
 	default:
 		WARN_ON(1); /* should never happen */
 		return -EEXIST;
-- 
1.7.1

