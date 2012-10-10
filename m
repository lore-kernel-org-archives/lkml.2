Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932621Ab2JJXRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:17:09 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40435 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755646Ab2JJXBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:01:19 -0400
X-Sasl-enc: 5At6VAC8p/DvPNZOmTcRU6+VUjUWpKgBN9nHzSQq15nP 1349910078
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 020/122] drivers/dma/dmaengine.c: lower the priority of failed to get dma channel message
Date: Thu, 11 Oct 2012 07:53:06 +0900
Message-Id: <20121010225341.777615118@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <fabio.estevam@freescale.com>

commit 0eb5a35801df3c438ce3fc91310a415ea4452c00 upstream.

Do the same as commit a03a202e95fd ("dmaengine: failure to get a
specific DMA channel is not critical") to get rid of the following
messages during kernel boot:

  dmaengine_get: failed to get dma1chan0: (-22)
  dmaengine_get: failed to get dma1chan1: (-22)
  dmaengine_get: failed to get dma1chan2: (-22)
  dmaengine_get: failed to get dma1chan3: (-22)
  ..

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dma/dmaengine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -582,7 +582,7 @@ void dmaengine_get(void)
 				list_del_rcu(&device->global_node);
 				break;
 			} else if (err)
-				pr_err("%s: failed to get %s: (%d)\n",
+				pr_debug("%s: failed to get %s: (%d)\n",
 				       __func__, dma_chan_name(chan), err);
 		}
 	}


