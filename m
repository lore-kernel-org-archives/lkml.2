Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab0ESFXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 01:23:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56517 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab0ESFXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 01:23:04 -0400
Date: Wed, 19 May 2010 15:23:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anton Vorontsov <avorontsov@mvista.com>,
       David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the devicetree tree with the net tree
Message-Id: <20100519152301.ad6cd9e9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
drivers/net/gianfar.c between commit
b14ed884df5968b0977114ebd5a22f58d0d15315 ("gianfar: Remove legacy PM
callbacks") from the net tree and commit
030d1870b731924034caf0c874981e2ed4f1becc ("drivers/net/of: don't use
deprecated field in of_platform_driver") from the devicetree tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/gianfar.c
index c6791cd,c3b292a..0000000
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@@ -3167,12 -3054,16 +3167,14 @@@ MODULE_DEVICE_TABLE(of, gfar_match)
  
  /* Structure for a device driver */
  static struct of_platform_driver gfar_driver = {
- 	.name = "fsl-gianfar",
- 	.match_table = gfar_match,
- 
+ 	.driver = {
+ 		.name = "fsl-gianfar",
+ 		.owner = THIS_MODULE,
+ 		.pm = GFAR_PM_OPS,
+ 		.of_match_table = gfar_match,
+ 	},
  	.probe = gfar_probe,
  	.remove = gfar_remove,
- 	.driver.pm = GFAR_PM_OPS,
 -	.suspend = gfar_legacy_suspend,
 -	.resume = gfar_legacy_resume,
  };
  
  static int __init gfar_init(void)
