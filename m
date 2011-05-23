Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab1EWSg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 14:36:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62751 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab1EWSgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 14:36:55 -0400
Date: Mon, 23 May 2011 11:35:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        "Nicholas A. Bellinger" <nab@kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] target: fix tfc_io.c printk format warning
Message-Id: <20110523113555.e37bc856.randy.dunlap@oracle.com>
In-Reply-To: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090204.4DDAA916.0148:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/target/tcm_fc/tfc_io.c:209: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/target/tcm_fc/tfc_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

and please put an entry in the MAINTAINERS file for drivers/target/


--- linux-next-20110523.orig/drivers/target/tcm_fc/tfc_io.c
+++ linux-next-20110523/drivers/target/tcm_fc/tfc_io.c
@@ -203,7 +203,7 @@ int ft_queue_data_in(struct se_cmd *se_c
 			/* XXX For now, initiator will retry */
 			if (printk_ratelimit())
 				printk(KERN_ERR "%s: Failed to send frame %p, "
-						"xid <0x%x>, remaining <0x%x>, "
+						"xid <0x%x>, remaining <0x%zx>, "
 						"lso_max <0x%x>\n",
 						__func__, fp, ep->xid,
 						remaining, lport->lso_max);
