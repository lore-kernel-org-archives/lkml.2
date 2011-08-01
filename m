Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab1HAXY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:24:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38149 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab1HAXYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:24:22 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:51 2011
Message-Id: <20110801232051.779100636@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [12/70] hwmon: (pmbus) Improve fan detection
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit 81ae68142a0483b3791cba99eab268859858f508 upstream.

Some PMBus devices return no error when reading fan speed registers, but don't
really support fans. Strengthen fan detection by also checking if fan
configuration registers exist.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Reviewed-by: Robert Coulson <robert.coulson@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/pmbus.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/pmbus.c
+++ b/drivers/hwmon/pmbus.c
@@ -47,12 +47,14 @@ static void pmbus_find_sensor_groups(str
 	if (info->func[0]
 	    && pmbus_check_byte_register(client, 0, PMBUS_STATUS_INPUT))
 		info->func[0] |= PMBUS_HAVE_STATUS_INPUT;
-	if (pmbus_check_word_register(client, 0, PMBUS_READ_FAN_SPEED_1)) {
+	if (pmbus_check_byte_register(client, 0, PMBUS_FAN_CONFIG_12) &&
+	    pmbus_check_word_register(client, 0, PMBUS_READ_FAN_SPEED_1)) {
 		info->func[0] |= PMBUS_HAVE_FAN12;
 		if (pmbus_check_byte_register(client, 0, PMBUS_STATUS_FAN_12))
 			info->func[0] |= PMBUS_HAVE_STATUS_FAN12;
 	}
-	if (pmbus_check_word_register(client, 0, PMBUS_READ_FAN_SPEED_3)) {
+	if (pmbus_check_byte_register(client, 0, PMBUS_FAN_CONFIG_34) &&
+	    pmbus_check_word_register(client, 0, PMBUS_READ_FAN_SPEED_3)) {
 		info->func[0] |= PMBUS_HAVE_FAN34;
 		if (pmbus_check_byte_register(client, 0, PMBUS_STATUS_FAN_34))
 			info->func[0] |= PMBUS_HAVE_STATUS_FAN34;


