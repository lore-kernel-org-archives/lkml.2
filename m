Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0HNCFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 22:05:38 -0400
Received: from infernal.debian.net ([87.230.26.131]:39875 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab0HNCFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 22:05:37 -0400
X-Greylist: delayed 2429 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2010 22:05:37 EDT
From: Andreas Bombe <aeb@debian.org>
To: linux-kernel@vger.kernel.org
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Andreas Bombe <aeb@debian.org>
Subject: [PATCH] staging/comedi das08_cs.c: Fix io_req_t conversion
Date: Sat, 14 Aug 2010 03:24:22 +0200
Message-Id: <1281749062-9907-1-git-send-email-aeb@debian.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 90abdc3b9 converted all PCMCIA users away from io_req_t. In
das08_cs.c the converted IO lines mask setting was added but the old
line using the now inexistent p_dev->io was not removed.

Signed-off-by: Andreas Bombe <aeb@debian.org>
---
 drivers/staging/comedi/drivers/das08_cs.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/drivers/das08_cs.c b/drivers/staging/comedi/drivers/das08_cs.c
index c6aa52f..48d9fb1 100644
--- a/drivers/staging/comedi/drivers/das08_cs.c
+++ b/drivers/staging/comedi/drivers/das08_cs.c
@@ -222,7 +222,6 @@ static int das08_pcmcia_config_loop(struct pcmcia_device *p_dev,
 		p_dev->resource[0]->flags &= ~IO_DATA_PATH_WIDTH;
 		p_dev->resource[0]->flags |=
 			pcmcia_io_cfg_data_width(io->flags);
-		p_dev->io.IOAddrLines = io->flags & CISTPL_IO_LINES_MASK;
 		p_dev->resource[0]->start = io->win[0].base;
 		p_dev->resource[0]->end = io->win[0].len;
 		if (io->nwin > 1) {
-- 
1.7.1

