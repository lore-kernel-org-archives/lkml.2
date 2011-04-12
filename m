Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab1DLOnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:43:23 -0400
Received: from kroah.org ([198.145.64.141]:57786 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932414Ab1DLOir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:57 2011
Message-Id: <20110412143557.258763486@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [087/105] mfd: ab3100: world-writable debugfs *_priv files
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

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
@@ -613,7 +613,7 @@ static void ab3100_setup_debugfs(struct
 	ab3100_get_priv.ab3100 = ab3100;
 	ab3100_get_priv.mode = false;
 	ab3100_get_reg_file = debugfs_create_file("get_reg",
-				S_IWUGO, ab3100_dir, &ab3100_get_priv,
+				S_IWUSR, ab3100_dir, &ab3100_get_priv,
 				&ab3100_get_set_reg_fops);
 	if (!ab3100_get_reg_file) {
 		err = -ENOMEM;
@@ -623,7 +623,7 @@ static void ab3100_setup_debugfs(struct
 	ab3100_set_priv.ab3100 = ab3100;
 	ab3100_set_priv.mode = true;
 	ab3100_set_reg_file = debugfs_create_file("set_reg",
-				S_IWUGO, ab3100_dir, &ab3100_set_priv,
+				S_IWUSR, ab3100_dir, &ab3100_set_priv,
 				&ab3100_get_set_reg_fops);
 	if (!ab3100_set_reg_file) {
 		err = -ENOMEM;


