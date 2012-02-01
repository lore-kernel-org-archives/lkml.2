Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab2BAEbz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 23:31:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39218 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab2BAEby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 23:31:54 -0500
Message-ID: <1328070707.3533.6.camel@phoenix>
Subject: [PATCH] mmc: cb710 core: Add missing spin_lock_init for irq_lock of
 struct cb710_chip
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Micha <mirq-linux@rere.qmqm.pl>, Pierre Ossman <pierre@ossman.eu>,
        Chris Ball <cjb@laptop.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 01 Feb 2012 12:31:47 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/misc/cb710/core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/cb710/core.c b/drivers/misc/cb710/core.c
index 68cd05b..85cc7710 100644
--- a/drivers/misc/cb710/core.c
+++ b/drivers/misc/cb710/core.c
@@ -245,6 +245,7 @@ static int __devinit cb710_probe(struct pci_dev *pdev,
 	if (err)
 		return err;
 
+	spin_lock_init(&chip->irq_lock);
 	chip->pdev = pdev;
 	chip->iobase = pcim_iomap_table(pdev)[0];
 
-- 
1.7.5.4



