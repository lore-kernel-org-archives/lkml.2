Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3AGSvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 13:51:39 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:58364 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755104Ab3AGSvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 13:51:36 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jon Loeliger <jdl@jdl.com>, Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Benoit Cousson <b-cousson@ti.com>, Mitch Bradley <wmb@firmworks.com>,
        Alan Tull <atull@altera.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Joel A Fernandes <agnel.joel@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Matt Ranostay <mranostay@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 4/5] capemgr: firmware makefiles for DT objects
Date: Mon,  7 Jan 2013 20:51:05 +0200
Message-Id: <1357584666-17374-5-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
References: <1357584666-17374-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makefile rules to support compiling DT cape definitions.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 firmware/Makefile | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/firmware/Makefile b/firmware/Makefile
index cbb09ce..361b2af 100644
--- a/firmware/Makefile
+++ b/firmware/Makefile
@@ -147,6 +147,9 @@ quiet_cmd_mkdir = MKDIR   $(patsubst $(objtree)/%,%,$@)
 quiet_cmd_ihex  = IHEX    $@
       cmd_ihex  = $(OBJCOPY) -Iihex -Obinary $< $@
 
+quiet_cmd_dtco	= DTCO $@
+      cmd_dtco	= $(objtree)/scripts/dtc/dtc -O dtb -o $@ -b 0 $(DTC_FLAGS) -@ $<
+
 quiet_cmd_ihex2fw  = IHEX2FW $@
       cmd_ihex2fw  = $(objtree)/$(obj)/ihex2fw $< $@
 
@@ -233,6 +236,10 @@ $(obj)/%.fw: $(obj)/%.HEX $(ihex2fw_dep) | $(objtree)/$(obj)/$$(dir %)
 $(obj)/%.fw: $(obj)/%.H16 $(ihex2fw_dep) | $(objtree)/$(obj)/$$(dir %)
 	$(call cmd,h16tofw)
 
+# DTBO is device tree blob object
+$(obj)/%.dtbo: $(obj)/%.dts | $(objtree)/$(obj)/$$(dir %)
+	$(call cmd,dtco)
+
 $(firmware-dirs):
 	$(call cmd,mkdir)
 
-- 
1.7.12

