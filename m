Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162Ab1HDEeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 00:34:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55684 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1HDEd7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 00:33:59 -0400
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: u.kleine-koenig@pengutronix.de
Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: =?UTF-8?q?=5BPATCH=20v3=5D=20mfd=3Afix=20section=20mismatch=20warning=20in=20ab3550-core?=
Date: Thu, 4 Aug 2011 12:32:31 +0800
Message-Id: <1312432351-15729-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <20110803083255.GJ9250@pengutronix.de>
References: <20110803083255.GJ9250@pengutronix.de>
MIME-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-04 12:32:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-04 12:32:35
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes:
WARNING: drivers/mfd/built-in.o(.data+0x9998): Section mismatch in reference from the variable ab3550_driver to the function .init.text:ab3550_probe()
The variable ab3550_driver references
the function __init ab3550_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/ab3550-core.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
index 56ba194..882ea71 100644
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -1086,7 +1086,7 @@ static inline void ab3550_remove_debugfs(void)
  * This sets up a default config in the AB3550 chip so that it
  * will work as expected.
  */
-static int __init ab3550_setup(struct ab3550 *ab)
+static int __devinit ab3550_setup(struct ab3550 *ab)
 {
 	int err = 0;
 	int i;
@@ -1193,7 +1193,7 @@ struct ab_family_id {
 	char	*name;
 };
 
-static const struct ab_family_id ids[] __initdata = {
+static const struct ab_family_id ids[] __devinitconst = {
 	/* AB3550 */
 	{
 		.id = AB3550_P1A,
@@ -1205,7 +1205,7 @@ static const struct ab_family_id ids[] __initdata = {
 	}
 };
 
-static int __init ab3550_probe(struct i2c_client *client,
+static int __devinit ab3550_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
 	struct ab3550 *ab;
@@ -1326,7 +1326,7 @@ exit_no_detect:
 	return err;
 }
 
-static int __exit ab3550_remove(struct i2c_client *client)
+static int __devexit ab3550_remove(struct i2c_client *client)
 {
 	struct ab3550 *ab = i2c_get_clientdata(client);
 	int num_i2c_clients = AB3550_NUM_BANKS;
@@ -1359,7 +1359,7 @@ static struct i2c_driver ab3550_driver = {
 	},
 	.id_table	= ab3550_id,
 	.probe		= ab3550_probe,
-	.remove		= __exit_p(ab3550_remove),
+	.remove		= __devexit_p(ab3550_remove),
 };
 
 static int __init ab3550_i2c_init(void)
-- 
1.7.6

