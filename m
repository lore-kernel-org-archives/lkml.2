Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab1AFW0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:26:49 -0500
Received: from kroah.org ([198.145.64.141]:55689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab1AFWXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:55 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 26/36] rocket: fix compiler warning on rocket_pci_ids
Date: Thu,  6 Jan 2011 14:23:15 -0800
Message-Id: <1294352605-31906-26-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

Annotate rocket_pci_ids as '__used' to fix following warning:

  CC      drivers/char/rocket.o
drivers/char/rocket.c:1767: warning: ‘rocket_pci_ids’ defined but not used

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/rocket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 86308830..3e4e73a 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1764,7 +1764,7 @@ static void rp_flush_buffer(struct tty_struct *tty)
 
 #ifdef CONFIG_PCI
 
-static struct pci_device_id __devinitdata rocket_pci_ids[] = {
+static struct pci_device_id __devinitdata __used rocket_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RP, PCI_ANY_ID) },
 	{ }
 };
-- 
1.7.3.2

