Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab1HAXgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:36:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38410 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab1HAXZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:51 2011
Message-Id: <20110801232051.567074499@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [10/70] hwmon: (pmbus) Auto-detect temp2 and temp3 registers/attributes
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit 0e502ec889d33bfcb348e420d7e105bc61c45eb4 upstream.

Additional temperature attribute support is easy to detect, so do it.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/pmbus.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/hwmon/pmbus.c
+++ b/drivers/hwmon/pmbus.c
@@ -63,6 +63,10 @@ static void pmbus_find_sensor_groups(str
 					      PMBUS_STATUS_TEMPERATURE))
 			info->func[0] |= PMBUS_HAVE_STATUS_TEMP;
 	}
+	if (pmbus_check_word_register(client, 0, PMBUS_READ_TEMPERATURE_2))
+		info->func[0] |= PMBUS_HAVE_TEMP2;
+	if (pmbus_check_word_register(client, 0, PMBUS_READ_TEMPERATURE_3))
+		info->func[0] |= PMBUS_HAVE_TEMP3;
 
 	/* Sensors detected on all pages */
 	for (page = 0; page < info->pages; page++) {


