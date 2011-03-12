Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab1CLWuy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 17:50:54 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40480 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162Ab1CLWuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 17:50:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:from:subject:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=G6KbAZxcKlgikdFdGZuuPIT8l7mgW1lk7cd6IcUcMMQsS+rPbdhyWuZzy0Z+EuZ3wS
         eK4BtdMbB1phDcjKSrporcO9F5Qx/7x+R5xxbfvoQkMQtzkD1L8aDFNfcaNze7tNXgr/
         1diQDHniILWpMAYF1oxww+VcH/doRpqP3/5Lc=
From: Andy Green <andy@warmcat.com>
Subject: [RFC PATCH 2/5] OMAP2+: add cpu id register to MAC address helper
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, Andy Green <andy.green@linaro.org>
Date: Sat, 12 Mar 2011 22:50:47 +0000
Message-ID: <20110312225047.27728.1835.stgit@otae.warmcat.com>
In-Reply-To: <20110312224440.27728.60593.stgit@otae.warmcat.com>
References: <20110312224440.27728.60593.stgit@otae.warmcat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a generic helper function that can set a MAC address using
data from the OMAP unqiue CPU ID register.

Signed-off-by: Andy Green <andy.green@linaro.org>
---

 arch/arm/mach-omap2/id.c              |   13 +++++++++++++
 arch/arm/mach-omap2/include/mach/id.h |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 5f9086c..fc69ec5 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -506,3 +506,16 @@ void __init omap2_set_globals_tap(struct omap_globals *omap2_globals)
 	else
 		tap_prod_id = 0x0208;
 }
+
+
+void omap2_die_id_to_mac(u8 *mac, int length)
+{
+	struct omap_die_id odi;
+
+	omap_get_die_id(&odi);
+	memcpy(mac, &odi.id_0, length);
+
+	/* mark it as not multicast and outside official 80211 MAC namespace */
+
+	mac[0] = (mac[0] & ~1) | 2;
+}
diff --git a/arch/arm/mach-omap2/include/mach/id.h b/arch/arm/mach-omap2/include/mach/id.h
index 02ed3aa..72e10eb 100644
--- a/arch/arm/mach-omap2/include/mach/id.h
+++ b/arch/arm/mach-omap2/include/mach/id.h
@@ -18,5 +18,6 @@ struct omap_die_id {
 };
 
 void omap_get_die_id(struct omap_die_id *odi);
+void omap2_die_id_to_mac(u8 *mac, int length);
 
 #endif

