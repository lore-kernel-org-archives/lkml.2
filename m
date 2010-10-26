Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab0JZKTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:19:49 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60775 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0JZKSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:21 -0400
From: Julia Lawall <julia@diku.dk>
To: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Cc: kernel-janitors@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/14] drivers/platform/x86/thinkpad_acpi.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:37 +0200
Message-Id: <1288088743-3725-9-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/platform/x86/thinkpad_acpi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 2d61186..e8c2199 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -8497,7 +8497,6 @@ static void ibm_exit(struct ibm_struct *ibm)
 					   ibm->acpi->type,
 					   dispatch_acpi_notify);
 		ibm->flags.acpi_notify_installed = 0;
-		ibm->flags.acpi_notify_installed = 0;
 	}
 
 	if (ibm->flags.proc_created) {

