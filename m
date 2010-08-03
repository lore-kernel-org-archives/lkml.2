Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab0HCVdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 17:33:09 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:57744 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab0HCVdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 17:33:05 -0400
Date: Tue, 3 Aug 2010 23:33:03 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, linux-driver@qlogic.com,
        "J, ames E.J. Bottomley" <James.Bottomley@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 2/9] drivers/scsi/qla2xxx/qla_init.c: Drop unnecessary null
 test
Message-ID: <Pine.LNX.4.64.1008032331360.20393@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

list_for_each_entry binds its first argument to a non-null value, and thus
any null test on the value of that argument is superfluous.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
iterator I;
expression x,E;
@@

I(x,...) { <...
- (x != NULL) &&
  E
  ...> }
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/qla2xxx/qla_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d863ed2..9c6af9c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3796,7 +3796,7 @@ qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 	/* Go with deferred removal of rport references. */
 	list_for_each_entry_safe(vha, tvp, &base_vha->hw->vp_list, list)
 		list_for_each_entry(fcport, &vha->vp_fcports, list)
-			if (fcport && fcport->drport &&
+			if (fcport->drport &&
 			    atomic_read(&fcport->state) != FCS_UNCONFIGURED)
 				qla2x00_rport_del(fcport);
 }
