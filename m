Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494Ab2E1Vyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 17:54:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:47221 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2E1VyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 17:54:04 -0400
From: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
Subject: [PATCH 2/2] staging: comedi: cb_pcidas64: Fixed an if-statement check
Date: Tue, 29 May 2012 00:51:45 +0300
Message-Id: <1338241905-24327-2-git-send-email-dimitrios.semitsoglou@gmail.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1338241905-24327-1-git-send-email-dimitrios.semitsoglou@gmail.com>
References: <1338229715-2730-1-git-send-email-dimitrios.semitsoglou@gmail.com>
 <1338241905-24327-1-git-send-email-dimitrios.semitsoglou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed in if-statemnt responsible for a sanity check inside the
prep_ao_dma function.

Signed-off-by: Dimitrios Semitsoglou-Tsiapos <dimitrios.semitsoglou@gmail.com>
---
 drivers/staging/comedi/drivers/cb_pcidas64.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 6f7fd99..a2e6f96 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -3392,8 +3392,8 @@ static int prep_ao_dma(struct comedi_device *dev, const struct comedi_cmd *cmd)
 	num_bytes = load_ao_dma_buffer(dev, cmd);
 	if (num_bytes == 0)
 		return -1;
-	if (num_bytes >= DMA_BUFFER_SIZE) ;
-	load_ao_dma(dev, cmd);
+	if (num_bytes >= DMA_BUFFER_SIZE)
+		load_ao_dma(dev, cmd);
 
 	dma_start_sync(dev, 0);
 
-- 
1.7.10.2

