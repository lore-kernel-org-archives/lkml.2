Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab1DZVbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:31:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:43613 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab1DZVOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="425951040"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: segoon@openwall.com, linus.walleij@stericsson.com, sameo@linux.intel.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [34/106] mfd: ab3100: world-writable debugfs *_priv files
Message-Id: <20110426211313.877FC3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

commit f8a0697722d12a201588225999cfc8bfcbc82781 upstream.

Don't allow everybody to change device hardware registers.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/mfd/ab3100-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/drivers/mfd/ab3100-core.c
===================================================================
--- linux-2.6.35.y.orig/drivers/mfd/ab3100-core.c
+++ linux-2.6.35.y/drivers/mfd/ab3100-core.c
@@ -611,7 +611,7 @@ static void ab3100_setup_debugfs(struct 
 	ab3100_get_priv.ab3100 = ab3100;
 	ab3100_get_priv.mode = false;
 	ab3100_get_reg_file = debugfs_create_file("get_reg",
-				S_IWUGO, ab3100_dir, &ab3100_get_priv,
+				S_IWUSR, ab3100_dir, &ab3100_get_priv,
 				&ab3100_get_set_reg_fops);
 	if (!ab3100_get_reg_file) {
 		err = -ENOMEM;
@@ -621,7 +621,7 @@ static void ab3100_setup_debugfs(struct 
 	ab3100_set_priv.ab3100 = ab3100;
 	ab3100_set_priv.mode = true;
 	ab3100_set_reg_file = debugfs_create_file("set_reg",
-				S_IWUGO, ab3100_dir, &ab3100_set_priv,
+				S_IWUSR, ab3100_dir, &ab3100_set_priv,
 				&ab3100_get_set_reg_fops);
 	if (!ab3100_set_reg_file) {
 		err = -ENOMEM;
