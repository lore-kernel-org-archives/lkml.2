Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934064Ab2FEM3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 08:29:08 -0400
Received: from mailgate.zerties.org ([176.9.120.153]:33697 "EHLO
	gandalf.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab2FEM3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:29:07 -0400
From: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
To: Joe Perches <joe@perches.com>
Cc: Christian Dietrich 
	<christian.dietrich@informatik.uni-erlangen.de>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, vamos-dev@lists.cs.fau.de
Subject: Re: [PATCH] ide: icside.c: fix printk format string compile warning
References: <20120529103002.GA13283@faui49q.informatik.uni-erlangen.de>
	<4FC4C391.50700@mvista.com> <86hauw7jee.fsf_-_@gandalf.zerties.org>
	<1338672377.24148.6.camel@joe2Laptop>
Date: Tue, 05 Jun 2012 14:28:59 +0200
In-Reply-To: <1338672377.24148.6.camel@joe2Laptop> (Joe Perches's message of
	"Sat, 02 Jun 2012 14:26:17 -0700")
Message-ID: <86zk8i2b90.fsf@gandalf.zerties.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use correct format string parameter for the peak datarate, and prevent
uninitialized use of cycle_time.

Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
---
 drivers/ide/icside.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/icside.c b/drivers/ide/icside.c
index 83e5100..bcb507b 100644
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -236,7 +236,7 @@ static const struct ide_port_ops icside_v6_no_dma_port_ops = {
  */
 static void icside_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
-	unsigned long cycle_time;
+	unsigned long cycle_time = 0;
 	int use_dma_info = 0;
 	const u8 xfer_mode = drive->dma_mode;
 
@@ -271,9 +271,9 @@ static void icside_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 
 	ide_set_drivedata(drive, (void *)cycle_time);
 
-	printk("%s: %s selected (peak %dMB/s)\n", drive->name,
-		ide_xfer_verbose(xfer_mode),
-		2000 / (unsigned long)ide_get_drivedata(drive));
+	printk(KERN_INFO "%s: %s selected (peak %luMB/s)\n",
+	       drive->name, ide_xfer_verbose(xfer_mode),
+	       2000 / (cycle_time ? cycle_time : (unsigned long) -1));
 }
 
 static const struct ide_port_ops icside_v6_port_ops = {
-- 
1.7.5.4



