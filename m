Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab0IRStM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 14:49:12 -0400
Received: from kroah.org ([198.145.64.141]:38974 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368Ab0IRSsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 14:48:39 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:46:21 2010
Message-Id: <20100918184621.707307122@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:45:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guillem Jover <guillem@hadrons.org>, Riku Voipio <riku.voipio@iki.fi>,
        Jean Delvare <khali@linux-fr.org>
Subject: [09/11] hwmon: (f75375s) Do not overwrite values read from registers
In-Reply-To: <20100918184651.GA14224@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guillem Jover <guillem@hadrons.org>

commit c3b327d60bbba3f5ff8fd87d1efc0e95eb6c121b upstream.

All bits in the values read from registers to be used for the next
write were getting overwritten, avoid doing so to not mess with the
current configuration.

Signed-off-by: Guillem Jover <guillem@hadrons.org>
Cc: Riku Voipio <riku.voipio@iki.fi>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/f75375s.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -298,7 +298,7 @@ static int set_pwm_enable_direct(struct
 		return -EINVAL;
 
 	fanmode = f75375_read8(client, F75375_REG_FAN_TIMER);
-	fanmode = ~(3 << FAN_CTRL_MODE(nr));
+	fanmode &= ~(3 << FAN_CTRL_MODE(nr));
 
 	switch (val) {
 	case 0: /* Full speed */
@@ -350,7 +350,7 @@ static ssize_t set_pwm_mode(struct devic
 
 	mutex_lock(&data->update_lock);
 	conf = f75375_read8(client, F75375_REG_CONFIG1);
-	conf = ~(1 << FAN_CTRL_LINEAR(nr));
+	conf &= ~(1 << FAN_CTRL_LINEAR(nr));
 
 	if (val == 0)
 		conf |= (1 << FAN_CTRL_LINEAR(nr)) ;


