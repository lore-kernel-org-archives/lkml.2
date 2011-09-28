Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab1I1Wjn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:39:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755723Ab1I1Wjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:39:41 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:31 2011
Message-Id: <20110928220131.156117221@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Troy Kisky <troy.kisky@boundarydevices.com>,
        =?ISO-8859-15?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        John Ogness <john.ogness@linutronix.de>
Subject: [056/244] MXC: iomux-v3: correct NO_PAD_CTRL definition
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Troy Kisky <troy.kisky@boundarydevices.com>

commit 425933b30b0ccfac58065bca6c853ea627443cdf upstream.

iomux-v3.c uses NO_PAD_CTRL as a 32 bit value
so it should not be shifted left by MUX_PAD_CTRL_SHIFT(41)

Previously, anything requesting NO_PAD_CTRL would get
their pad control register set to 0.

Since it is a pad control mask, place it with the other mask values.

Signed-off-by: Troy Kisky <troy.kisky@boundarydevices.com>
Acked-by: Lothar Waßmann <LW@KARO-electronics.de>
Tested-by: Lothar Waßmann <LW@KARO-electronics.de>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: John Ogness <john.ogness@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/plat-mxc/include/mach/iomux-v3.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/plat-mxc/include/mach/iomux-v3.h
+++ b/arch/arm/plat-mxc/include/mach/iomux-v3.h
@@ -66,7 +66,6 @@ typedef u64 iomux_v3_cfg_t;
 #define MUX_MODE_MASK		((iomux_v3_cfg_t)0x1f << MUX_MODE_SHIFT)
 #define MUX_PAD_CTRL_SHIFT	41
 #define MUX_PAD_CTRL_MASK	((iomux_v3_cfg_t)0x1ffff << MUX_PAD_CTRL_SHIFT)
-#define NO_PAD_CTRL		((iomux_v3_cfg_t)1 << (MUX_PAD_CTRL_SHIFT + 16))
 #define MUX_SEL_INPUT_SHIFT	58
 #define MUX_SEL_INPUT_MASK	((iomux_v3_cfg_t)0xf << MUX_SEL_INPUT_SHIFT)
 
@@ -85,6 +84,7 @@ typedef u64 iomux_v3_cfg_t;
  * Use to set PAD control
  */
 
+#define NO_PAD_CTRL			(1 << 16)
 #define PAD_CTL_DVS			(1 << 13)
 #define PAD_CTL_HYS			(1 << 8)
 


