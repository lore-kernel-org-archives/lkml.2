Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0JVX5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:57:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab0JVXyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=M5K9efntyWt9LjWcXbRtdFJw+O93KlPqeadclkHj7Rqu8BTIG/PJ9ij6Rx7JRoE5Uz
         miDsMWEfBpT7z4AWymo9SXEGb7YRGEvXvKdJ9Vqr0q8C5o4Icp1XvoTjLr7wFJR3bZsh
         9AkOA8+3qLZeX6UB/DLrOs7EZT747YhaHgx2o=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 18/29] memstick: jmb38x_ms: rename functions
Date: Sat, 23 Oct 2010 01:53:46 +0200
Message-Id: <1287791637-10329-19-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give functions names that I hope will describe them better.
Its a matter of personal taste somewhat, I admit.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |   38 ++++++++++++++++++------------------
 drivers/memstick/host/jmb38x_ms.h |    4 +-
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 2e10104..295f755 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -22,7 +22,7 @@
 static int no_dma;
 static int debug;
 
-static unsigned int j38ms_read_data(struct j38ms_host *host,
+static unsigned int j38ms_read_fifo_pio(struct j38ms_host *host,
 					unsigned char *buf, unsigned int length)
 {
 	unsigned int off = 0;
@@ -60,7 +60,7 @@ static unsigned int j38ms_read_data(struct j38ms_host *host,
 	return off;
 }
 
-static unsigned int j38ms_write_data(struct j38ms_host *host,
+static unsigned int j38ms_write_fifo_pio(struct j38ms_host *host,
 					 unsigned char *buf,
 					 unsigned int length)
 {
@@ -149,12 +149,12 @@ static int j38ms_transfer_data(struct j38ms_host *host)
 
 		if (host->req->data_dir == WRITE)
 			t_size = !(host->cmd_flags & REG_DATA)
-				 ? j38ms_write_data(host, buf, p_cnt)
-				 : j38ms_write_reg_data(host, buf, p_cnt);
+				 ? j38ms_write_fifo_pio(host, buf, p_cnt)
+				 : j38ms_write_tpc_inline(host, buf, p_cnt);
 		else
 			t_size = !(host->cmd_flags & REG_DATA)
-				 ? j38ms_read_data(host, buf, p_cnt)
-				 : j38ms_read_reg_data(host, buf, p_cnt);
+				 ? j38ms_read_fifo_pio(host, buf, p_cnt)
+				 : j38ms_read_tpc_inline(host, buf, p_cnt);
 
 		if (host->req->long_data) {
 			kunmap_atomic(buf - p_off, KM_BIO_SRC_IRQ);
@@ -180,7 +180,7 @@ static int j38ms_transfer_data(struct j38ms_host *host)
 	return length;
 }
 
-static unsigned int j38ms_read_reg_data(struct j38ms_host *host,
+static unsigned int j38ms_read_tpc_inline(struct j38ms_host *host,
 					    unsigned char *buf,
 					    unsigned int length)
 {
@@ -206,7 +206,7 @@ static unsigned int j38ms_read_reg_data(struct j38ms_host *host,
 	return off;
 }
 
-static unsigned int j38ms_write_reg_data(struct j38ms_host *host,
+static unsigned int j38ms_write_tpc_inline(struct j38ms_host *host,
 					     unsigned char *buf,
 					     unsigned int length)
 {
@@ -232,7 +232,7 @@ static unsigned int j38ms_write_reg_data(struct j38ms_host *host,
 	return off;
 }
 
-static int j38ms_issue_cmd(struct memstick_host *msh)
+static int j38ms_execute_tpc(struct memstick_host *msh)
 {
 	struct j38ms_host *host = memstick_priv(msh);
 	unsigned char *data;
@@ -330,7 +330,7 @@ static int j38ms_issue_cmd(struct memstick_host *msh)
 	return 0;
 }
 
-static void j38ms_complete_cmd(struct memstick_host *msh, int last)
+static void j38ms_complete_tpc(struct memstick_host *msh, int last)
 {
 	struct j38ms_host *host = memstick_priv(msh);
 	unsigned int t_val = 0;
@@ -370,7 +370,7 @@ static void j38ms_complete_cmd(struct memstick_host *msh, int last)
 	if (!last) {
 		do {
 			rc = memstick_next_req(msh, &host->req);
-		} while (!rc && j38ms_issue_cmd(msh));
+		} while (!rc && j38ms_execute_tpc(msh));
 	} else {
 		do {
 			rc = memstick_next_req(msh, &host->req);
@@ -446,13 +446,13 @@ static irqreturn_t j38ms_isr(int irq, void *dev_id)
 	    && (((host->cmd_flags & CMD_READY)
 		 && (host->cmd_flags & FIFO_READY))
 		|| host->req->error))
-		j38ms_complete_cmd(msh, 0);
+		j38ms_complete_tpc(msh, 0);
 
 	spin_unlock(&host->lock);
 	return IRQ_HANDLED;
 }
 
-static void j38ms_abort(unsigned long data)
+static void j38ms_irq_timeout(unsigned long data)
 {
 	struct memstick_host *msh = (struct memstick_host *)data;
 	struct j38ms_host *host = memstick_priv(msh);
@@ -462,12 +462,12 @@ static void j38ms_abort(unsigned long data)
 	spin_lock_irqsave(&host->lock, flags);
 	if (host->req) {
 		host->req->error = -ETIME;
-		j38ms_complete_cmd(msh, 0);
+		j38ms_complete_tpc(msh, 0);
 	}
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void j38ms_req_tasklet(unsigned long data)
+static void j38ms_submit_tasklet(unsigned long data)
 {
 	struct memstick_host *msh = (struct memstick_host *)data;
 	struct j38ms_host *host = memstick_priv(msh);
@@ -479,7 +479,7 @@ static void j38ms_req_tasklet(unsigned long data)
 		do {
 			rc = memstick_next_req(msh, &host->req);
 			dev_dbg(&host->chip->pdev->dev, "tasklet req %d\n", rc);
-		} while (!rc && j38ms_issue_cmd(msh));
+		} while (!rc && j38ms_execute_tpc(msh));
 	}
 	spin_unlock_irqrestore(&host->lock, flags);
 }
@@ -713,13 +713,13 @@ static struct memstick_host *j38ms_alloc_host(struct j38ms *jm, int cnt)
 	host->irq = jm->pdev->irq;
 	host->timeout_jiffies = msecs_to_jiffies(1000);
 
-	tasklet_init(&host->notify, j38ms_req_tasklet, (unsigned long)msh);
+	tasklet_init(&host->notify, j38ms_submit_tasklet, (unsigned long)msh);
 	msh->request = j38ms_submit_req;
 	msh->set_param = j38ms_set_param;
 
 	msh->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
 
-	setup_timer(&host->timer, j38ms_abort, (unsigned long)msh);
+	setup_timer(&host->timer, j38ms_irq_timeout, (unsigned long)msh);
 
 	if (!request_irq(host->irq, j38ms_isr, IRQF_SHARED, host->host_id,
 			 msh))
@@ -835,7 +835,7 @@ static void j38ms_remove(struct pci_dev *dev)
 		spin_lock_irqsave(&host->lock, flags);
 		if (host->req) {
 			host->req->error = -ETIME;
-			j38ms_complete_cmd(jm->hosts[cnt], 1);
+			j38ms_complete_tpc(jm->hosts[cnt], 1);
 		}
 		spin_unlock_irqrestore(&host->lock, flags);
 
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
index a940b5d..44e1fc1 100644
--- a/drivers/memstick/host/jmb38x_ms.h
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -187,10 +187,10 @@ enum {
 #define dbg_v(host, format, ...)	__dbg(host, 2, format, ## __VA_ARGS__)
 #define dbg_reg(host, format, ...)	__dbg(host, 3, format, ## __VA_ARGS__)
 
-static unsigned int j38ms_read_reg_data(struct j38ms_host *host,
+static unsigned int j38ms_read_tpc_inline(struct j38ms_host *host,
 					    unsigned char *buf,
 					    unsigned int length);
 
-static unsigned int j38ms_write_reg_data(struct j38ms_host *host,
+static unsigned int j38ms_write_tpc_inline(struct j38ms_host *host,
 					     unsigned char *buf,
 					     unsigned int length);
-- 
1.7.1

