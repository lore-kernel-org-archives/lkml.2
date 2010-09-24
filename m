Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab0IXQkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:40:51 -0400
Received: from kroah.org ([198.145.64.141]:37350 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933015Ab0IXQfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:36 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:48 2010
Message-Id: <20100924163348.018890137@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Divy Le Ray <divy@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Brandon Philips <bphilips@suse.de>
Subject: [45/68] cxgb3: fix hot plug removal crash
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Divy Le Ray <divy@chelsio.com>

commit a6f018e324ba91d0464cca6895447c2b89e6d578 upstream.

queue restart tasklets need to be stopped after napi handlers are stopped
since the latter can restart them.  So stop them after stopping napi.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Brandon Philips <bphilips@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cxgb3/cxgb3_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/cxgb3/cxgb3_main.c
+++ b/drivers/net/cxgb3/cxgb3_main.c
@@ -1274,6 +1274,7 @@ static void cxgb_down(struct adapter *ad
 
 	free_irq_resources(adapter);
 	quiesce_rx(adapter);
+	t3_sge_stop(adapter);
 	flush_workqueue(cxgb3_wq);	/* wait for external IRQ handler */
 }
 


