Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965041Ab2JKCQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:16:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54565 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964989Ab2JKCQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:16:30 -0400
X-Sasl-enc: XwtSoWYV9lHXu6KIdrS62+/NlmlnqCmy9jVPpJGbaFGy 1349921789
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Richard Genoud <richard.genoud@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
Subject: [ 81/84] mtd: nandsim: bugfix: fail if overridesize is too big
Date: Thu, 11 Oct 2012 11:04:05 +0900
Message-Id: <20121011015431.651973251@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Genoud <richard.genoud@gmail.com>

commit bb0a13a13411c4ce24c48c8ff3cdf7b48d237240 upstream.

If override size is too big, the module was actually loaded instead of
failing, because retval was not set.

This lead to memory corruption with the use of the freed structs nandsim
and nand_chip.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/nandsim.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -2355,6 +2355,7 @@ static int __init ns_init_module(void)
 		uint64_t new_size = (uint64_t)nsmtd->erasesize << overridesize;
 		if (new_size >> overridesize != nsmtd->erasesize) {
 			NS_ERR("overridesize is too big\n");
+			retval = -EINVAL;
 			goto err_exit;
 		}
 		/* N.B. This relies on nand_scan not doing anything with the size before we change it */


