Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab2ACWh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:37:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab2ACWhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:37:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:36 2012
Message-Id: <20120103223036.711100120@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kyle Manna <kyle@kylemanna.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [64/67] mfd: Copy the device pointer to the twl4030-madc structure
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Manna <kyle@kylemanna.com>

commit 66cc5b8e50af87b0bbd0f179d76d2826f4549c13 upstream.

Worst case this fixes the following error:
[   72.086212] (NULL device *): conversion timeout!

Best case it prevents a crash

Signed-off-by: Kyle Manna <kyle@kylemanna.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

---
 drivers/mfd/twl4030-madc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -706,6 +706,8 @@ static int __devinit twl4030_madc_probe(
 	if (!madc)
 		return -ENOMEM;
 
+	madc->dev = &pdev->dev;
+
 	/*
 	 * Phoenix provides 2 interrupt lines. The first one is connected to
 	 * the OMAP. The other one can be connected to the other processor such


