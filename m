Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab1I1Wuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:50:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755995Ab1I1Wu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:48 2011
Message-Id: <20110928220148.551180036@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland Stigge <stigge@antcom.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [220/244] hwmon: (ds620) Fix handling of negative temperatures
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland Stigge <stigge@antcom.de>

commit cc41d586e8b4d76164fe7731c1c49be6cc5fc7e6 upstream.

Signed (negative) temperatures were not handled correctly.

Signed-off-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/ds620.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/ds620.c
+++ b/drivers/hwmon/ds620.c
@@ -72,7 +72,7 @@ struct ds620_data {
 	char valid;		/* !=0 if following fields are valid */
 	unsigned long last_updated;	/* In jiffies */
 
-	u16 temp[3];		/* Register values, word */
+	s16 temp[3];		/* Register values, word */
 };
 
 /*


