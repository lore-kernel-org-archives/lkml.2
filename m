Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab1DEPBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:01:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:44453 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab1DEO7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:59:36 -0400
From: Michal Marek <mmarek@suse.cz>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 13/34] media/radio-maxiradio: Drop __TIME__ usage
Date: Tue,  5 Apr 2011 16:59:00 +0200
Message-Id: <1302015561-21047-14-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
References: <1302015561-21047-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel already prints its build timestamp during boot, no need to
repeat it in random drivers and produce different object files each
time.

Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/media/radio/radio-maxiradio.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 5c2a905..e83e840 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -412,8 +412,7 @@ static int __devinit maxiradio_init_one(struct pci_dev *pdev, const struct pci_d
 		goto err_out_free_region;
 	}
 
-	v4l2_info(v4l2_dev, "version " DRIVER_VERSION
-			" time " __TIME__ "  " __DATE__ "\n");
+	v4l2_info(v4l2_dev, "version " DRIVER_VERSION "\n");
 
 	v4l2_info(v4l2_dev, "found Guillemot MAXI Radio device (io = 0x%x)\n",
 	       dev->io);
-- 
1.7.4.1

