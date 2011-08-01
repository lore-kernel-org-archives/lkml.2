Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1HAXYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:24:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab1HAXYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:19 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:51 2011
Message-Id: <20110801232051.675686450@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [11/70] hwmon: (pmbus) Drop check for PMBus revision register in probe function
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit 7f2c0662e5cfd05f12ca49109e8f787bf2d87b66 upstream.

Some PMBus devices do not support the PMBus revision register, so don't check
if it exists.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/pmbus_core.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/drivers/hwmon/pmbus_core.c
+++ b/drivers/hwmon/pmbus_core.c
@@ -1518,14 +1518,9 @@ int pmbus_do_probe(struct i2c_client *cl
 	i2c_set_clientdata(client, data);
 	mutex_init(&data->update_lock);
 
-	/*
-	 * Bail out if status register or PMBus revision register
-	 * does not exist.
-	 */
-	if (i2c_smbus_read_byte_data(client, PMBUS_STATUS_BYTE) < 0
-	    || i2c_smbus_read_byte_data(client, PMBUS_REVISION) < 0) {
-		dev_err(&client->dev,
-			"Status or revision register not found\n");
+	/* Bail out if PMBus status register does not exist. */
+	if (i2c_smbus_read_byte_data(client, PMBUS_STATUS_BYTE) < 0) {
+		dev_err(&client->dev, "PMBus status register not found\n");
 		ret = -ENODEV;
 		goto out_data;
 	}


