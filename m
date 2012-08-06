Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab2HFQMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 12:12:09 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:40428 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932260Ab2HFQMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 12:12:06 -0400
Message-ID: <501FEC87.6060506@xenotime.net>
Date: Mon, 06 Aug 2012 09:10:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        Mark Studebaker <mdsxyz123@yahoo.com>
Subject: [PATCH] i2c: fix i2c-i801.c printk format warning
References: <20120806140109.b1a33b63686ef04f30139c9e@canb.auug.org.au>
In-Reply-To: <20120806140109.b1a33b63686ef04f30139c9e@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning.  ARRAY_SIZE() uses sizeof(),
which is size_t, so use %zu to print it.

drivers/i2c/busses/i2c-i801.c: In function 'i801_add_mux':
drivers/i2c/busses/i2c-i801.c:1043:4: warning: format '%lu' expects type 'long unsigned int', but argument 3 has type 'unsigned int'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mark D. Studebaker <mdsxyz123@yahoo.com>
Cc: Jean Delvare <khali@linux-fr.org>
---
 drivers/i2c/busses/i2c-i801.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120806.orig/drivers/i2c/busses/i2c-i801.c
+++ linux-next-20120806/drivers/i2c/busses/i2c-i801.c
@@ -1039,7 +1039,7 @@ static int __devinit i801_add_mux(struct
 
 	/* Find absolute GPIO pin numbers */
 	if (ARRAY_SIZE(priv->mux_priv) < mux_config->n_gpios) {
-		dev_err(dev, "i801_priv.mux_priv too small (%lu, need %d)\n",
+		dev_err(dev, "i801_priv.mux_priv too small (%zu, need %d)\n",
 			ARRAY_SIZE(priv->mux_priv), mux_config->n_gpios);
 		return -ENODEV;
 	}
