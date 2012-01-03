Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776Ab2ACWiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:38:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab2ACWh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:37:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:36 2012
Message-Id: <20120103223036.798623316@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kyle Manna <kyle@kylemanna.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [65/67] mfd: Check for twl4030-madc NULL pointer
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Manna <kyle@kylemanna.com>

commit d0e84caeb4cd535923884735906e5730329505b4 upstream.

If the twl4030-madc device wasn't registered, and another device, such
as twl4030-madc-hwmon, calls twl4030_madc_conversion() a NULL pointer is
dereferenced.

Signed-off-by: Kyle Manna <kyle@kylemanna.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/twl4030-madc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -510,8 +510,9 @@ int twl4030_madc_conversion(struct twl40
 	u8 ch_msb, ch_lsb;
 	int ret;
 
-	if (!req)
+	if (!req || !twl4030_madc)
 		return -EINVAL;
+
 	mutex_lock(&twl4030_madc->lock);
 	if (req->method < TWL4030_MADC_RT || req->method > TWL4030_MADC_SW2) {
 		ret = -EINVAL;


