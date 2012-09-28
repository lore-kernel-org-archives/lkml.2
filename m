Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031357Ab2I1UAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:00:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237Ab2I1Sz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:55:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Brown <davidb@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 046/262] ARM: 7513/1: Make sure dtc is built before running it
Date: Fri, 28 Sep 2012 11:49:35 -0700
Message-Id: <20120928183003.373402778@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Brown <davidb@codeaurora.org>

commit 70b0476a2394de4f4e32e0b67288d80ff71ca963 upstream.

'make dtbs' in a clean tree will try running the dtc before actually
building it.  Make these rules depend upon the scripts to build it.

Signed-off-by: David Brown <davidb@codeaurora.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -279,10 +279,10 @@ zImage Image xipImage bootpImage uImage:
 zinstall uinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
-%.dtb:
+%.dtb: scripts
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
-dtbs:
+dtbs: scripts
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
 # We use MRPROPER_FILES and CLEAN_FILES now


