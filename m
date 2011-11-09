Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936040Ab1KJEO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:14:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44445 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965283Ab1KJDmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:42:45 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:57 2011
Message-Id: <20111109213156.970808931@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:33:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [147/264] ARM: pxa/cm-x300: properly set bt_reset pin
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 1a64200ec5e93be03e27c3b2fc332e04ae443eb2 upstream.

Fix below build warning and properly set bt_reset pin.

  CC      arch/arm/mach-pxa/cm-x300.o
arch/arm/mach-pxa/cm-x300.c: In function 'cm_x300_init_wi2wi':
arch/arm/mach-pxa/cm-x300.c:779: warning: unused variable 'wlan_en'
arch/arm/mach-pxa/cm-x300.c:795: warning: 'bt_reset' may be used uninitialized in this function

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Igor Grinberg <grinberg@compulab.co.il>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/mach-pxa/cm-x300.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/arm/mach-pxa/cm-x300.c
+++ b/arch/arm/mach-pxa/cm-x300.c
@@ -775,7 +775,6 @@ static struct gpio cm_x300_wi2wi_gpios[]
 
 static void __init cm_x300_init_wi2wi(void)
 {
-	int bt_reset, wlan_en;
 	int err;
 
 	if (system_rev < 130) {
@@ -791,12 +790,11 @@ static void __init cm_x300_init_wi2wi(vo
 	}
 
 	udelay(10);
-	gpio_set_value(bt_reset, 0);
+	gpio_set_value(cm_x300_wi2wi_gpios[1].gpio, 0);
 	udelay(10);
-	gpio_set_value(bt_reset, 1);
+	gpio_set_value(cm_x300_wi2wi_gpios[1].gpio, 1);
 
-	gpio_free(wlan_en);
-	gpio_free(bt_reset);
+	gpio_free_array(ARRAY_AND_SIZE(cm_x300_wi2wi_gpios));
 }
 
 /* MFP */


