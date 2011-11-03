Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab1KCSAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:00:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab1KCSAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:00:44 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] edac: Only build sb_edac on 64-bit
Date: Thu,  3 Nov 2011 16:00:11 -0200
Message-Id: <1320343211-10665-1-git-send-email-mchehab@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

The sb_edac driver is marginally useful on a 32-bit kernel, and
currently has 64-bit divide compile errors when building that config.
For now, make this build on only for 64-bit kernels.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 203361e..5948a21 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -214,7 +214,7 @@ config EDAC_I7300
 
 config EDAC_SBRIDGE
 	tristate "Intel Sandy-Bridge Integrated MC"
-	depends on EDAC_MM_EDAC && PCI && X86 && X86_MCE_INTEL
+	depends on EDAC_MM_EDAC && PCI && X86_64 && X86_MCE_INTEL
 	depends on EXPERIMENTAL
 	help
 	  Support for error detection and correction the Intel
-- 
1.7.8.rc0.32.g87bf9

