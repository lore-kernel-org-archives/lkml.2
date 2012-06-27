Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab2F0JKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:10:22 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34967 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288Ab2F0JKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:10:19 -0400
Date: Wed, 27 Jun 2012 12:10:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Intel SCU Linux support <intel-linux-scu@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
        Ed Nadolski <edmund.nadolski@intel.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch -resend] isci: make function declaration match implementation
Message-ID: <20120627091005.GU31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse complains that we redeclare this with a different type, because
in the .c file we use an enum and in the .h file we declare the
parameter as a u32.  Probably it's best to use an enum in both places.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I originally sent this on Tue, 27 Mar 2012, and Emil Goode sent the same
patch on Fri, May 4, 2012.  Both were silently ignored.

diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index a703b9c..c7ee81d 100644
--- a/drivers/scsi/isci/remote_node_context.h
+++ b/drivers/scsi/isci/remote_node_context.h
@@ -212,7 +212,7 @@ enum sci_status sci_remote_node_context_destruct(struct sci_remote_node_context
 						      scics_sds_remote_node_context_callback callback,
 						      void *callback_parameter);
 enum sci_status sci_remote_node_context_suspend(struct sci_remote_node_context *sci_rnc,
-						     u32 suspend_type,
+						     enum sci_remote_node_suspension_reasons reason,
 						     u32 suspension_code);
 enum sci_status sci_remote_node_context_resume(struct sci_remote_node_context *sci_rnc,
 						    scics_sds_remote_node_context_callback cb_fn,
