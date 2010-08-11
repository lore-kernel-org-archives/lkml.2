Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab0HKTK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:10:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24940 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759Ab0HKTKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:10:25 -0400
Date: Wed, 11 Aug 2010 12:03:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Jordan Crouse <jordan.crouse@amd.com>,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH] pc8736x_gpio: depends on X86_32
Message-Id: <20100811120327.bbdd4310.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning for PC8736x_GPIO by restricting it
to X86_32.

warning: (SCx200_GPIO && SCx200 || PC8736x_GPIO && X86) selects NSC_GPIO which has unmet direct dependencies (X86_32)

NSC_GPIO is X86_32 only.  The other driver (SCx200_GPIO) that selects
NSC_GPIO is X86_32 only (indirectly, since SCx200 depends on X86_32),
so limit this driver also.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/char/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-git10.orig/drivers/char/Kconfig
+++ linux-2.6.35-git10/drivers/char/Kconfig
@@ -1002,7 +1002,7 @@ config SCx200_GPIO
 
 config PC8736x_GPIO
 	tristate "NatSemi PC8736x GPIO Support"
-	depends on X86
+	depends on X86_32
 	default SCx200_GPIO	# mostly N
 	select NSC_GPIO		# needed for support routines
 	help
