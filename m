Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965303Ab2I1Vwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:52:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55300 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031732Ab2I1UXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:23:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        David Brown <davidb@codeaurora.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 041/218] ARM: 7513/1: Make sure dtc is built before running it
Date: Fri, 28 Sep 2012 13:14:18 -0700
Message-Id: <20120928201506.155168271@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -283,10 +283,10 @@ zImage Image xipImage bootpImage uImage:
 zinstall uinstall install: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $@
 
-%.dtb:
+%.dtb: scripts
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
-dtbs:
+dtbs: scripts
 	$(Q)$(MAKE) $(build)=$(boot) MACHINE=$(MACHINE) $(boot)/$@
 
 # We use MRPROPER_FILES and CLEAN_FILES now


