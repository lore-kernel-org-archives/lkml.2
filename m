Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1DMPzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 11:55:53 -0400
Received: from kroah.org ([198.145.64.141]:54438 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758141Ab1DMPzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 11:55:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Apr 13 08:51:47 2011
Message-Id: <20110413155147.787363598@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 13 Apr 2011 08:51:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [45/74] mfd: ab3100: world-writable debugfs *_priv files
In-Reply-To: <20110413155406.GA22568@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit f8a0697722d12a201588225999cfc8bfcbc82781 upstream.

Don't allow everybody to change device hardware registers.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/ab3100-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -591,7 +591,7 @@ static void ab3100_setup_debugfs(struct
 	ab3100_get_priv.ab3100 = ab3100;
 	ab3100_get_priv.mode = false;
 	ab3100_get_reg_file = debugfs_create_file("get_reg",
-				S_IWUGO, ab3100_dir, &ab3100_get_priv,
+				S_IWUSR, ab3100_dir, &ab3100_get_priv,
 				&ab3100_get_set_reg_fops);
 	if (!ab3100_get_reg_file) {
 		err = -ENOMEM;
@@ -601,7 +601,7 @@ static void ab3100_setup_debugfs(struct
 	ab3100_set_priv.ab3100 = ab3100;
 	ab3100_set_priv.mode = true;
 	ab3100_set_reg_file = debugfs_create_file("set_reg",
-				S_IWUGO, ab3100_dir, &ab3100_set_priv,
+				S_IWUSR, ab3100_dir, &ab3100_set_priv,
 				&ab3100_get_set_reg_fops);
 	if (!ab3100_set_reg_file) {
 		err = -ENOMEM;


