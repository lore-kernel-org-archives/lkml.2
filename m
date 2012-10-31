Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934236Ab2J3S7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:59:35 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:40573 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965649Ab2J3S73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:59:29 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [RFC 7/7] capebus: Documentation; capebus-summary
Date: Wed, 31 Oct 2012 18:52:13 +0200
Message-Id: <1351702333-8456-8-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1351702333-8456-1-git-send-email-panto@antoniou-consulting.com>
References: <1351702333-8456-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small summary of capebus.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 Documentation/capebus/capebus-summary | 40 +++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/capebus/capebus-summary

diff --git a/Documentation/capebus/capebus-summary b/Documentation/capebus/capebus-summary
new file mode 100644
index 0000000..742e33c
--- /dev/null
+++ b/Documentation/capebus/capebus-summary
@@ -0,0 +1,40 @@
+Overview of Linux kernel Capebus support
+========================================
+
+30-Oct-2012
+
+What is Capebus?
+----------------
+Capebus is an abstract concept. There's no such thing as a vanilla physical
+capebus, what is there is a concept and a method on how various capebus
+based implementations can be made.
+
+Capebus is created to address the problem of many SoCs that can provide a
+multitude of hardware interfaces but in order to keep costs down the main
+boards only support a limited number of them. The rest are typically brought
+out to pin connectors on to which other boards, named capes are connected and
+allow those peripherals to be used.
+
+These capes connect to the SoC interfaces but might also contain various other
+parts that may need some kind of driver to work.
+
+Since SoCs have limited pins and pin muxing options, not all capes can work
+together so some kind of resource tracking (at least for the pins in use) is
+required.
+
+Before capebus all of this took place in the board support file, and frankly
+for boards with too many capes it was becoming unmanageable.
+
+Capebus provides a virtual bus, which along with a board specific controller,
+cape drivers can be written using the standard Linux device model.
+
+What kind of systems/boards capebus supports?
+---------------------------------------------
+
+The core capebus infrastructure is not depended on any specific board.
+However capebus needs a board controller to provide services to the cape devices
+it controls. Services like addressing and resource reservation are provided
+by the board controller.
+
+Capebus at the moment only support TI's Beaglebone platform.
+
-- 
1.7.12

