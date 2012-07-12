Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964923Ab2GLXcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:32:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54985 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161827Ab2GLWkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:40:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tushar Behera <tushar.behera@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Vinod Koul <vinod.koul@linux.intel.com>
Subject: [ 090/187] dmaengine: pl330: dont complete descriptor for cyclic dma
Date: Thu, 12 Jul 2012 15:34:06 -0700
Message-Id: <20120712191530.754856286@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tushar Behera <tushar.behera@linaro.org>

commit 30c1dc0ff30b5552e8af555265dbeac5637cbb48 upstream.

Commit eab215855803 ("dmaengine: pl330: dont complete descriptor for
cyclic dma") wrongly completes descriptor for cyclic dma, hence following
BUG_ON is still hit with cyclic DMA operations.

kernel BUG at drivers/dma/dmaengine.h:53!

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
Acked-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/pl330.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2322,7 +2322,7 @@ static void pl330_tasklet(unsigned long
 	/* Pick up ripe tomatoes */
 	list_for_each_entry_safe(desc, _dt, &pch->work_list, node)
 		if (desc->status == DONE) {
-			if (pch->cyclic)
+			if (!pch->cyclic)
 				dma_cookie_complete(&desc->txd);
 			list_move_tail(&desc->node, &list);
 		}


