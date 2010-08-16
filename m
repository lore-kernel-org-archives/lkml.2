Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab0HPK63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 06:58:29 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:55640 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab0HPK62 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:2:1>);
	Mon, 16 Aug 2010 06:58:28 -0400
Message-Id: <4C6936120200007800010064@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Mon, 16 Aug 2010 11:58:58 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] fixes for using make 3.82
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't like pattern and explicit rules to be on the same line,
and it seems to be more picky when matching file (or really directory)
names with different numbers of trailing slashes.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 firmware/Makefile  |    2 +-
 scripts/mkmakefile |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- linux-2.6.36-rc1/firmware/Makefile
+++ 2.6.36-rc1-make-3.82-fixes/firmware/Makefile
@@ -142,7 +142,7 @@ fw-shipped-$(CONFIG_YAM) += yam/1200.bin
 fw-shipped-all := $(fw-shipped-y) $(fw-shipped-m) $(fw-shipped-)
 
 # Directories which we _might_ need to create, so we have a rule for them.
-firmware-dirs := $(sort $(patsubst %,$(objtree)/$(obj)/%/,$(dir $(fw-external-y) $(fw-shipped-all))))
+firmware-dirs := $(sort $(addprefix $(objtree)/$(obj)/,$(dir $(fw-external-y) $(fw-shipped-all))))
 
 quiet_cmd_mkdir = MKDIR   $(patsubst $(objtree)/%,%,$@)
       cmd_mkdir = mkdir -p $@
--- linux-2.6.36-rc1/scripts/mkmakefile
+++ 2.6.36-rc1-make-3.82-fixes/scripts/mkmakefile
@@ -44,7 +44,9 @@ all:
 
 Makefile:;
 
-\$(all) %/: all
+\$(all): all
 	@:
 
+%/: all
+	@:
 EOF



