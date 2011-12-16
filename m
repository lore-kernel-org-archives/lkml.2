Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805Ab1LPUEr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:04:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742Ab1LPTu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:50:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:45:59 2011
Message-Id: <20111216194558.912910799@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:45:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Axel Lin <axel.lin@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [30/53] hwmon: (jz4740) fix signedness bug
In-Reply-To: <20111216194613.GA18395@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit 0b57d7602b68f7b2786b2f0e22da39cbd4139a95 upstream.

wait_for_completion_interruptible_timeout() may return negative value.
In this case, checking if (t > 0)  will return true if t is unsigned.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/jz4740-hwmon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/jz4740-hwmon.c
+++ b/drivers/hwmon/jz4740-hwmon.c
@@ -59,7 +59,7 @@ static ssize_t jz4740_hwmon_read_adcin(s
 {
 	struct jz4740_hwmon *hwmon = dev_get_drvdata(dev);
 	struct completion *completion = &hwmon->read_completion;
-	unsigned long t;
+	long t;
 	unsigned long val;
 	int ret;
 


