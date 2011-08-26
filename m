Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab1HZUeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:34:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37019 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754945Ab1HZUeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        J Freyensee <james_p_freyensee@linux.intel.com>,
        Tracey Dent <tdent48227@gmail.com>,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/13] pti: add missing CONFIG_PCI dependency
Date: Fri, 26 Aug 2011 13:33:45 -0700
Message-Id: <1314390834-3411-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

allmodconfig compile fails on s390 because of the new PTI driver:

drivers/misc/pti.c:407:3: error: implicit declaration of function 'pci_iounmap'
drivers/misc/pti.c:410:3: error: implicit declaration of function 'pci_release_region'

Add a 'depends on PCI' statement so it doesn't get compiled.

Cc: J Freyensee <james_p_freyensee@linux.intel.com>

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 0a4d86c..2d6423c 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -146,6 +146,7 @@ config PHANTOM
 
 config INTEL_MID_PTI
 	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
+	depends on PCI
 	default n
 	help
 	  The PTI (Parallel Trace Interface) driver directs
-- 
1.7.6.1

