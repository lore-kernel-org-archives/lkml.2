Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab0C3XUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:20:08 -0400
Received: from kroah.org ([198.145.64.141]:45588 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932285Ab0C3XTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:10 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:15 2010
Message-Id: <20100330225714.754838073@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lars-Peter Clausen <lars@metafoo.de>, <linux-mmc@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [114/116] s3cmci: initialize default platform data no_wprotect and no_detect with 1
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit c212808a1ba6bfba489006399b8152a047305acf upstream.

If no platform_data was givin to the device it's going to use it's default
platform data struct which has all fields initialized to zero.  As a
result the driver is going to try to request gpio0 both as write protect
and card detect pin.  Which of course will fail and makes the driver
unusable

Previously to the introduction of no_wprotect and no_detect the behavior
was to assume that if no platform data was given there is no write protect
or card detect pin.  This patch restores that behavior.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/host/s3cmci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -1361,6 +1361,8 @@ static struct mmc_host_ops s3cmci_ops =
 static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
 	/* This is currently here to avoid a number of if (host->pdata)
 	 * checks. Any zero fields to ensure reaonable defaults are picked. */
+	.no_wprotect = 1,
+	.no_detect = 1,
 };
 
 #ifdef CONFIG_CPU_FREQ


