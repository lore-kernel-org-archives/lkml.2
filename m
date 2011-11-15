Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab1KOXct (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 18:32:49 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36837 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757309Ab1KOXcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 18:32:47 -0500
From: Joe Perches <joe@perches.com>
To: Ben Dooks <ben-linux@fluff.org>, Chris Ball <cjb@laptop.org>,
        Alex Dubov <oakad@yahoo.com>, Pierre Ossman <pierre@ossman.eu>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/4] mmc: Update logging style
Date: Tue, 15 Nov 2011 15:32:05 -0800
Message-Id: <c75784ed1efa8636f7177cd5662c35fa6a8d03df.1321398814.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1321398814.git.joe@perches.com>
References: <cover.1321398814.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert pr_warning to pr_warn.
Coalesce format strings.
Align arguments.
Add missing \n.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mmc/card/block.c      |    4 +-
 drivers/mmc/card/queue.c      |    6 +---
 drivers/mmc/card/sdio_uart.c  |   10 ++++----
 drivers/mmc/core/bus.c        |    4 +-
 drivers/mmc/core/core.c       |    9 +++----
 drivers/mmc/core/mmc.c        |   28 ++++++++++--------------
 drivers/mmc/core/mmc_ops.c    |    4 +-
 drivers/mmc/core/sd.c         |   46 +++++++++++++++++------------------------
 drivers/mmc/core/sdio.c       |    5 +--
 drivers/mmc/core/sdio_bus.c   |    4 +-
 drivers/mmc/core/sdio_cis.c   |    7 ++---
 drivers/mmc/core/sdio_irq.c   |    7 ++---
 drivers/mmc/host/mmci.c       |    5 +--
 drivers/mmc/host/omap_hsmmc.c |    5 +--
 drivers/mmc/host/s3cmci.c     |    3 +-
 drivers/mmc/host/sdhci.c      |   18 +++++++---------
 drivers/mmc/host/tifm_sd.c    |    3 +-
 drivers/mmc/host/wbsd.c       |   24 ++++++++-------------
 18 files changed, 82 insertions(+), 110 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index c80bb6d..fe489b1 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -1238,8 +1238,8 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue *mq, struct request *rqc)
 		case MMC_BLK_ECC_ERR:
 			if (brq->data.blocks > 1) {
 				/* Redo read one sector at a time */
-				pr_warning("%s: retrying using single block read\n",
-					   req->rq_disk->disk_name);
+				pr_warn("%s: retrying using single block read\n",
+					req->rq_disk->disk_name);
 				disable_multi = 1;
 				break;
 			}
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index dcad59c..f1fd979 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -197,14 +197,12 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card,
 		if (bouncesz > 512) {
 			mqrq_cur->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
 			if (!mqrq_cur->bounce_buf) {
-				pr_warning("%s: unable to "
-					"allocate bounce cur buffer\n",
+				pr_warn("%s: unable to allocate bounce cur buffer\n",
 					mmc_card_name(card));
 			}
 			mqrq_prev->bounce_buf = kmalloc(bouncesz, GFP_KERNEL);
 			if (!mqrq_prev->bounce_buf) {
-				pr_warning("%s: unable to "
-					"allocate bounce prev buffer\n",
+				pr_warn("%s: unable to allocate bounce prev buffer\n",
 					mmc_card_name(card));
 				kfree(mqrq_cur->bounce_buf);
 				mqrq_cur->bounce_buf = NULL;
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 2c151e1..e264ee2 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -1082,8 +1082,8 @@ static int sdio_uart_probe(struct sdio_func *func,
 		return -ENOMEM;
 
 	if (func->class == SDIO_CLASS_UART) {
-		pr_warning("%s: need info on UART class basic setup\n",
-		       sdio_func_id(func));
+		pr_warn("%s: need info on UART class basic setup\n",
+			sdio_func_id(func));
 		kfree(port);
 		return -ENOSYS;
 	} else if (func->class == SDIO_CLASS_GPS) {
@@ -1101,9 +1101,9 @@ static int sdio_uart_probe(struct sdio_func *func,
 				break;
 		}
 		if (!tpl) {
-			pr_warning(
-       "%s: can't find tuple 0x91 subtuple 0 (SUBTPL_SIOREG) for GPS class\n",
-			       sdio_func_id(func));
+			pr_warn(
+	"%s: can't find tuple 0x91 subtuple 0 (SUBTPL_SIOREG) for GPS class\n",
+				sdio_func_id(func));
 			kfree(port);
 			return -EINVAL;
 		}
diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
index 6be4924..2e1f028 100644
--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -303,10 +303,10 @@ int mmc_add_card(struct mmc_card *card)
 			mmc_card_ddr_mode(card) ? "DDR " : "",
 			type);
 	} else {
-		printk(KERN_INFO "%s: new %s%s%s card at address %04x\n",
+		pr_info("%s: new %s%s%s card at address %04x\n",
 			mmc_hostname(card->host),
 			mmc_sd_card_uhs(card) ? "ultra high speed " :
-			(mmc_card_highspeed(card) ? "high speed " : ""),
+			mmc_card_highspeed(card) ? "high speed " : "",
 			mmc_card_ddr_mode(card) ? "DDR " : "",
 			type, card->rca);
 	}
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 74a012a..54d6a13 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1163,8 +1163,8 @@ u32 mmc_select_voltage(struct mmc_host *host, u32 ocr)
 		mmc_set_ios(host);
 		mmc_host_clk_release(host);
 	} else {
-		pr_warning("%s: host doesn't support card's voltages\n",
-				mmc_hostname(host));
+		pr_warn("%s: host doesn't support card's voltages\n",
+			mmc_hostname(host));
 		ocr = 0;
 	}
 
@@ -2375,9 +2375,8 @@ int mmc_resume_host(struct mmc_host *host)
 		BUG_ON(!host->bus_ops->resume);
 		err = host->bus_ops->resume(host);
 		if (err) {
-			pr_warning("%s: error %d during resume "
-					    "(card was removed?)\n",
-					    mmc_hostname(host), err);
+			pr_warn("%s: error %d during resume (card was removed?)\n",
+				mmc_hostname(host), err);
 			err = 0;
 		}
 	}
diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
index 90de9ba..bbd7adb 100644
--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -223,9 +223,7 @@ static int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd)
 				"Card will be ignored.\n",
 				mmc_hostname(card->host));
 		} else {
-			pr_warning("%s: unable to read "
-				"EXT_CSD, performance might "
-				"suffer.\n",
+			pr_warn("%s: unable to read EXT_CSD, performance might suffer\n",
 				mmc_hostname(card->host));
 			err = 0;
 		}
@@ -309,8 +307,7 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
 		break;
 	default:
 		/* MMC v4 spec says this cannot happen */
-		pr_warning("%s: card is mmc v4 but doesn't "
-			"support any high-speed modes.\n",
+		pr_warn("%s: card is mmc v4 but doesn't support any high-speed modes\n",
 			mmc_hostname(card->host));
 	}
 
@@ -664,8 +661,8 @@ static int mmc_select_powerclass(struct mmc_card *card,
 			index = EXT_CSD_PWR_CL_200_360;
 		break;
 	default:
-		pr_warning("%s: Voltage range not supported "
-			   "for power class.\n", mmc_hostname(host));
+		pr_warn("%s: Voltage range not supported for power class\n",
+			mmc_hostname(host));
 		return -EINVAL;
 	}
 
@@ -904,8 +901,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 			goto free_card;
 
 		if (err) {
-			pr_warning("%s: switch to highspeed failed\n",
-			       mmc_hostname(card->host));
+			pr_warn("%s: switch to highspeed failed\n",
+				mmc_hostname(card->host));
 			err = 0;
 		} else {
 			mmc_card_set_highspeed(card);
@@ -922,8 +919,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 		if (err && err != -EBADMSG)
 			goto free_card;
 		if (err) {
-			pr_warning("%s: Enabling HPI failed\n",
-				   mmc_hostname(card->host));
+			pr_warn("%s: Enabling HPI failed\n",
+				mmc_hostname(card->host));
 			err = 0;
 		} else
 			card->ext_csd.hpi_en = 1;
@@ -1029,8 +1026,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
 					 card->ext_csd.generic_cmd6_time);
 		}
 		if (err) {
-			pr_warning("%s: switch to bus width %d ddr %d "
-				"failed\n", mmc_hostname(card->host),
+			pr_warn("%s: switch to bus width %d ddr %d failed\n",
+				mmc_hostname(card->host),
 				1 << bus_width, ddr);
 			goto free_card;
 		} else if (ddr) {
@@ -1284,9 +1281,8 @@ int mmc_attach_mmc(struct mmc_host *host)
 	 * support.
 	 */
 	if (ocr & 0x7F) {
-		pr_warning("%s: card claims to support voltages "
-		       "below the defined range. These will be ignored.\n",
-		       mmc_hostname(host));
+		pr_warn("%s: card claims to support voltages below the defined range. These will be ignored.\n",
+			mmc_hostname(host));
 		ocr &= ~0x7F;
 	}
 
diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
index 4d41fa9..32deb3e 100644
--- a/drivers/mmc/core/mmc_ops.c
+++ b/drivers/mmc/core/mmc_ops.c
@@ -415,8 +415,8 @@ int mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
 			return -EBADMSG;
 	} else {
 		if (status & 0xFDFFA000)
-			pr_warning("%s: unexpected status %#x after "
-			       "switch", mmc_hostname(card->host), status);
+			pr_warn("%s: unexpected status %#x after switch\n",
+				mmc_hostname(card->host), status);
 		if (status & R1_SWITCH_ERROR)
 			return -EBADMSG;
 	}
diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index f54392c..52a1563 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -219,8 +219,8 @@ static int mmc_read_ssr(struct mmc_card *card)
 	u32 *ssr;
 
 	if (!(card->csd.cmdclass & CCC_APP_SPEC)) {
-		pr_warning("%s: card lacks mandatory SD Status "
-			"function.\n", mmc_hostname(card->host));
+		pr_warn("%s: card lacks mandatory SD Status function\n",
+			mmc_hostname(card->host));
 		return 0;
 	}
 
@@ -230,8 +230,8 @@ static int mmc_read_ssr(struct mmc_card *card)
 
 	err = mmc_app_sd_status(card, ssr);
 	if (err) {
-		pr_warning("%s: problem reading SD Status "
-			"register.\n", mmc_hostname(card->host));
+		pr_warn("%s: problem reading SD Status register\n",
+			mmc_hostname(card->host));
 		err = 0;
 		goto out;
 	}
@@ -254,8 +254,8 @@ static int mmc_read_ssr(struct mmc_card *card)
 			card->ssr.erase_offset = eo * 1000;
 		}
 	} else {
-		pr_warning("%s: SD Status: Invalid Allocation Unit "
-			"size.\n", mmc_hostname(card->host));
+		pr_warn("%s: SD Status: Invalid Allocation Unit size\n",
+			mmc_hostname(card->host));
 	}
 out:
 	kfree(ssr);
@@ -274,8 +274,7 @@ static int mmc_read_switch(struct mmc_card *card)
 		return 0;
 
 	if (!(card->csd.cmdclass & CCC_SWITCH)) {
-		pr_warning("%s: card lacks mandatory switch "
-			"function, performance might suffer.\n",
+		pr_warn("%s: card lacks mandatory switch function, performance might suffer\n",
 			mmc_hostname(card->host));
 		return 0;
 	}
@@ -300,7 +299,7 @@ static int mmc_read_switch(struct mmc_card *card)
 		if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
 			goto out;
 
-		pr_warning("%s: problem reading Bus Speed modes.\n",
+		pr_warn("%s: problem reading Bus Speed modes.\n",
 			mmc_hostname(card->host));
 		err = 0;
 
@@ -323,8 +322,7 @@ static int mmc_read_switch(struct mmc_card *card)
 			if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
 				goto out;
 
-			pr_warning("%s: problem reading "
-				"Driver Strength.\n",
+			pr_warn("%s: problem reading Driver Strength\n",
 				mmc_hostname(card->host));
 			err = 0;
 
@@ -343,8 +341,7 @@ static int mmc_read_switch(struct mmc_card *card)
 			if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
 				goto out;
 
-			pr_warning("%s: problem reading "
-				"Current Limit.\n",
+			pr_warn("%s: problem reading Current Limit\n",
 				mmc_hostname(card->host));
 			err = 0;
 
@@ -394,8 +391,7 @@ int mmc_sd_switch_hs(struct mmc_card *card)
 		goto out;
 
 	if ((status[16] & 0xF) != 1) {
-		pr_warning("%s: Problem switching card "
-			"into high-speed mode!\n",
+		pr_warn("%s: Problem switching card into high-speed mode!\n",
 			mmc_hostname(card->host));
 		err = 0;
 	} else {
@@ -460,7 +456,7 @@ static int sd_select_driver_type(struct mmc_card *card, u8 *status)
 		return err;
 
 	if ((status[15] & 0xF) != drive_strength) {
-		pr_warning("%s: Problem setting drive strength!\n",
+		pr_warn("%s: Problem setting drive strength!\n",
 			mmc_hostname(card->host));
 		return 0;
 	}
@@ -539,7 +535,7 @@ static int sd_set_bus_speed_mode(struct mmc_card *card, u8 *status)
 		return err;
 
 	if ((status[16] & 0xF) != card->sd_bus_speed)
-		pr_warning("%s: Problem setting bus speed mode!\n",
+		pr_warn("%s: Problem setting bus speed mode!\n",
 			mmc_hostname(card->host));
 	else {
 		mmc_set_timing(card->host, timing);
@@ -601,7 +597,7 @@ static int sd_set_current_limit(struct mmc_card *card, u8 *status)
 		return err;
 
 	if (((status[15] >> 4) & 0x0F) != current_limit)
-		pr_warning("%s: Problem setting current limit!\n",
+		pr_warn("%s: Problem setting current limit!\n",
 			mmc_hostname(card->host));
 
 	return 0;
@@ -853,9 +849,7 @@ int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
 			ro = host->ops->get_ro(host);
 
 		if (ro < 0) {
-			pr_warning("%s: host does not "
-				"support reading read-only "
-				"switch. assuming write-enable.\n",
+			pr_warn("%s: host does not support reading read-only switch. assuming write-enable.\n",
 				mmc_hostname(host));
 		} else if (ro > 0) {
 			mmc_card_set_readonly(card);
@@ -1167,17 +1161,15 @@ int mmc_attach_sd(struct mmc_host *host)
 	 * support.
 	 */
 	if (ocr & 0x7F) {
-		pr_warning("%s: card claims to support voltages "
-		       "below the defined range. These will be ignored.\n",
-		       mmc_hostname(host));
+		pr_warn("%s: card claims to support voltages below the defined range. These will be ignored.\n",
+			mmc_hostname(host));
 		ocr &= ~0x7F;
 	}
 
 	if ((ocr & MMC_VDD_165_195) &&
 	    !(host->ocr_avail_sd & MMC_VDD_165_195)) {
-		pr_warning("%s: SD card claims to support the "
-		       "incompletely defined 'low voltage range'. This "
-		       "will be ignored.\n", mmc_hostname(host));
+		pr_warn("%s: SD card claims to support the incompletely defined 'low voltage range'. This will be ignored.\n",
+			mmc_hostname(host));
 		ocr &= ~MMC_VDD_165_195;
 	}
 
diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 3ab565e..e994a89 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -777,9 +777,8 @@ int mmc_attach_sdio(struct mmc_host *host)
 	 * support.
 	 */
 	if (ocr & 0x7F) {
-		pr_warning("%s: card claims to support voltages "
-		       "below the defined range. These will be ignored.\n",
-		       mmc_hostname(host));
+		pr_warn("%s: card claims to support voltages below the defined range. These will be ignored.\n",
+			mmc_hostname(host));
 		ocr &= ~0x7F;
 	}
 
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index 40989e6..3d82f12 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -174,8 +174,8 @@ static int sdio_bus_remove(struct device *dev)
 	drv->remove(func);
 
 	if (func->irq_handler) {
-		pr_warning("WARNING: driver %s did not remove "
-			"its interrupt handler!\n", drv->name);
+		pr_warn("WARNING: driver %s did not remove its interrupt handler!\n",
+			drv->name);
 		sdio_claim_host(func);
 		sdio_release_irq(func);
 		sdio_release_host(func);
diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index f1c7ed8..6536fce 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -313,10 +313,9 @@ static int sdio_read_cis(struct mmc_card *card, struct sdio_func *func)
 
 			if (ret == -ENOENT) {
 				/* warn about unknown tuples */
-				pr_warning("%s: queuing unknown"
-				       " CIS tuple 0x%02x (%u bytes)\n",
-				       mmc_hostname(card->host),
-				       tpl_code, tpl_link);
+				pr_warn("%s: queuing unknown CIS tuple 0x%02x (%u bytes)\n",
+					mmc_hostname(card->host),
+					tpl_code, tpl_link);
 			}
 
 			/* keep on analyzing tuples */
diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
index 68f81b9..bc9e67a 100644
--- a/drivers/mmc/core/sdio_irq.c
+++ b/drivers/mmc/core/sdio_irq.c
@@ -56,16 +56,15 @@ static int process_sdio_pending_irqs(struct mmc_card *card)
 		if (pending & (1 << i)) {
 			func = card->sdio_func[i - 1];
 			if (!func) {
-				pr_warning("%s: pending IRQ for "
-					"non-existent function\n",
+				pr_warn("%s: pending IRQ for non-existent function\n",
 					mmc_card_id(card));
 				ret = -EINVAL;
 			} else if (func->irq_handler) {
 				func->irq_handler(func);
 				count++;
 			} else {
-				pr_warning("%s: pending IRQ with no handler\n",
-				       sdio_func_id(func));
+				pr_warn("%s: pending IRQ with no handler\n",
+					sdio_func_id(func));
 				ret = -EINVAL;
 			}
 		}
diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 50b5f99..0ea9935 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -466,9 +466,8 @@ static void mmci_get_next_data(struct mmci_host *host, struct mmc_data *data)
 	struct mmci_host_next *next = &host->next_data;
 
 	if (data->host_cookie && data->host_cookie != next->cookie) {
-		pr_warning("[%s] invalid cookie: data->host_cookie %d"
-		       " host->next_data.cookie %d\n",
-		       __func__, data->host_cookie, host->next_data.cookie);
+		pr_warn("[%s] invalid cookie: data->host_cookie %d host->next_data.cookie %d\n",
+			__func__, data->host_cookie, host->next_data.cookie);
 		data->host_cookie = 0;
 	}
 
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index d5fe43d..1455bd6 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1422,9 +1422,8 @@ static int omap_hsmmc_pre_dma_transfer(struct omap_hsmmc_host *host,
 
 	if (!next && data->host_cookie &&
 	    data->host_cookie != host->next_data.cookie) {
-		pr_warning("[%s] invalid cookie: data->host_cookie %d"
-		       " host->next_data.cookie %d\n",
-		       __func__, data->host_cookie, host->next_data.cookie);
+		pr_warn("[%s] invalid cookie: data->host_cookie %d host->next_data.cookie %d\n",
+			__func__, data->host_cookie, host->next_data.cookie);
 		data->host_cookie = 0;
 	}
 
diff --git a/drivers/mmc/host/s3cmci.c b/drivers/mmc/host/s3cmci.c
index 720f993..6da27c0 100644
--- a/drivers/mmc/host/s3cmci.c
+++ b/drivers/mmc/host/s3cmci.c
@@ -983,7 +983,8 @@ static int s3cmci_setup_data(struct s3cmci_host *host, struct mmc_data *data)
 		 * one block being transferred. */
 
 		if (data->blocks > 1) {
-			pr_warning("%s: can't do non-word sized block transfers (blksz %d)\n", __func__, data->blksz);
+			pr_warn("%s: can't do non-word sized block transfers (blksz %d)\n",
+				__func__, data->blksz);
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index a7c2311..d146bff 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -677,8 +677,8 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
 	}
 
 	if (count >= 0xF) {
-		pr_warning("%s: Too large timeout requested for CMD%d!\n",
-		       mmc_hostname(host->mmc), cmd->opcode);
+		pr_warn("%s: Too large timeout requested for CMD%d!\n",
+			mmc_hostname(host->mmc), cmd->opcode);
 		count = 0xE;
 	}
 
@@ -2237,8 +2237,8 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 
 	if (host->runtime_suspended) {
 		spin_unlock(&host->lock);
-		pr_warning("%s: got irq while runtime suspended\n",
-		       mmc_hostname(host->mmc));
+		pr_warn("%s: got irq while runtime suspended\n",
+			mmc_hostname(host->mmc));
 		return IRQ_HANDLED;
 	}
 
@@ -2585,8 +2585,7 @@ int sdhci_add_host(struct sdhci_host *host)
 	if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
 		if (host->ops->enable_dma) {
 			if (host->ops->enable_dma(host)) {
-				pr_warning("%s: No suitable DMA "
-					"available. Falling back to PIO.\n",
+				pr_warn("%s: No suitable DMA available. Falling back to PIO.\n",
 					mmc_hostname(mmc));
 				host->flags &=
 					~(SDHCI_USE_SDMA | SDHCI_USE_ADMA);
@@ -2605,8 +2604,7 @@ int sdhci_add_host(struct sdhci_host *host)
 		if (!host->adma_desc || !host->align_buffer) {
 			kfree(host->adma_desc);
 			kfree(host->align_buffer);
-			pr_warning("%s: Unable to allocate ADMA "
-				"buffers. Falling back to standard DMA.\n",
+			pr_warn("%s: Unable to allocate ADMA buffers. Falling back to standard DMA.\n",
 				mmc_hostname(mmc));
 			host->flags &= ~SDHCI_USE_ADMA;
 		}
@@ -2895,8 +2893,8 @@ int sdhci_add_host(struct sdhci_host *host)
 		mmc->max_blk_size = (caps[0] & SDHCI_MAX_BLOCK_MASK) >>
 				SDHCI_MAX_BLOCK_SHIFT;
 		if (mmc->max_blk_size >= 3) {
-			pr_warning("%s: Invalid maximum block size, "
-				"assuming 512 bytes\n", mmc_hostname(mmc));
+			pr_warn("%s: Invalid maximum block size, assuming 512 bytes\n",
+				mmc_hostname(mmc));
 			mmc->max_blk_size = 0;
 		}
 	}
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index f70d046..55d6c60 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -952,8 +952,7 @@ static int tifm_sd_probe(struct tifm_dev *sock)
 
 	if (!(TIFM_SOCK_STATE_OCCUPIED
 	      & readl(sock->addr + SOCK_PRESENT_STATE))) {
-		pr_warning("%s : card gone, unexpectedly\n",
-		       dev_name(&sock->dev));
+		pr_warn("%s : card gone, unexpectedly\n", dev_name(&sock->dev));
 		return rc;
 	}
 
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 64acd9c..a4944c8e 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -803,8 +803,7 @@ static void wbsd_request(struct mmc_host *mmc, struct mmc_request *mrq)
 
 		default:
 #ifdef CONFIG_MMC_DEBUG
-			pr_warning("%s: Data command %d is not "
-				"supported by this controller.\n",
+			pr_warn("%s: Data command %d is not supported by this controller\n",
 				mmc_hostname(host->mmc), cmd->opcode);
 #endif
 			cmd->error = -EINVAL;
@@ -1429,8 +1428,8 @@ free:
 	free_dma(dma);
 
 err:
-	pr_warning(DRIVER_NAME ": Unable to allocate DMA %d. "
-		"Falling back on FIFO.\n", dma);
+	pr_warn(DRIVER_NAME ": Unable to allocate DMA %d. Falling back on FIFO.\n",
+		dma);
 }
 
 static void wbsd_release_dma(struct wbsd_host *host)
@@ -1664,9 +1663,8 @@ static int __devinit wbsd_init(struct device *dev, int base, int irq, int dma,
 	ret = wbsd_scan(host);
 	if (ret) {
 		if (pnp && (ret == -ENODEV)) {
-			pr_warning(DRIVER_NAME
-				": Unable to confirm device presence. You may "
-				"experience lock-ups.\n");
+			pr_warn(DRIVER_NAME
+				": Unable to confirm device presence. You may experience lock-ups.\n");
 		} else {
 			wbsd_free_mmc(dev);
 			return ret;
@@ -1688,10 +1686,8 @@ static int __devinit wbsd_init(struct device *dev, int base, int irq, int dma,
 	 */
 	if (pnp) {
 		if ((host->config != 0) && !wbsd_chip_validate(host)) {
-			pr_warning(DRIVER_NAME
-				": PnP active but chip not configured! "
-				"You probably have a buggy BIOS. "
-				"Configuring chip manually.\n");
+			pr_warn(DRIVER_NAME
+				": PnP active but chip not configured! You probably have a buggy BIOS. Configuring chip manually.\n");
 			wbsd_chip_config(host);
 		}
 	} else
@@ -1909,10 +1905,8 @@ static int wbsd_pnp_resume(struct pnp_dev *pnp_dev)
 	 */
 	if (host->config != 0) {
 		if (!wbsd_chip_validate(host)) {
-			pr_warning(DRIVER_NAME
-				": PnP active but chip not configured! "
-				"You probably have a buggy BIOS. "
-				"Configuring chip manually.\n");
+			pr_warn(DRIVER_NAME
+				": PnP active but chip not configured! You probably have a buggy BIOS. Configuring chip manually.\n");
 			wbsd_chip_config(host);
 		}
 	}
-- 
1.7.6.405.gc1be0

