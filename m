Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0JVXyn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 19:54:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685Ab0JVXyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 19:54:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TV5v0bb1Kjrz6WSsm8GBKcl9dkTNN1RoS0HSM5ayjT9pn/pbVKoJTbkdpqVbEKONos
         u27y0FZ1/+8/IHnpBQBTsbC5hr9IUUj5IWNh35BJJQjp0vUrxuyx4uc2dft8lw0tDOk9
         duSpIdGS2BefSla7SZsE7jQ+dPC3lBWvxKz64=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 16/29] memstick: jmb38x_ms: s/jmb38x_ms/j38ms/g
Date: Sat, 23 Oct 2010 01:53:44 +0200
Message-Id: <1287791637-10329-17-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
References: <1287791637-10329-1-git-send-email-maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This just makes it easier to type function names
while still keeping the meaning
Driver name and filenames are left unchanged.


Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/jmb38x_ms.c |  154 ++++++++++++++++++------------------
 drivers/memstick/host/jmb38x_ms.h |    6 +-
 2 files changed, 80 insertions(+), 80 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 7a00bef..e896a4d 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -22,7 +22,7 @@
 static int no_dma;
 static int debug;
 
-static unsigned int jmb38x_ms_read_data(struct jmb38x_ms_host *host,
+static unsigned int j38ms_read_data(struct j38ms_host *host,
 					unsigned char *buf, unsigned int length)
 {
 	unsigned int off = 0;
@@ -60,7 +60,7 @@ static unsigned int jmb38x_ms_read_data(struct jmb38x_ms_host *host,
 	return off;
 }
 
-static unsigned int jmb38x_ms_read_reg_data(struct jmb38x_ms_host *host,
+static unsigned int j38ms_read_reg_data(struct j38ms_host *host,
 					    unsigned char *buf,
 					    unsigned int length)
 {
@@ -86,7 +86,7 @@ static unsigned int jmb38x_ms_read_reg_data(struct jmb38x_ms_host *host,
 	return off;
 }
 
-static unsigned int jmb38x_ms_write_data(struct jmb38x_ms_host *host,
+static unsigned int j38ms_write_data(struct j38ms_host *host,
 					 unsigned char *buf,
 					 unsigned int length)
 {
@@ -139,7 +139,7 @@ static unsigned int jmb38x_ms_write_data(struct jmb38x_ms_host *host,
 	return off;
 }
 
-static unsigned int jmb38x_ms_write_reg_data(struct jmb38x_ms_host *host,
+static unsigned int j38ms_write_reg_data(struct j38ms_host *host,
 					     unsigned char *buf,
 					     unsigned int length)
 {
@@ -165,7 +165,7 @@ static unsigned int jmb38x_ms_write_reg_data(struct jmb38x_ms_host *host,
 	return off;
 }
 
-static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
+static int j38ms_transfer_data(struct j38ms_host *host)
 {
 	unsigned int length;
 	unsigned int off;
@@ -201,12 +201,12 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 
 		if (host->req->data_dir == WRITE)
 			t_size = !(host->cmd_flags & REG_DATA)
-				 ? jmb38x_ms_write_data(host, buf, p_cnt)
-				 : jmb38x_ms_write_reg_data(host, buf, p_cnt);
+				 ? j38ms_write_data(host, buf, p_cnt)
+				 : j38ms_write_reg_data(host, buf, p_cnt);
 		else
 			t_size = !(host->cmd_flags & REG_DATA)
-				 ? jmb38x_ms_read_data(host, buf, p_cnt)
-				 : jmb38x_ms_read_reg_data(host, buf, p_cnt);
+				 ? j38ms_read_data(host, buf, p_cnt)
+				 : j38ms_read_reg_data(host, buf, p_cnt);
 
 		if (host->req->long_data) {
 			kunmap_atomic(buf - p_off, KM_BIO_SRC_IRQ);
@@ -232,9 +232,9 @@ static int jmb38x_ms_transfer_data(struct jmb38x_ms_host *host)
 	return length;
 }
 
-static int jmb38x_ms_issue_cmd(struct memstick_host *msh)
+static int j38ms_issue_cmd(struct memstick_host *msh)
 {
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = memstick_priv(msh);
 	unsigned char *data;
 	unsigned int data_len, cmd, t_val;
 
@@ -313,7 +313,7 @@ static int jmb38x_ms_issue_cmd(struct memstick_host *msh)
 		cmd |= data_len & 0xf;
 
 		if (host->req->data_dir == WRITE) {
-			jmb38x_ms_transfer_data(host);
+			j38ms_transfer_data(host);
 			writel(host->io_word[0], host->addr + TPC_P0);
 			writel(host->io_word[1], host->addr + TPC_P1);
 		}
@@ -330,9 +330,9 @@ static int jmb38x_ms_issue_cmd(struct memstick_host *msh)
 	return 0;
 }
 
-static void jmb38x_ms_complete_cmd(struct memstick_host *msh, int last)
+static void j38ms_complete_cmd(struct memstick_host *msh, int last)
 {
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = memstick_priv(msh);
 	unsigned int t_val = 0;
 	int rc;
 
@@ -370,7 +370,7 @@ static void jmb38x_ms_complete_cmd(struct memstick_host *msh, int last)
 	if (!last) {
 		do {
 			rc = memstick_next_req(msh, &host->req);
-		} while (!rc && jmb38x_ms_issue_cmd(msh));
+		} while (!rc && j38ms_issue_cmd(msh));
 	} else {
 		do {
 			rc = memstick_next_req(msh, &host->req);
@@ -380,10 +380,10 @@ static void jmb38x_ms_complete_cmd(struct memstick_host *msh, int last)
 	}
 }
 
-static irqreturn_t jmb38x_ms_isr(int irq, void *dev_id)
+static irqreturn_t j38ms_isr(int irq, void *dev_id)
 {
 	struct memstick_host *msh = dev_id;
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = memstick_priv(msh);
 	unsigned int irq_status;
 
 	spin_lock(&host->lock);
@@ -407,10 +407,10 @@ static irqreturn_t jmb38x_ms_isr(int irq, void *dev_id)
 			} else {
 				if (irq_status & (INT_STATUS_FIFO_RRDY
 						  | INT_STATUS_FIFO_WRDY))
-					jmb38x_ms_transfer_data(host);
+					j38ms_transfer_data(host);
 
 				if (irq_status & INT_STATUS_EOTRAN) {
-					jmb38x_ms_transfer_data(host);
+					j38ms_transfer_data(host);
 					host->cmd_flags |= FIFO_READY;
 				}
 			}
@@ -427,7 +427,7 @@ static irqreturn_t jmb38x_ms_isr(int irq, void *dev_id)
 								+ TPC_P1);
 						host->io_pos = 8;
 
-						jmb38x_ms_transfer_data(host);
+						j38ms_transfer_data(host);
 					}
 					host->cmd_flags |= FIFO_READY;
 				}
@@ -446,31 +446,31 @@ static irqreturn_t jmb38x_ms_isr(int irq, void *dev_id)
 	    && (((host->cmd_flags & CMD_READY)
 		 && (host->cmd_flags & FIFO_READY))
 		|| host->req->error))
-		jmb38x_ms_complete_cmd(msh, 0);
+		j38ms_complete_cmd(msh, 0);
 
 	spin_unlock(&host->lock);
 	return IRQ_HANDLED;
 }
 
-static void jmb38x_ms_abort(unsigned long data)
+static void j38ms_abort(unsigned long data)
 {
 	struct memstick_host *msh = (struct memstick_host *)data;
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = memstick_priv(msh);
 	unsigned long flags;
 
 	dev_dbg(&host->chip->pdev->dev, "abort\n");
 	spin_lock_irqsave(&host->lock, flags);
 	if (host->req) {
 		host->req->error = -ETIME;
-		jmb38x_ms_complete_cmd(msh, 0);
+		j38ms_complete_cmd(msh, 0);
 	}
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void jmb38x_ms_req_tasklet(unsigned long data)
+static void j38ms_req_tasklet(unsigned long data)
 {
 	struct memstick_host *msh = (struct memstick_host *)data;
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = memstick_priv(msh);
 	unsigned long flags;
 	int rc;
 
@@ -479,24 +479,24 @@ static void jmb38x_ms_req_tasklet(unsigned long data)
 		do {
 			rc = memstick_next_req(msh, &host->req);
 			dev_dbg(&host->chip->pdev->dev, "tasklet req %d\n", rc);
-		} while (!rc && jmb38x_ms_issue_cmd(msh));
+		} while (!rc && j38ms_issue_cmd(msh));
 	}
 	spin_unlock_irqrestore(&host->lock, flags);
 }
 
-static void jmb38x_ms_dummy_submit(struct memstick_host *msh)
+static void j38ms_dummy_submit(struct memstick_host *msh)
 {
 	return;
 }
 
-static void jmb38x_ms_submit_req(struct memstick_host *msh)
+static void j38ms_submit_req(struct memstick_host *msh)
 {
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = memstick_priv(msh);
 
 	tasklet_schedule(&host->notify);
 }
 
-static int jmb38x_ms_reset(struct jmb38x_ms_host *host)
+static int j38ms_reset(struct j38ms_host *host)
 {
 	int cnt;
 
@@ -538,11 +538,11 @@ reset_ok:
 	return 0;
 }
 
-static int jmb38x_ms_set_param(struct memstick_host *msh,
+static int j38ms_set_param(struct memstick_host *msh,
 			       enum memstick_param param,
 			       int value)
 {
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = memstick_priv(msh);
 	unsigned int host_ctl = readl(host->addr + HOST_CONTROL);
 	unsigned int clock_ctl = CLOCK_CONTROL_40MHZ, clock_delay = 0;
 	int rc = 0;
@@ -550,7 +550,7 @@ static int jmb38x_ms_set_param(struct memstick_host *msh,
 	switch (param) {
 	case MEMSTICK_POWER:
 		if (value == MEMSTICK_POWER_ON) {
-			rc = jmb38x_ms_reset(host);
+			rc = j38ms_reset(host);
 			if (rc)
 				return rc;
 
@@ -623,9 +623,9 @@ static int jmb38x_ms_set_param(struct memstick_host *msh,
 
 #ifdef CONFIG_PM
 
-static int jmb38x_ms_suspend(struct pci_dev *dev, pm_message_t state)
+static int j38ms_suspend(struct pci_dev *dev, pm_message_t state)
 {
-	struct jmb38x_ms *jm = pci_get_drvdata(dev);
+	struct j38ms *jm = pci_get_drvdata(dev);
 	int cnt;
 
 	for (cnt = 0; cnt < jm->host_cnt; ++cnt) {
@@ -641,9 +641,9 @@ static int jmb38x_ms_suspend(struct pci_dev *dev, pm_message_t state)
 	return 0;
 }
 
-static int jmb38x_ms_resume(struct pci_dev *dev)
+static int j38ms_resume(struct pci_dev *dev)
 {
-	struct jmb38x_ms *jm = pci_get_drvdata(dev);
+	struct j38ms *jm = pci_get_drvdata(dev);
 	int rc;
 
 	pci_set_power_state(dev, PCI_D0);
@@ -668,12 +668,12 @@ static int jmb38x_ms_resume(struct pci_dev *dev)
 
 #else
 
-#define jmb38x_ms_suspend NULL
-#define jmb38x_ms_resume NULL
+#define j38ms_suspend NULL
+#define j38ms_resume NULL
 
 #endif /* CONFIG_PM */
 
-static int jmb38x_ms_count_slots(struct pci_dev *pdev)
+static int j38ms_count_slots(struct pci_dev *pdev)
 {
 	int cnt, rc = 0;
 
@@ -689,12 +689,12 @@ static int jmb38x_ms_count_slots(struct pci_dev *pdev)
 	return rc;
 }
 
-static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
+static struct memstick_host *j38ms_alloc_host(struct j38ms *jm, int cnt)
 {
 	struct memstick_host *msh;
-	struct jmb38x_ms_host *host;
+	struct j38ms_host *host;
 
-	msh = memstick_alloc_host(sizeof(struct jmb38x_ms_host),
+	msh = memstick_alloc_host(sizeof(struct j38ms_host),
 				  &jm->pdev->dev);
 	if (!msh)
 		return NULL;
@@ -713,15 +713,15 @@ static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
 	host->irq = jm->pdev->irq;
 	host->timeout_jiffies = msecs_to_jiffies(1000);
 
-	tasklet_init(&host->notify, jmb38x_ms_req_tasklet, (unsigned long)msh);
-	msh->request = jmb38x_ms_submit_req;
-	msh->set_param = jmb38x_ms_set_param;
+	tasklet_init(&host->notify, j38ms_req_tasklet, (unsigned long)msh);
+	msh->request = j38ms_submit_req;
+	msh->set_param = j38ms_set_param;
 
 	msh->caps = MEMSTICK_CAP_PAR4 | MEMSTICK_CAP_PAR8;
 
-	setup_timer(&host->timer, jmb38x_ms_abort, (unsigned long)msh);
+	setup_timer(&host->timer, j38ms_abort, (unsigned long)msh);
 
-	if (!request_irq(host->irq, jmb38x_ms_isr, IRQF_SHARED, host->host_id,
+	if (!request_irq(host->irq, j38ms_isr, IRQF_SHARED, host->host_id,
 			 msh))
 		return msh;
 
@@ -731,19 +731,19 @@ err_out_free:
 	return NULL;
 }
 
-static void jmb38x_ms_free_host(struct memstick_host *msh)
+static void j38ms_free_host(struct memstick_host *msh)
 {
-	struct jmb38x_ms_host *host = memstick_priv(msh);
+	struct j38ms_host *host = memstick_priv(msh);
 
 	free_irq(host->irq, msh);
 	iounmap(host->addr);
 	memstick_free_host(msh);
 }
 
-static int jmb38x_ms_probe(struct pci_dev *pdev,
+static int j38ms_probe(struct pci_dev *pdev,
 			   const struct pci_device_id *dev_id)
 {
-	struct jmb38x_ms *jm;
+	struct j38ms *jm;
 	int pci_dev_busy = 0;
 	int rc, cnt;
 
@@ -766,14 +766,14 @@ static int jmb38x_ms_probe(struct pci_dev *pdev,
 	pci_read_config_dword(pdev, 0xac, &rc);
 	pci_write_config_dword(pdev, 0xac, rc | 0x00470000);
 
-	cnt = jmb38x_ms_count_slots(pdev);
+	cnt = j38ms_count_slots(pdev);
 	if (!cnt) {
 		rc = -ENODEV;
 		pci_dev_busy = 1;
 		goto err_out;
 	}
 
-	jm = kzalloc(sizeof(struct jmb38x_ms)
+	jm = kzalloc(sizeof(struct j38ms)
 		     + cnt * sizeof(struct memstick_host *), GFP_KERNEL);
 	if (!jm) {
 		rc = -ENOMEM;
@@ -785,14 +785,14 @@ static int jmb38x_ms_probe(struct pci_dev *pdev,
 	pci_set_drvdata(pdev, jm);
 
 	for (cnt = 0; cnt < jm->host_cnt; ++cnt) {
-		jm->hosts[cnt] = jmb38x_ms_alloc_host(jm, cnt);
+		jm->hosts[cnt] = j38ms_alloc_host(jm, cnt);
 		if (!jm->hosts[cnt])
 			break;
 
 		rc = memstick_add_host(jm->hosts[cnt]);
 
 		if (rc) {
-			jmb38x_ms_free_host(jm->hosts[cnt]);
+			j38ms_free_host(jm->hosts[cnt]);
 			jm->hosts[cnt] = NULL;
 			break;
 		}
@@ -813,10 +813,10 @@ err_out:
 	return rc;
 }
 
-static void jmb38x_ms_remove(struct pci_dev *dev)
+static void j38ms_remove(struct pci_dev *dev)
 {
-	struct jmb38x_ms *jm = pci_get_drvdata(dev);
-	struct jmb38x_ms_host *host;
+	struct j38ms *jm = pci_get_drvdata(dev);
+	struct j38ms_host *host;
 	int cnt;
 	unsigned long flags;
 
@@ -826,7 +826,7 @@ static void jmb38x_ms_remove(struct pci_dev *dev)
 
 		host = memstick_priv(jm->hosts[cnt]);
 
-		jm->hosts[cnt]->request = jmb38x_ms_dummy_submit;
+		jm->hosts[cnt]->request = j38ms_dummy_submit;
 		tasklet_kill(&host->notify);
 		writel(0, host->addr + INT_SIGNAL_ENABLE);
 		writel(0, host->addr + INT_STATUS_ENABLE);
@@ -835,14 +835,14 @@ static void jmb38x_ms_remove(struct pci_dev *dev)
 		spin_lock_irqsave(&host->lock, flags);
 		if (host->req) {
 			host->req->error = -ETIME;
-			jmb38x_ms_complete_cmd(jm->hosts[cnt], 1);
+			j38ms_complete_cmd(jm->hosts[cnt], 1);
 		}
 		spin_unlock_irqrestore(&host->lock, flags);
 
 		memstick_remove_host(jm->hosts[cnt]);
 		dev_dbg(&jm->pdev->dev, "host removed\n");
 
-		jmb38x_ms_free_host(jm->hosts[cnt]);
+		j38ms_free_host(jm->hosts[cnt]);
 	}
 
 	pci_set_drvdata(dev, NULL);
@@ -851,39 +851,39 @@ static void jmb38x_ms_remove(struct pci_dev *dev)
 	kfree(jm);
 }
 
-static struct pci_device_id jmb38x_ms_id_tbl [] = {
+static struct pci_device_id j38ms_id_tbl[] = {
 	{ PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB38X_MS, PCI_ANY_ID,
 	  PCI_ANY_ID, 0, 0, 0 },
 	{ }
 };
 
-static struct pci_driver jmb38x_ms_driver = {
+static struct pci_driver j38ms_driver = {
 	.name = DRIVER_NAME,
-	.id_table = jmb38x_ms_id_tbl,
-	.probe = jmb38x_ms_probe,
-	.remove = jmb38x_ms_remove,
-	.suspend = jmb38x_ms_suspend,
-	.resume = jmb38x_ms_resume
+	.id_table = j38ms_id_tbl,
+	.probe = j38ms_probe,
+	.remove = j38ms_remove,
+	.suspend = j38ms_suspend,
+	.resume = j38ms_resume
 };
 
-static int __init jmb38x_ms_init(void)
+static int __init j38ms_init(void)
 {
-	return pci_register_driver(&jmb38x_ms_driver);
+	return pci_register_driver(&j38ms_driver);
 }
 
-static void __exit jmb38x_ms_exit(void)
+static void __exit j38ms_exit(void)
 {
-	pci_unregister_driver(&jmb38x_ms_driver);
+	pci_unregister_driver(&j38ms_driver);
 }
 
 MODULE_AUTHOR("Alex Dubov");
 MODULE_DESCRIPTION("JMicron jmb38x MemoryStick driver");
 MODULE_LICENSE("GPL");
-MODULE_DEVICE_TABLE(pci, jmb38x_ms_id_tbl);
+MODULE_DEVICE_TABLE(pci, j38ms_id_tbl);
 
 module_param(no_dma, bool, S_IRUGO);
 module_param(debug, bool, S_IRUGO);
 
 
-module_init(jmb38x_ms_init);
-module_exit(jmb38x_ms_exit);
+module_init(j38ms_init);
+module_exit(j38ms_exit);
diff --git a/drivers/memstick/host/jmb38x_ms.h b/drivers/memstick/host/jmb38x_ms.h
index 5bca4b3..c64f2e1 100644
--- a/drivers/memstick/host/jmb38x_ms.h
+++ b/drivers/memstick/host/jmb38x_ms.h
@@ -142,8 +142,8 @@
 #define PCI_CTL_CLOCK_DLY_MASK_A 0x00000f00
 #define PCI_CTL_CLOCK_DLY_MASK_B 0x0000f000
 
-struct jmb38x_ms_host {
-	struct jmb38x_ms        *chip;
+struct j38ms_host {
+	struct j38ms            *chip;
 	void __iomem            *addr;
 	spinlock_t              lock;
 	struct tasklet_struct   notify;
@@ -159,7 +159,7 @@ struct jmb38x_ms_host {
 	unsigned int            io_word[2];
 };
 
-struct jmb38x_ms {
+struct j38ms {
 	struct pci_dev        *pdev;
 	int                   host_cnt;
 	struct memstick_host  *hosts[];
-- 
1.7.1

