Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab2FFS7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 14:59:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:31951 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757537Ab2FFS7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 14:59:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175629658"
Subject: [PATCH] libfcoe: Fix section mismatch
To: linux-scsi@vger.kernel.org, baryluk@smp.if.uj.edu.pl,
        linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        devel@open-fcoe.org
From: Robert Love <robert.w.love@intel.com>
Cc: Mark Rustad <mark.d.rustad@intel.com>, yi.zou@intel.com
Date: Wed, 06 Jun 2012 11:59:48 -0700
Message-ID: <20120606185948.26178.86781.stgit@fritz>
In-Reply-To: <138EA028228D124A900F5E6746F3C216286EAA65@ORSMSX102.amr.corp.intel.com>
References: <138EA028228D124A900F5E6746F3C216286EAA65@ORSMSX102.amr.corp.intel.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Rustad <mark.d.rustad@intel.com>

Recent changes to add fcoe_sysfs caused libfcoe_init to call fcoe_transport_exit
in a module initialization routine. The change resulted in the below error. This
patch removes the __exit keyword from the fcoe_transport_exit definition such
that it may be called from an __init routine.

WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x21): Section mismatch in reference from the function init_module() to the function .exit.text:fcoe_transp
exit()
The function __init init_module() references
a function __exit fcoe_transport_exit().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
fcoe_transport_exit() so it may be used outside an exit section.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe_transport.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index b46f43d..71cc909 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -502,7 +502,7 @@ static int __init fcoe_transport_init(void)
 	return 0;
 }
 
-static int __exit fcoe_transport_exit(void)
+static int fcoe_transport_exit(void)
 {
 	struct fcoe_transport *ft;
 

