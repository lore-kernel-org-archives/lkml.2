Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661Ab1D1Ssx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 14:48:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49009 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab1D1Ssu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 14:48:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=ibvDADtVz0jwSOuGJ0PRzt82lBDkmzIGHpXbuOwd2wWKKHu9pasqjfaMCVxuxsNkes
         991WUl6eU8lKRZWhGTyN04ygrQX/aqKcREUG7D9ldBQu8lgGKSmElvvtO5sg38rTiadN
         poaY9akbKLNZUZi8J2smRes944at6cePsxXjQ=
Subject: [PATCH] Staging: Westbridge: replace custom debug macros with
 pr_...() macros
From: Sutharsan <sutharsan.tech@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, david.cross@cypress.com, srmt@cypress.com
Content-Type: text/plain
Date: Thu, 28 Apr 2011 11:48:41 -0700
Message-Id: <1304016521.3749.13.camel@sutharsan-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From Sutharsan Ramamoorthy <srmt@cypress.com>

This patch replaces custom debug macros with Linux kernel's pr_...() macros.

Signed-off-by: Sutharsan Ramamoorthy <srmt@cypress.com>

---

diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyasintr.c linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyasintr.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyasintr.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyasintr.c	2011-04-26 10:40:24.330654568 -0700
@@ -112,7 +112,7 @@ void cy_as_intr_service_interrupt(cy_as_
 			v = cy_as_hal_read_register(tag,
 				CY_AS_MEM_PWR_MAGT_STAT);
 		} else
-			cy_as_hal_print_message("stray antioch "
+			pr_err("stray antioch "
 				"interrupt detected"
 				", tag not associated "
 				"with any created device.");
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyaslowlevel.c	2011-04-26 10:45:20.142122605 -0700
@@ -238,7 +238,7 @@ cy_as_ll_queue_mailbox_data(cy_as_device
 
 	context = cy_as_mbox_get_context(data[0]);
 	if (context >= CY_RQT_CONTEXT_COUNT) {
-		cy_as_hal_print_message("mailbox request/response received "
+		pr_err("mailbox request/response received "
 			"with invalid context value (%d)\n", context);
 		return;
 	}
@@ -270,7 +270,7 @@ cy_as_mail_box_process_data(cy_as_device
 
 	context = cy_as_mbox_get_context(data[0]);
 	if (context >= CY_RQT_CONTEXT_COUNT) {
-		cy_as_hal_print_message("mailbox request/response received "
+		pr_err("mailbox request/response received "
 		"with invalid context value (%d)\n", context);
 		return;
 	}
@@ -286,14 +286,14 @@ cy_as_mail_box_process_data(cy_as_device
 		if (ctxt_p->request_queue_p == 0 ||
 			cy_as_request_get_node_state(ctxt_p->request_queue_p)
 			!= CY_AS_REQUEST_LIST_STATE_WAITING) {
-			cy_as_hal_print_message("mailbox response received on "
+			pr_err("mailbox response received on "
 				"context that was not expecting a response\n");
-			cy_as_hal_print_message("  context: %d\n", context);
-			cy_as_hal_print_message("  contents: 0x%04x 0x%04x "
+			pr_err("  context: %d\n", context);
+			pr_err("  contents: 0x%04x 0x%04x "
 				"0x%04x 0x%04x\n",
 				data[0], data[1], data[2], data[3]);
 			if (ctxt_p->request_queue_p != 0)
-				cy_as_hal_print_message("  state: 0x%02x\n",
+				pr_debug("  state: 0x%02x\n",
 					ctxt_p->request_queue_p->state);
 			return;
 		}
@@ -762,7 +762,7 @@ cy_as_send_one(
 			} while (v && loopcount-- > 0);
 
 			if (v) {
-				cy_as_hal_print_message(
+				pr_err(
 					">>>>>> LOW LEVEL TIMEOUT "
 					"%x %x %x %x\n",
 					cy_as_hal_read_register(dev_p->tag,
@@ -851,8 +851,7 @@ check_mailbox_availability:
 		} while (v && loopcount-- > 0);
 
 		if (v) {
-			cy_as_hal_print_message(
-				">>>>>> LOW LEVEL TIMEOUT %x %x %x %x\n",
+			pr_err(">>>>>> LOW LEVEL TIMEOUT %x %x %x %x\n",
 				cy_as_hal_read_register(dev_p->tag,
 					CY_AS_MEM_MCU_MAILBOX0),
 				cy_as_hal_read_register(dev_p->tag,
@@ -1230,7 +1229,7 @@ cy_as_ll_remove_ep_data_requests(cy_as_d
 			(ctxt_p->request_queue_p->rqt, ep) &&
 			cy_as_request_get_node_state(ctxt_p->request_queue_p) ==
 			CY_AS_REQUEST_LIST_STATE_WAITING) {
-			cy_as_hal_print_message("need to remove an in-transit "
+			pr_warn("need to remove an in-transit "
 				"request to antioch\n");
 
 			/*
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyasmisc.c linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyasmisc.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyasmisc.c	2011-04-27 08:06:28.270424392 -0700
@@ -57,7 +57,7 @@ void
 cy_as_log_debug_message(int level, const char *str)
 {
 	if (level <= debug_level)
-		cy_as_hal_print_message("log %d: %s\n", level, str);
+		pr_debug("log %d: %s\n", level, str);
 }
 
 #endif
@@ -426,7 +426,7 @@ my_misc_callback(cy_as_device *dev_p, ui
 				CY_AS_MEM_P0_VM_SET);
 
 				if (v & CY_AS_MEM_P0_VM_SET_CFGMODE)
-					cy_as_hal_print_message(
+					pr_warn(
 					"initialization message "
 					"recieved, but config bit "
 					"still set\n");
@@ -434,7 +434,7 @@ my_misc_callback(cy_as_device *dev_p, ui
 				v = cy_as_hal_read_register(dev_p->tag,
 					CY_AS_MEM_RST_CTRL_REG);
 				if ((v & CY_AS_MEM_RST_RSTCMPT) == 0)
-					cy_as_hal_print_message(
+					pr_warn(
 					"initialization message "
 					"recieved, but reset complete "
 					"bit still not set\n");
@@ -478,7 +478,7 @@ my_misc_callback(cy_as_device *dev_p, ui
 				dev_p->misc_event_cb((cy_as_device_handle)dev_p,
 					cy_as_event_misc_heart_beat, 0);
 		} else {
-			cy_as_hal_print_message(
+			pr_debug(
 				"**** debug message: %02x "
 				"%02x %02x %02x %02x %02x\n",
 				req_p->data[0] & 0xff,
@@ -502,7 +502,7 @@ my_misc_callback(cy_as_device *dev_p, ui
 		{
 			/* TODO Handle case when firmware is
 			 * not found during bootloading. */
-			cy_as_hal_print_message("no firmware image found "
+			pr_err("no firmware image found "
 			"during bootload. device not started\n");
 		}
 		break;
@@ -2394,7 +2394,7 @@ try_wakeup_again:
 	}
 
 	if (v & 0x03) {
-		cy_as_hal_print_message("failed to clear antioch reset\n");
+		pr_err("failed to clear antioch reset\n");
 		return CY_AS_ERROR_TIMEOUT;
 	}
 
@@ -3222,7 +3222,7 @@ void my_print_func_c_b_node(cy_as_func_c
 {
 	cy_as_funct_c_b_type type =
 		cy_as_funct_c_b_type_get_type(node->data_type);
-	cy_as_hal_print_message("[cd:%2u dt:%2u cb:0x%08x "
+	pr_info("[cd:%2u dt:%2u cb:0x%08x "
 		"d:0x%08x nt:%1i]", node->client_data, type,
 		(uint32_t)node->cb_p, (uint32_t)node->data,
 		node->node_type);
@@ -3232,38 +3232,38 @@ void my_print_c_b_queue(cy_as_c_b_queue 
 {
 	uint32_t i = 0;
 
-	cy_as_hal_print_message("| count: %u type: ", queue_p->count);
+	pr_debug("| count: %u type: ", queue_p->count);
 
 	if (queue_p->type == CYAS_USB_FUNC_CB) {
-		cy_as_hal_print_message("USB_FUNC_CB\n");
+		pr_info("USB_FUNC_CB\n");
 	} else if (queue_p->type == CYAS_USB_IO_CB) {
-		cy_as_hal_print_message("USB_IO_CB\n");
+		pr_info("USB_IO_CB\n");
 	} else if (queue_p->type == CYAS_STORAGE_IO_CB) {
-		cy_as_hal_print_message("STORAGE_IO_CB\n");
+		pr_info("STORAGE_IO_CB\n");
 	} else if (queue_p->type == CYAS_FUNC_CB) {
 		cy_as_func_c_b_node *node = queue_p->head_p;
-		cy_as_hal_print_message("FUNC_CB\n");
+		pr_info("FUNC_CB\n");
 		if (queue_p->count > 0) {
-			cy_as_hal_print_message("| head->");
+			pr_info("| head->");
 
 			for (i = 0; i < queue_p->count; i++) {
 				if (node) {
-					cy_as_hal_print_message("->");
+					pr_info("->");
 					my_print_func_c_b_node(node);
 					node = node->next_p;
 				} else
-					cy_as_hal_print_message("->[NULL]\n");
+					pr_info("->[NULL]\n");
 			}
 
-			cy_as_hal_print_message("\n| tail->");
+			pr_info("\n| tail->");
 			my_print_func_c_b_node(queue_p->tail_p);
-			cy_as_hal_print_message("\n");
+			pr_info("\n");
 		}
 	} else {
-		cy_as_hal_print_message("INVALID\n");
+		pr_warn("INVALID\n");
 	}
 
-	cy_as_hal_print_message("|----------\n");
+	pr_info("|----------\n");
 }
 
 
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyasmtp.c linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyasmtp.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyasmtp.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyasmtp.c	2011-04-26 22:13:22.142198197 -0700
@@ -144,7 +144,7 @@ my_mtp_request_callback(cy_as_device *de
 			}
 			break;
 		default:
-			cy_as_hal_print_message("invalid event type\n");
+			pr_warn("invalid event type\n");
 			cy_as_ll_send_data_response(dev_p,
 				CY_RQT_TUR_RQT_CONTEXT,
 				CY_RESP_MTP_INVALID_EVENT,
@@ -218,7 +218,7 @@ my_mtp_request_callback(cy_as_device *de
 		break;
 
 	default:
-		cy_as_hal_print_message("invalid request received "
+		pr_warn("invalid request received "
 				"on TUR context\n");
 		val = req_p->box0;
 		cy_as_ll_send_data_response(dev_p, CY_RQT_TUR_RQT_CONTEXT,
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyasstorage.c linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyasstorage.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyasstorage.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyasstorage.c	2011-04-26 22:14:17.274696266 -0700
@@ -309,7 +309,7 @@ my_storage_request_callback(cy_as_device
 		break;
 
 	default:
-		cy_as_hal_print_message("invalid request received "
+		pr_warn("invalid request received "
 			"on storage context\n");
 		val = req_p->box0;
 		cy_as_ll_send_data_response(dev_p, CY_RQT_STORAGE_RQT_CONTEXT,
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyasusb.c linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyasusb.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/api/src/cyasusb.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/api/src/cyasusb.c	2011-04-26 22:17:22.730446834 -0700
@@ -226,7 +226,7 @@ my_usb_request_callback_usb_event(cy_as_
 		break;
 
 	default:
-		cy_as_hal_print_message("invalid event type\n");
+		pr_warn("invalid event type\n");
 		cy_as_ll_send_data_response(dev_p, CY_RQT_USB_RQT_CONTEXT,
 			CY_RESP_USB_INVALID_EVENT, sizeof(ev), &ev);
 		break;
@@ -390,7 +390,7 @@ my_usb_request_callback_inquiry(cy_as_de
 	}
 
 	if (updated && length > 192)
-		cy_as_hal_print_message("an inquiry result from a "
+		pr_warn("an inquiry result from a "
 			"cy_as_event_usb_inquiry_before event "
 			"was greater than 192 bytes.");
 
@@ -624,7 +624,7 @@ my_usb_request_callback(cy_as_device *de
 		break;
 
 	default:
-		cy_as_hal_print_message("invalid request "
+		pr_warn("invalid request "
 			"received on USB context\n");
 		val = req_p->box0;
 		cy_as_ll_send_data_response(dev_p, CY_RQT_USB_RQT_CONTEXT,
@@ -2115,15 +2115,15 @@ cy_as_usb_commit_config(cy_as_device_han
 	if (req_p == 0)
 		return CY_AS_ERROR_OUT_OF_MEMORY;
 
-	cy_as_hal_print_message("USB configuration: %d\n",
+	pr_debug("USB configuration: %d\n",
 		dev_p->usb_phy_config);
-	cy_as_hal_print_message("EP1OUT: 0x%02x EP1IN: 0x%02x\n",
+	pr_debug("EP1OUT: 0x%02x EP1IN: 0x%02x\n",
 		dev_p->usb_ep1cfg[0], dev_p->usb_ep1cfg[1]);
-	cy_as_hal_print_message("PEP registers: 0x%02x 0x%02x 0x%02x 0x%02x\n",
+	pr_debug("PEP registers: 0x%02x 0x%02x 0x%02x 0x%02x\n",
 		dev_p->usb_pepcfg[0], dev_p->usb_pepcfg[1],
 		dev_p->usb_pepcfg[2], dev_p->usb_pepcfg[3]);
 
-	cy_as_hal_print_message("LEP registers: 0x%02x 0x%02x 0x%02x "
+	pr_debug("LEP registers: 0x%02x 0x%02x 0x%02x "
 		"0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x 0x%02x\n",
 		dev_p->usb_lepcfg[0], dev_p->usb_lepcfg[1],
 		dev_p->usb_lepcfg[2], dev_p->usb_lepcfg[3],
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c linux-2.6.39/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/arch/arm/mach-omap2/cyashalomap_kernel.c	2011-04-27 08:10:39.526174551 -0700
@@ -229,13 +229,13 @@ static void cy_as_hal_print_omap_regs(ch
 {
 	u32 reg_val, reg_addr;
 	u16 i;
-	cy_as_hal_print_message(KERN_INFO "\n");
+	pr_debug("\n");
 	for (i = 0; i < count; i++) {
 
 		reg_addr = virt_base + (i*4);
 		/* use virtual addresses here*/
 		reg_val = __raw_readl(reg_addr);
-		cy_as_hal_print_message(KERN_INFO "%s_%d[%8.8x]=%8.8x\n",
+		pr_debug("%s_%d[%8.8x]=%8.8x\n",
 						name_prefix, name_base+i,
 						reg_addr, reg_val);
 	}
@@ -254,17 +254,15 @@ static u16 omap_cfg_reg_L(u32 pad_func_i
 	/*
 	 * do sanity check on the omap_mux_pin_cfg[] table
 	 */
-	cy_as_hal_print_message(KERN_INFO" OMAP pins user_pad cfg ");
+	pr_debug(" OMAP pins user_pad cfg ");
 	if (sanity_check) {
 		if ((omap_mux_pin_cfg[END_OF_TABLE].name[0] == 'E') &&
 			(omap_mux_pin_cfg[END_OF_TABLE].name[1] == 'N') &&
 			(omap_mux_pin_cfg[END_OF_TABLE].name[2] == 'D')) {
 
-			cy_as_hal_print_message(KERN_INFO
-					"table is good.\n");
+			pr_debug("table is good.\n");
 		} else {
-			cy_as_hal_print_message(KERN_WARNING
-					"table is bad, fix it");
+			pr_debug("table is bad, fix it");
 		}
 		/*
 		 * do it only once
@@ -364,7 +362,7 @@ static int cy_as_hal_gpmc_init(void)
 	 * request GPMC CS for ASTORIA request
 	 */
 	if (gpmc_cs_request(AST_GPMC_CS, SZ_16M, (void *)&csa_phy) < 0) {
-		cy_as_hal_print_message(KERN_ERR "error failed to request"
+		pr_err("error failed to request"
 					"ncs4 for ASTORIA\n");
 			return -1;
 	} else {
@@ -381,7 +379,7 @@ static int cy_as_hal_gpmc_init(void)
 	 */
 	if (!request_mem_region(csa_phy, BLKSZ_4K, "AST_OMAP_HAL")) {
 		err = -EBUSY;
-		cy_as_hal_print_message(KERN_ERR "error MEM region "
+		pr_debug(KERN_ERR "error MEM region "
 					"request for phy_addr:%x failed\n",
 					csa_phy);
 			goto out_free_cs;
@@ -393,12 +391,12 @@ static int cy_as_hal_gpmc_init(void)
 	gpmc_data_vma = (u32)ioremap_nocache(csa_phy, BLKSZ_4K);
 	if (!gpmc_data_vma) {
 		err = -ENOMEM;
-		cy_as_hal_print_message(KERN_ERR "error- ioremap()"
+		pr_err("error- ioremap()"
 					"for phy_addr:%x failed", csa_phy);
 
 		goto out_release_mem_region;
 	}
-	cy_as_hal_print_message(KERN_INFO "ioremap(%x) returned vma=%x\n",
+	pr_debug("ioremap(%x) returned vma=%x\n",
 							csa_phy, gpmc_data_vma);
 
 	gpmc_cs_write_reg(AST_GPMC_CS, GPMC_CS_CONFIG1,
@@ -473,7 +471,7 @@ static int cy_as_hal_gpmc_init(void)
 	IOWR32(GPMC_VMA(GPMC_CONFIG_REG), tmp32);
 
 	tmp32 = IORD32(GPMC_VMA(GPMC_CONFIG_REG));
-	cy_as_hal_print_message("GPMC_CONFIG_REG=0x%x\n", tmp32);
+	pr_debug("GPMC_CONFIG_REG=0x%x\n", tmp32);
 
 	return 0;
 
@@ -614,17 +612,17 @@ static int cy_as_hal_configure_interrupt
 		 * OMAP_GPIO_BIT(AST_INT, GPIO_IRQENABLE1) - print status
 		 *		of AST_INT GPIO IRQ_ENABLE FLAG
 		 */
-		cy_as_hal_print_message(KERN_INFO"AST_INT omap_pin:"
+		pr_debug("AST_INT omap_pin:"
 				"%d assigned IRQ #%d IRQEN1=%d\n",
 				irq_pin,
 				OMAP_GPIO_IRQ(irq_pin),
 				OMAP_GPIO_BIT(AST_INT, GPIO_IRQENABLE1)
 				);
 	} else {
-		cy_as_hal_print_message("cyasomaphal: interrupt "
+		pr_debug("cyasomaphal: interrupt "
 				"failed to register\n");
 		gpio_free(irq_pin);
-		cy_as_hal_print_message(KERN_WARNING
+		pr_debug(KERN_WARNING
 				"ASTORIA: can't get assigned IRQ"
 				"%i for INT#\n", OMAP_GPIO_IRQ(irq_pin));
 	}
@@ -669,7 +667,7 @@ static void cy_as_hal_init_user_pads(use
 			/*  sample the pin  */
 			in_level = __gpio_get_value(pad_cfg_tab->pin_num);
 
-			cy_as_hal_print_message(KERN_INFO "configured %s to "
+			pr_debug("configured %s to "
 					"OMAP pad_%d, DIR=%d "
 					"DOUT=%d, DIN=%d\n",
 					pad_cfg_tab->name,
@@ -682,7 +680,7 @@ static void cy_as_hal_init_user_pads(use
 			/*
 			 * get the pad_mux value to check on the pin_function
 			 */
-			cy_as_hal_print_message(KERN_INFO "couldn't cfg pin %d"
+			pr_debug("couldn't cfg pin %d"
 					"for signal %s, its already taken\n",
 					pad_cfg_tab->pin_num,
 					pad_cfg_tab->name);
@@ -691,7 +689,7 @@ static void cy_as_hal_init_user_pads(use
 		tmp16 = *(u16 *)PADCFG_VMA
 			(omap_mux_pin_cfg[pad_cfg_tab->mux_func].offset);
 
-		cy_as_hal_print_message(KERN_INFO "GPIO_%d(PAD_CFG=%x,OE=%d"
+		pr_debug("GPIO_%d(PAD_CFG=%x,OE=%d"
 			"DOUT=%d, DIN=%d IRQEN=%d)\n\n",
 			pad_cfg_tab->pin_num, tmp16,
 			OMAP_GPIO_BIT(pad_cfg_tab->pin_num, GPIO_OE),
@@ -706,7 +704,7 @@ static void cy_as_hal_init_user_pads(use
 		pad_cfg_tab++;
 	}
 
-	cy_as_hal_print_message(KERN_INFO"pads configured\n");
+	pr_debug("pads configured\n");
 }
 
 
@@ -720,12 +718,12 @@ static void cy_as_hal_release_user_pads(
 		if (pad_cfg_tab->valid) {
 			gpio_free(pad_cfg_tab->pin_num);
 			pad_cfg_tab->valid = 0;
-			cy_as_hal_print_message(KERN_INFO "GPIO_%d "
+			pr_debug("GPIO_%d "
 					"released from %s\n",
 					pad_cfg_tab->pin_num,
 					pad_cfg_tab->name);
 		} else {
-			cy_as_hal_print_message(KERN_INFO "no release "
+			pr_debug("no release "
 					"for %s, GPIO_%d, wasn't acquired\n",
 					pad_cfg_tab->name,
 					pad_cfg_tab->pin_num);
@@ -750,11 +748,11 @@ uint32_t cy_as_hal_processor_hw_init(voi
 {
 	int i, err;
 
-	cy_as_hal_print_message(KERN_INFO "init OMAP3430 hw...\n");
+	pr_debug("init OMAP3430 hw...\n");
 
 	iomux_vma = (u32)ioremap_nocache(
 				(u32)CTLPADCONF_BASE_ADDR, CTLPADCONF_SIZE);
-	cy_as_hal_print_message(KERN_INFO "PADCONF_VMA=%x val=%x\n",
+	pr_debug("PADCONF_VMA=%x val=%x\n",
 				iomux_vma, IORD32(iomux_vma));
 
 	/*
@@ -765,7 +763,7 @@ uint32_t cy_as_hal_processor_hw_init(voi
 					gpio_vma_tab[i].phy_addr,
 					gpio_vma_tab[i].size);
 
-		cy_as_hal_print_message(KERN_INFO "%s virt_addr=%x\n",
+		pr_debug("%s virt_addr=%x\n",
 					gpio_vma_tab[i].name,
 					(u32)gpio_vma_tab[i].virt_addr);
 	};
@@ -788,7 +786,7 @@ uint32_t cy_as_hal_processor_hw_init(voi
 
 	err = cy_as_hal_gpmc_init();
 	if (err < 0)
-		cy_as_hal_print_message(KERN_INFO"gpmc init failed:%d", err);
+		pr_debug("gpmc init failed:%d", err);
 
 	cy_as_hal_config_c_s_mux();
 
@@ -832,9 +830,9 @@ int stop_o_m_a_p_kernel(const char *pgm,
 	if (0 == dev_p)
 		return 1;
 
-	cy_as_hal_print_message("<1>_stopping OMAP34xx HAL layer object\n");
+	pr_debug("<1>_stopping OMAP34xx HAL layer object\n");
 	if (dev_p->m_sig != CY_AS_OMAP_KERNEL_HAL_SIG) {
-		cy_as_hal_print_message("<1>%s: %s: bad HAL tag\n",
+		pr_debug("<1>%s: %s: bad HAL tag\n",
 								pgm, __func__);
 		return 1;
 	}
@@ -849,7 +847,7 @@ int stop_o_m_a_p_kernel(const char *pgm,
 	if (dev_p->thread_flag == 0) {
 		dev_p->thread_flag = 1;
 		wait_for_completion(&dev_p->thread_complete);
-		cy_as_hal_print_message("cyasomaphal:"
+		pr_debug("cyasomaphal:"
 			"done cleaning thread\n");
 		cy_as_hal_destroy_sleep_channel(&dev_p->thread_sc);
 	}
@@ -865,7 +863,7 @@ int stop_o_m_a_p_kernel(const char *pgm,
 
 	cy_as_hal_free(dev_p);
 
-	cy_as_hal_print_message(KERN_INFO"OMAP_kernel_hal stopped\n");
+	pr_debug("OMAP_kernel_hal stopped\n");
 	return 0;
 }
 
@@ -1337,7 +1335,7 @@ static inline void ast_p_nand_casdi_writ
 	local_irq_save(flags);
 
 	if (atomic_read(&rdreg_usage_cnt) != 0) {
-		cy_as_hal_print_message(KERN_ERR "cy_as_omap_hal:"
+		pr_err("cy_as_omap_hal:"
 				"* cy_as_hal_write_register usage:%d\n",
 				atomic_read(&rdreg_usage_cnt));
 	}
@@ -1410,7 +1408,7 @@ static inline u16 ast_p_nand_casdo_read(
 		 * if it gets here ( from other threads), this function needs
 		 * need spin_lock_irq save() protection
 		 */
-		cy_as_hal_print_message(KERN_ERR"cy_as_omap_hal: "
+		pr_err("cy_as_omap_hal: "
 				"cy_as_hal_write_register usage:%d\n",
 				atomic_read(&wrreg_usage_cnt));
 	}
@@ -1756,7 +1754,7 @@ static void cy_handle_d_r_q_interrupt(cy
 
 	if (v == 0) {
 #ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("stray DRQ interrupt detected\n");
+		pr_err("stray DRQ interrupt detected\n");
 #endif
 		return;
 	}
@@ -1790,7 +1788,7 @@ static void cy_handle_d_r_q_interrupt(cy
 	}
 #ifndef WESTBRIDGE_NDEBUG
 	else
-		cy_as_hal_print_message("cyashalomap:interrupt,"
+		pr_debug("cyashalomap:interrupt,"
 					" w/o pending DMA job,"
 					"-check DRQ_MASK logic\n");
 #endif
@@ -2108,9 +2106,9 @@ cy_bool cy_as_hal_set_wakeup_pin(cy_as_h
 
 void cy_as_hal_pll_lock_loss_handler(cy_as_hal_device_tag tag)
 {
-	cy_as_hal_print_message("error: astoria PLL lock is lost\n");
-	cy_as_hal_print_message("please check the input voltage levels");
-	cy_as_hal_print_message("and clock, and restart the system\n");
+	pr_debug("error: astoria PLL lock is lost\n");
+	pr_debug("please check the input voltage levels");
+	pr_debug("and clock, and restart the system\n");
 }
 
 /*
@@ -2314,7 +2312,7 @@ int start_o_m_a_p_kernel(const char *pgm
 	dev_p = (cy_as_omap_dev_kernel *)cy_as_hal_alloc(
 						sizeof(cy_as_omap_dev_kernel));
 	if (dev_p == 0) {
-		cy_as_hal_print_message("out of memory allocating OMAP"
+		pr_err("out of memory allocating OMAP"
 					"device structure\n");
 		return 0;
 	}
@@ -2387,7 +2385,7 @@ int start_o_m_a_p_kernel(const char *pgm
 		goto bus_acc_error;
 	}
 
-	cy_as_hal_print_message(KERN_INFO" register access CASDO test:"
+	pr_debug(" register access CASDO test:"
 				"\n CY_AS_MEM_CM_WB_CFG_ID:%4.4x\n"
 				"PNAND_CFG after RST:%4.4x\n "
 				"CY_AS_MEM_PNAND_CFG"
@@ -2403,7 +2401,7 @@ int start_o_m_a_p_kernel(const char *pgm
 
 	cy_as_hal_configure_interrupts((void *)dev_p);
 
-	cy_as_hal_print_message(KERN_INFO"OMAP3430__hal started tag:%p"
+	pr_debug("OMAP3430__hal started tag:%p"
 				", kernel HZ:%d\n", dev_p, HZ);
 
 	/*
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h linux-2.6.39/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h	2011-04-05 22:51:48.802573418 -0700
@@ -292,7 +292,7 @@ void
 cy_as_log_debug_message(int level, const char *str)
 {
 	if (level <= debug_level)
-		cy_as_hal_print_message("log %d: %s\n", level, str);
+		pr_debug("log %d: %s\n", level, str);
 }
 */
 
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c linux-2.6.39/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/block/cyasblkdev_block.c	2011-04-28 10:48:03.450286472 -0700
@@ -202,7 +202,7 @@ static struct cyasblkdev_blk_data *cyasb
 	if (bd) {
 		bd->usage++;
 		#ifndef NBDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"cyasblkdev_blk_get: usage = %d\n", bd->usage);
 		#endif
 	}
@@ -222,12 +222,12 @@ static void cyasblkdev_blk_put(
 	if (bd) {
 		bd->usage--;
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			" cyasblkdev_blk_put , bd->usage= %d\n", bd->usage);
 		#endif
 	} else  {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"cyasblkdev: blk_put(bd) on bd = NULL!: usage = %d\n",
 			bd->usage);
 		#endif
@@ -244,7 +244,7 @@ static void cyasblkdev_blk_put(
 		if (CY_AS_ERROR_SUCCESS !=
 			cy_as_storage_release(bd->dev_handle, 0, 0, 0, 0)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"cyasblkdev: cannot release bus 0\n");
 			#endif
 		}
@@ -252,7 +252,7 @@ static void cyasblkdev_blk_put(
 		if (CY_AS_ERROR_SUCCESS !=
 			cy_as_storage_release(bd->dev_handle, 1, 0, 0, 0)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"cyasblkdev: cannot release bus 1\n");
 			#endif
 		}
@@ -260,7 +260,7 @@ static void cyasblkdev_blk_put(
 		if (CY_AS_ERROR_SUCCESS !=
 			cy_as_storage_stop(bd->dev_handle, 0, 0)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"cyasblkdev: cannot stop storage stack\n");
 			#endif
 		}
@@ -278,7 +278,7 @@ static void cyasblkdev_blk_put(
 	}
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	pr_debug(
 		"cyasblkdev (blk_put): usage = %d\n",
 		bd->usage);
 	#endif
@@ -304,7 +304,7 @@ static int cyasblkdev_blk_open(
 		if (bdev->bd_disk == bd->user_disk_0) {
 			if ((mode & FMODE_WRITE) && bd->user_disk_0_read_only) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"device marked as readonly "
 					"and write requested\n");
 				#endif
@@ -315,7 +315,7 @@ static int cyasblkdev_blk_open(
 		} else if (bdev->bd_disk == bd->user_disk_1) {
 			if ((mode & FMODE_WRITE) && bd->user_disk_1_read_only) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"device marked as readonly "
 					"and write requested\n");
 				#endif
@@ -326,7 +326,7 @@ static int cyasblkdev_blk_open(
 		} else if (bdev->bd_disk == bd->system_disk) {
 			if ((mode & FMODE_WRITE) && bd->system_disk_read_only) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"device marked as readonly "
 					"and write requested\n");
 				#endif
@@ -389,14 +389,14 @@ unsigned int cyasblkdev_check_events(str
 	struct cyasblkdev_blk_data *bd;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("cyasblkdev_media_changed() is called\n");
+	pr_debug("cyasblkdev_media_changed() is called\n");
 	#endif
 
 	if (gd)
 		bd = gd->private_data;
 	else {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"cyasblkdev_media_changed() is called, "
 			"but gd is null\n");
 		#endif
@@ -415,7 +415,7 @@ int cyasblkdev_revalidate_disk(struct ge
 
 	#ifndef WESTBRIDGE_NDEBUG
 	if (gd)
-		cy_as_hal_print_message(
+		pr_debug(
 			"cyasblkdev_revalidate_disk() is called, "
 			"(gl_bd->usage:%d)\n", gl_bd->usage);
 	#endif
@@ -452,7 +452,7 @@ static int cyasblkdev_blk_prep_rq(
 	/* If we have no device, we haven't finished initialising. */
 	if (!bd || !bd->dev_handle) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(KERN_ERR
+		pr_debug(
 			"cyasblkdev %s: killing request - no device/host\n",
 			req->rq_disk->disk_name);
 		#endif
@@ -466,7 +466,7 @@ static int cyasblkdev_blk_prep_rq(
 
 	/* Check for excessive requests.*/
 	if (blk_rq_pos(req) + blk_rq_sectors(req) > get_capacity(req->rq_disk)) {
-		cy_as_hal_print_message("cyasblkdev: bad request address\n");
+		pr_debug("cyasblkdev: bad request address\n");
 		stat = BLKPREP_KILL;
 	}
 
@@ -496,14 +496,14 @@ static void cyasblkdev_issuecallback(
 
 	if (status != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 		  "%s: async r/w: op:%d failed with error %d at address %d\n",
 			__func__, op, status, block_number);
 		#endif
 	}
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	pr_debug(
 		"%s calling blk_end_request from issue_callback "
 		"req=0x%x, status=0x%x, nr_sectors=0x%x\n",
 		__func__, (unsigned int) gl_bd->queue.req, status,
@@ -518,7 +518,7 @@ static void cyasblkdev_issuecallback(
 	};
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	pr_debug(
 		"%s blkdev_callback: ended rq on %d sectors, "
 		"with err:%d, n:%d times\n", __func__,
 		(int)blk_rq_sectors(gl_bd->queue.req), status,
@@ -533,7 +533,7 @@ static void cyasblkdev_issuecallback(
 		/* queue is not plugged */
 		gl_bd->queue.req = blk_fetch_request(gl_bd->queue.queue);
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s blkdev_callback: "
+		pr_debug("%s blkdev_callback: "
 		"blk_fetch_request():%p\n",
 			__func__, gl_bd->queue.req);
 		#endif
@@ -543,7 +543,7 @@ static void cyasblkdev_issuecallback(
 		spin_unlock_irq(&gl_bd->lock);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s blkdev_callback: about to "
+		pr_debug("%s blkdev_callback: about to "
 		"call issue_fn:%p\n", __func__, gl_bd->queue.req);
 		#endif
 
@@ -585,7 +585,7 @@ static int cyasblkdev_blk_issue_rq(
 		lcl_unit_no = gl_bd->user_disk_0_unit_no;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: request made to disk 0 "
+		pr_debug("%s: request made to disk 0 "
 			"for sector=%d, num_sectors=%d, unit_no=%d\n",
 			__func__, req_sector, (int) blk_rq_sectors(req),
 			lcl_unit_no);
@@ -598,7 +598,7 @@ static int cyasblkdev_blk_issue_rq(
 		lcl_unit_no = gl_bd->user_disk_1_unit_no;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: request made to disk 1 for "
+		pr_debug("%s: request made to disk 1 for "
 			"sector=%d, num_sectors=%d, unit_no=%d\n", __func__,
 			req_sector, (int) blk_rq_sectors(req), lcl_unit_no);
 		#endif
@@ -609,14 +609,14 @@ static int cyasblkdev_blk_issue_rq(
 		lcl_unit_no = gl_bd->system_disk_unit_no;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: request made to system disk "
+		pr_debug("%s: request made to system disk "
 			"for sector=%d, num_sectors=%d, unit_no=%d\n", __func__,
 			req_sector, (int) blk_rq_sectors(req), lcl_unit_no);
 		#endif
 	}
 	#ifndef WESTBRIDGE_NDEBUG
 	else {
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: invalid disk used for request\n", __func__);
 	}
 	#endif
@@ -625,7 +625,7 @@ static int cyasblkdev_blk_issue_rq(
 
 	if (rq_data_dir(req) == READ) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: calling readasync() "
+		pr_debug("%s: calling readasync() "
 			"req_sector=0x%x, req_nr_sectors=0x%x, bd->sg:%x\n\n",
 			__func__, req_sector, req_nr_sectors, (uint32_t)bd->sg);
 		#endif
@@ -636,10 +636,10 @@ static int cyasblkdev_blk_issue_rq(
 
 		if (ret != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s:readasync() error %d at "
+			pr_debug("%s:readasync() error %d at "
 				"address %ld, unit no %d\n", __func__, ret,
 				blk_rq_pos(req), lcl_unit_no);
-			cy_as_hal_print_message("%s:ending i/o request "
+			pr_debug("%s:ending i/o request "
 				"on reg:%x\n", __func__, (uint32_t)req);
 			#endif
 
@@ -657,7 +657,7 @@ static int cyasblkdev_blk_issue_rq(
 
 		if (ret != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: write failed with "
+			pr_debug("%s: write failed with "
 			"error %d at address %ld, unit no %d\n",
 			__func__, ret, blk_rq_pos(req), lcl_unit_no);
 			#endif
@@ -690,7 +690,7 @@ static void cyasblkdev_storage_callback(
 					)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("%s: bus:%d, device:%d, evtype:%d, "
+	pr_debug("%s: bus:%d, device:%d, evtype:%d, "
 	"evdata:%p\n ", __func__, bus, device, evtype, evdata);
 	#endif
 
@@ -740,13 +740,13 @@ uint32_t cyasblkdev_get_vfat_offset(int 
 	* code and ,0x55AA) is found
 	*/
 	#ifndef WESTBRIDGE_NDEBUG
-	  cy_as_hal_print_message(
+	  pr_debug(
 		"%s scanning media for vfat partition...\n", __func__);
 	#endif
 
 	for (sect_no = 0; sect_no < SECTORS_TO_SCAN; sect_no++) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s before cyasstorageread "
+		pr_debug("%s before cyasstorageread "
 			"gl_bd->sg addr=0x%x\n", __func__,
 			(unsigned int) gl_bd->sg);
 		#endif
@@ -774,7 +774,7 @@ uint32_t cyasblkdev_get_vfat_offset(int 
 			 * sector 0, check it first  */
 			if (sect_buf[0] == 0xEB) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"%s vfat partition found "
 					"at sector:%d\n",
 					__func__, sect_no);
@@ -787,7 +787,7 @@ uint32_t cyasblkdev_get_vfat_offset(int 
 
 		if (stat != 0) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s sector scan error\n",
+			pr_debug("%s sector scan error\n",
 				__func__);
 			#endif
 			break;
@@ -800,7 +800,7 @@ uint32_t cyasblkdev_get_vfat_offset(int 
 		return sect_no;
 	} else {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s vfat partition is not found, using 0 offset\n",
 			__func__);
 		#endif
@@ -821,7 +821,7 @@ static int cyasblkdev_add_disks(int bus_
 	cy_as_storage_query_unit_data unit_data = {0};
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s:query device: "
+		pr_debug("%s:query device: "
 		"type:%d, removable:%d, writable:%d, "
 		"blksize %d, units:%d, locked:%d, "
 		"erase_sz:%d\n",
@@ -839,14 +839,14 @@ static int cyasblkdev_add_disks(int bus_
 	/*  make sure that device is not locked  */
 	if (dev_data.desc_p.locked) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: device is locked\n", __func__);
 		#endif
 		ret = cy_as_storage_release(
 			bd->dev_handle, bus_num, 0, 0, 0);
 		if (ret != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s cannot release"
+			pr_debug("%s cannot release"
 				" storage\n", __func__);
 			#endif
 			goto out;
@@ -861,7 +861,7 @@ static int cyasblkdev_add_disks(int bus_
 		&unit_data, 0, 0);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: cannot query "
+		pr_debug("%s: cannot query "
 			"%d device unit - reason code %d\n",
 			__func__, bus_num, ret);
 		#endif
@@ -876,7 +876,7 @@ static int cyasblkdev_add_disks(int bus_
 			if ((ret != CY_AS_ERROR_SUCCESS) &&
 			(ret != CY_AS_ERROR_ALREADY_PARTITIONED)) {
 			#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message("%s: cy_as_storage_"
+				pr_debug("%s: cy_as_storage_"
 				"create_p_partition after size > 0 check "
 				"failed with error code %d\n",
 				__func__, ret);
@@ -888,7 +888,7 @@ static int cyasblkdev_add_disks(int bus_
 
 			} else if (ret == CY_AS_ERROR_ALREADY_PARTITIONED) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 				"%s: cy_as_storage_create_p_partition "
 				"indicates memory already partitioned\n",
 				__func__);
@@ -911,7 +911,7 @@ static int cyasblkdev_add_disks(int bus_
 							unit_data.unit = 1;
 						} else {
 							#ifndef WESTBRIDGE_NDEBUG
-							cy_as_hal_print_message(
+							pr_debug(
 							"%s: cy_as_storage_create_p_partition "
 							"after removal unexpectedly failed "
 							"with error %d\n", __func__, ret);
@@ -932,7 +932,7 @@ static int cyasblkdev_add_disks(int bus_
 						&unit_data, 0, 0);
 						if (ret != CY_AS_ERROR_SUCCESS) {
 							#ifndef WESTBRIDGE_NDEBUG
-							cy_as_hal_print_message(
+							pr_debug(
 							"%s: cannot query %d "
 							"device unit - reason code %d\n",
 							__func__, bus_num, ret);
@@ -946,7 +946,7 @@ static int cyasblkdev_add_disks(int bus_
 						}
 					} else {
 					#ifndef WESTBRIDGE_NDEBUG
-					cy_as_hal_print_message(
+					pr_debug(
 					"%s: cy_as_storage_remove_p_partition "
 					"failed with error %d\n",
 					__func__, ret);
@@ -960,7 +960,7 @@ static int cyasblkdev_add_disks(int bus_
 							bd->dev_handle, &unit_data, 0, 0);
 						if (ret != CY_AS_ERROR_SUCCESS) {
 						#ifndef WESTBRIDGE_NDEBUG
-							cy_as_hal_print_message(
+							pr_debug(
 							"%s: cannot query %d "
 							"device unit - reason "
 							"code %d\n", __func__,
@@ -976,7 +976,7 @@ static int cyasblkdev_add_disks(int bus_
 					}
 				} else {
 					#ifndef WESTBRIDGE_NDEBUG
-					cy_as_hal_print_message("%s: partition "
+					pr_debug("%s: partition "
 						"exists and sizes equal\n",
 						__func__);
 					#endif
@@ -991,7 +991,7 @@ static int cyasblkdev_add_disks(int bus_
 						bd->dev_handle, &unit_data, 0, 0);
 					if (ret != CY_AS_ERROR_SUCCESS) {
 					#ifndef WESTBRIDGE_NDEBUG
-						cy_as_hal_print_message(
+						pr_debug(
 							"%s: cannot query %d "
 							"device unit "
 							"- reason code %d\n",
@@ -1006,7 +1006,7 @@ static int cyasblkdev_add_disks(int bus_
 				}
 			} else {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 				"%s: cy_as_storage_create_p_partition "
 				"created successfully\n", __func__);
 				#endif
@@ -1020,7 +1020,7 @@ static int cyasblkdev_add_disks(int bus_
 		}
 		#ifndef WESTBRIDGE_NDEBUG
 		else {
-			cy_as_hal_print_message(
+			pr_debug(
 			"%s: invalid partition_size%d\n", __func__,
 			private_partition_size);
 
@@ -1041,7 +1041,7 @@ static int cyasblkdev_add_disks(int bus_
 			"cyasblkdevblk%d", devidx);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: disk unit_sz:%lu blk_sz:%d, "
 			"start_blk:%lu, capacity:%llu\n",
 			__func__, (unsigned long)
@@ -1054,13 +1054,13 @@ static int cyasblkdev_add_disks(int bus_
 		#endif
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: setting gendisk disk "
+		pr_debug("%s: setting gendisk disk "
 			"capacity to %d\n", __func__, (int) disk_cap);
 		#endif
 
 		/* initializing bd->queue */
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: init bd->queue\n",
+		pr_debug("%s: init bd->queue\n",
 			__func__);
 		#endif
 
@@ -1103,7 +1103,7 @@ static int cyasblkdev_add_disks(int bus_
 			disk_cap);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: returned from set_capacity %d\n",
 			__func__, (int) disk_cap);
 		#endif
@@ -1120,58 +1120,58 @@ static int cyasblkdev_add_disks(int bus_
 		}
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: set user_disk_0_first "
 			"sector to %d\n", __func__,
 			 bd->user_disk_0_first_sector);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: disk->major=0x%x\n",
 			__func__,
 			bd->user_disk_0->major);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: "
 			"disk->first_minor=0x%x\n", __func__,
 			bd->user_disk_0->first_minor);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: "
 			"disk->minors=0x%x\n", __func__,
 			bd->user_disk_0->minors);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: "
 			"disk->disk_name=%s\n",
 			__func__,
 			bd->user_disk_0->disk_name);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: "
 			"disk->part_tbl=0x%x\n", __func__,
 			(unsigned int)
 			bd->user_disk_0->part_tbl);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: "
 			"disk->queue=0x%x\n", __func__,
 			(unsigned int)
 			bd->user_disk_0->queue);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: "
 			"disk->flags=0x%x\n",
 			__func__, (unsigned int)
 			bd->user_disk_0->flags);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: "
 			"disk->driverfs_dev=0x%x\n",
 			__func__, (unsigned int)
 			bd->user_disk_0->driverfs_dev);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: "
 			"disk->slave_dir=0x%x\n",
 			__func__, (unsigned int)
 			bd->user_disk_0->slave_dir);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: "
 			"disk->random=0x%x\n",
 			__func__, (unsigned int)
 			bd->user_disk_0->random);
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: add_disk: "
 			"disk->node_id=0x%x\n",
 			__func__, (unsigned int)
@@ -1201,7 +1201,7 @@ static int cyasblkdev_add_disks(int bus_
 			"cyasblkdevblk%d", (devidx + 1));
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: disk unit_sz:%lu "
 			"blk_sz:%d, "
 			"start_blk:%lu, "
@@ -1227,7 +1227,7 @@ static int cyasblkdev_add_disks(int bus_
 			blk_queue_logical_block_size(bd->queue.queue,
 				bd->user_disk_0_blk_size);
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 			"%s: set hard sect_sz:%d\n",
 			__func__,
 			bd->user_disk_0_blk_size);
@@ -1236,7 +1236,7 @@ static int cyasblkdev_add_disks(int bus_
 			blk_queue_logical_block_size(bd->queue.queue,
 				bd->user_disk_1_blk_size);
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 			"%s: set hard sect_sz:%d\n",
 			__func__,
 			bd->user_disk_1_blk_size);
@@ -1297,7 +1297,7 @@ static int cyasblkdev_add_disks(int bus_
 		}
 		#ifndef WESTBRIDGE_NDEBUG
 		else {
-			cy_as_hal_print_message(
+			pr_debug(
 				"%s: system disk already allocated %d\n",
 				__func__, bus_num);
 		}
@@ -1339,7 +1339,7 @@ static struct cyasblkdev_blk_data *cyasb
 		bd->dev_handle = cyasdevice_getdevhandle();
 		if (0 == bd->dev_handle) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"%s: get device failed\n", __func__);
 			#endif
 			ret = ENODEV;
@@ -1347,7 +1347,7 @@ static struct cyasblkdev_blk_data *cyasb
 		}
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s west bridge device handle:%x\n",
+		pr_debug("%s west bridge device handle:%x\n",
 			__func__, (uint32_t)bd->dev_handle);
 		#endif
 
@@ -1361,7 +1361,7 @@ static struct cyasblkdev_blk_data *cyasb
 		if ((stat != CY_AS_ERROR_SUCCESS) &&
 		(stat != CY_AS_ERROR_RESOURCE_NOT_OWNED)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot release "
+			pr_debug("%s: cannot release "
 				"resource bus 0 - reason code %d\n",
 				__func__, stat);
 			#endif
@@ -1371,7 +1371,7 @@ static struct cyasblkdev_blk_data *cyasb
 		if ((stat != CY_AS_ERROR_SUCCESS) &&
 		(stat != CY_AS_ERROR_RESOURCE_NOT_OWNED)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot release "
+			pr_debug("%s: cannot release "
 				"resource bus 0 - reason code %d\n",
 				__func__, stat);
 			#endif
@@ -1381,14 +1381,14 @@ static struct cyasblkdev_blk_data *cyasb
 		stat = cy_as_storage_start(bd->dev_handle, 0, 0x101);
 		if (stat != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot start storage "
+			pr_debug("%s: cannot start storage "
 				"stack - reason code %d\n", __func__, stat);
 			#endif
 			goto out;
 		}
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: storage started:%d ok\n",
+		pr_debug("%s: storage started:%d ok\n",
 			__func__, stat);
 		#endif
 
@@ -1396,7 +1396,7 @@ static struct cyasblkdev_blk_data *cyasb
 			cyasblkdev_storage_callback);
 		if (stat != CY_AS_ERROR_SUCCESS) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: cannot register callback "
+			pr_debug("%s: cannot register callback "
 				"- reason code %d\n", __func__, stat);
 			#endif
 			goto out;
@@ -1410,7 +1410,7 @@ static struct cyasblkdev_blk_data *cyasb
 					bd->media_count[bus_num];
 			} else {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message("%s: cannot query %d, "
+				pr_debug("%s: cannot query %d, "
 					"reason code: %d\n",
 					__func__, bus_num, stat);
 				#endif
@@ -1420,7 +1420,7 @@ static struct cyasblkdev_blk_data *cyasb
 
 		if (total_media_count == 0) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"%s: no storage media was found\n", __func__);
 			#endif
 			goto out;
@@ -1437,7 +1437,7 @@ static struct cyasblkdev_blk_data *cyasb
 			}
 			#ifndef WESTBRIDGE_NDEBUG
 			else {
-				cy_as_hal_print_message("%s: no available "
+				pr_debug("%s: no available "
 					"gen_disk for disk 0, "
 					"physically inconsistent\n", __func__);
 			}
@@ -1456,7 +1456,7 @@ static struct cyasblkdev_blk_data *cyasb
 			}
 			#ifndef WESTBRIDGE_NDEBUG
 			else {
-				cy_as_hal_print_message("%s: no available "
+				pr_debug("%s: no available "
 					"gen_disk for media, "
 					"physically inconsistent\n", __func__);
 			}
@@ -1464,13 +1464,13 @@ static struct cyasblkdev_blk_data *cyasb
 		}
 		#ifndef WESTBRIDGE_NDEBUG
 		else if (total_media_count > 2) {
-			cy_as_hal_print_message("%s: count corrupted = 0x%d\n",
+			pr_debug("%s: count corrupted = 0x%d\n",
 				__func__, total_media_count);
 		}
 		#endif
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: %d device(s) found\n",
+		pr_debug("%s: %d device(s) found\n",
 			__func__, total_media_count);
 		#endif
 
@@ -1479,7 +1479,7 @@ static struct cyasblkdev_blk_data *cyasb
 			stat = cy_as_storage_claim(bd->dev_handle,
 				bus_num, 0, 0, 0);
 			if (stat != CY_AS_ERROR_SUCCESS) {
-				cy_as_hal_print_message("%s: cannot claim "
+				pr_debug("%s: cannot claim "
 					"%d bus - reason code %d\n",
 					__func__, bus_num, stat);
 				goto out;
@@ -1495,13 +1495,13 @@ static struct cyasblkdev_blk_data *cyasb
 					total_media_count, devidx);
 			} else if (stat == CY_AS_ERROR_NO_SUCH_DEVICE) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"%s: no device on bus %d\n",
 					__func__, bus_num);
 				#endif
 			} else {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"%s: cannot query %d device "
 					"- reason code %d\n",
 					__func__, bus_num, stat);
@@ -1514,7 +1514,7 @@ static struct cyasblkdev_blk_data *cyasb
 	}
 out:
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	pr_debug(
 		"%s: bd failed to initialize\n", __func__);
 	#endif
 
@@ -1536,7 +1536,7 @@ static int cyasblkdev_blk_initialize(voi
 
 	if (res < 0) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(KERN_WARNING
+		pr_debug(
 			"%s unable to get major %d for cyasblkdev media: %d\n",
 			__func__, major, res);
 		#endif
@@ -1547,7 +1547,7 @@ static int cyasblkdev_blk_initialize(voi
 		major = res;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	pr_debug(
 		"%s cyasblkdev registered with major number: %d\n",
 		__func__, major);
 	#endif
@@ -1573,7 +1573,7 @@ static int __init cyasblkdev_blk_init(vo
 		return 0;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("cyasblkdev init error:%d\n", res);
+	pr_debug("cyasblkdev init error:%d\n", res);
 	#endif
 	return res;
 }
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c linux-2.6.39/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c	2011-04-28 10:47:16.914531945 -0700
@@ -97,7 +97,7 @@ static int cyasblkdev_prep_request(
 	/* we only like normal block requests.*/
 	if (req->cmd_type != REQ_TYPE_FS && !(req->cmd_flags & REQ_DISCARD)) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s:%x bad request received\n",
+		pr_debug("%s:%x bad request received\n",
 			__func__, current->pid);
 		#endif
 
@@ -135,7 +135,7 @@ static int cyasblkdev_queue_thread(void 
 	qth_pid = current->pid;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	pr_debug(
 		"%s:%x started, bq:%p, q:%p\n", __func__, qth_pid, bq, q);
 	#endif
 
@@ -148,7 +148,7 @@ static int cyasblkdev_queue_thread(void 
 		spin_lock_irq(q->queue_lock);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: for bq->queue is null\n", __func__);
 		#endif
 
@@ -157,29 +157,30 @@ static int cyasblkdev_queue_thread(void 
 			if (!blk_queue_plugged(q)) {
 				bq->req = req = blk_fetch_request(q);
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"%s: blk_fetch_request:%x\n",
 					__func__, (uint32_t)req);
 				#endif
 			} else {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"%s: queue plugged, "
 					"skip blk_fetch()\n", __func__);
 				#endif
 			}
 		}
+
 		spin_unlock_irq(q->queue_lock);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: checking if request queue is null\n", __func__);
 		#endif
 
 		if (!req) {
 			if (bq->flags & CYASBLKDEV_QUEUE_EXIT) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"%s:got QUEUE_EXIT flag\n", __func__);
 				#endif
 
@@ -187,21 +188,21 @@ static int cyasblkdev_queue_thread(void 
 			}
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"%s: request queue is null, goto sleep, "
 				"thread_sem->count=%d\n",
 				__func__, bq->thread_sem.count);
 			if (spin_is_locked(q->queue_lock)) {
-				cy_as_hal_print_message("%s: queue_lock "
+				pr_debug("%s: queue_lock "
 				"is locked, need to release\n", __func__);
 				spin_unlock(q->queue_lock);
 
 				if (spin_is_locked(q->queue_lock))
-					cy_as_hal_print_message(
+					pr_debug(
 						"%s: unlock did not work\n",
 						__func__);
 			} else {
-				cy_as_hal_print_message(
+				pr_debug(
 					"%s: checked lock, is not locked\n",
 					__func__);
 			}
@@ -215,7 +216,7 @@ static int cyasblkdev_queue_thread(void 
 			down(&bq->thread_sem);
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"%s: wake_up,continue\n",
 				__func__);
 			#endif
@@ -226,7 +227,7 @@ static int cyasblkdev_queue_thread(void 
 		set_current_state(TASK_RUNNING);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: issued a RQ:%x\n",
 			__func__, (uint32_t)req);
 		#endif
@@ -234,7 +235,7 @@ static int cyasblkdev_queue_thread(void 
 		bq->issue_fn(bq, req);
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: bq->issue_fn() returned\n",
 			__func__);
 		#endif
@@ -249,7 +250,7 @@ static int cyasblkdev_queue_thread(void 
 	complete_and_exit(&bq->thread_complete, 0);
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("%s: is finished\n", __func__);
+	pr_debug("%s: is finished\n", __func__);
 	#endif
 
 	return 0;
@@ -267,14 +268,14 @@ static void cyasblkdev_request(struct re
 	DBGPRN_FUNC_NAME;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	pr_debug(
 		"%s new request on cyasblkdev_queue_t bq:=%x\n",
 		__func__, (uint32_t)bq);
 	#endif
 
 	if (!bq->req) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s wake_up(&bq->thread_wq)\n",
+		pr_debug("%s wake_up(&bq->thread_wq)\n",
 			__func__);
 		#endif
 
@@ -282,7 +283,7 @@ static void cyasblkdev_request(struct re
 		wake_up(&bq->thread_wq);
 	} else {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: don't wake Q_thr, bq->req:%x\n",
+		pr_debug("%s: don't wake Q_thr, bq->req:%x\n",
 			__func__, (uint32_t)bq->req);
 		#endif
 	}
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c linux-2.6.39/drivers/staging/westbridge/astoria/device/cyasdevice.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/device/cyasdevice.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/device/cyasdevice.c	2011-04-05 18:14:39.078673000 -0700
@@ -60,20 +60,20 @@ extern void cy_as_hal_config_c_s_mux(voi
 
 static void cyasdevice_deinit(cyasdevice *cy_as_dev)
 {
-	cy_as_hal_print_message("<1>_cy_as_device deinitialize called\n");
+	pr_debug("<1>_cy_as_device deinitialize called\n");
 	if (!cy_as_dev) {
-		cy_as_hal_print_message("<1>_cy_as_device_deinit:  "
+		pr_debug("<1>_cy_as_device_deinit:  "
 			"device handle %x is invalid\n", (uint32_t)cy_as_dev);
 		return;
 	}
 
 	/* stop west_brige */
 	if (cy_as_dev->dev_handle) {
-		cy_as_hal_print_message("<1>_cy_as_device: "
+		pr_debug("<1>_cy_as_device: "
 			"cy_as_misc_destroy_device called\n");
 		if (cy_as_misc_destroy_device(cy_as_dev->dev_handle) !=
 			CY_AS_ERROR_SUCCESS) {
-			cy_as_hal_print_message(
+			pr_debug(
 				"<1>_cy_as_device: destroying failed\n");
 		}
 	}
@@ -83,16 +83,16 @@ static void cyasdevice_deinit(cyasdevice
  #ifdef CONFIG_MACH_OMAP3_WESTBRIDGE_AST_PNAND_HAL
 		if (stop_o_m_a_p_kernel(dev_handle_name,
 			cy_as_dev->hal_tag) != 0)
-			cy_as_hal_print_message("<1>_cy_as_device: stopping "
+			pr_debug("<1>_cy_as_device: stopping "
 				"OMAP kernel HAL failed\n");
 
  #endif
 	}
-	cy_as_hal_print_message("<1>_cy_as_device:HAL layer stopped\n");
+	pr_debug("<1>_cy_as_device:HAL layer stopped\n");
 
 	kfree(cy_as_dev);
 	cy_as_device_controller = NULL;
-	cy_as_hal_print_message("<1>_cy_as_device: deinitialized\n");
+	pr_debug("<1>_cy_as_device: deinitialized\n");
 }
 
 /*called from src/cyasmisc.c:MyMiscCallback() as a func
@@ -110,13 +110,13 @@ static void cy_misc_callback(cy_as_devic
 
 	switch (evtype) {
 	case cy_as_event_misc_initialized:
-	cy_as_hal_print_message("<1>_cy_as_device: "
+	pr_debug("<1>_cy_as_device: "
 		"initialization done callback triggered\n");
 	cy_as_device_init_done = 1;
 	break;
 
 	case cy_as_event_misc_awake:
-	cy_as_hal_print_message("<1>_cy_as_device: "
+	pr_debug("<1>_cy_as_device: "
 		"cy_as_event_misc_awake event callback triggered\n");
 	cy_as_device_init_done = 1;
 	break;
@@ -143,13 +143,13 @@ EXPORT_SYMBOL(cy_as_release_common_lock)
  #define PNAND_REG_CFG_INIT_VAL 0x0000
 void  hal_reset(cy_as_hal_device_tag tag)
 {
-	cy_as_hal_print_message("<1> send soft hard rst: "
+	pr_debug("<1> send soft hard rst: "
 		"MEM_RST_CTRL_REG_HARD...\n");
 	cy_as_hal_write_register(tag, CY_AS_MEM_RST_CTRL_REG,
 		CY_AS_MEM_RST_CTRL_REG_HARD);
 	mdelay(60);
 
-	cy_as_hal_print_message("<1> after RST: si_rev_REG:%x, "
+	pr_debug("<1> after RST: si_rev_REG:%x, "
 		"PNANDCFG_reg:%x\n",
 		 cy_as_hal_read_register(tag, CY_AS_MEM_CM_WB_CFG_ID),
 		 cy_as_hal_read_register(tag, CY_AS_MEM_PNAND_CFG)
@@ -168,13 +168,13 @@ static struct platform_device *westbridg
 
 static int __devinit wb_probe(struct platform_device *devptr)
 {
-	cy_as_hal_print_message("%s called\n", __func__);
+	pr_debug("%s called\n", __func__);
 	return 0;
 }
 
 static int __devexit wb_remove(struct platform_device *devptr)
 {
-	cy_as_hal_print_message("%s called\n", __func__);
+	pr_debug("%s called\n", __func__);
 	return 0;
 }
 
@@ -202,10 +202,10 @@ static int cyasdevice_initialize(void)
 
 	cy_as_misc_set_log_level(8);
 
-	cy_as_hal_print_message("<1>_cy_as_device initialize called\n");
+	pr_debug("<1>_cy_as_device initialize called\n");
 
 	if (cy_as_device_controller != 0) {
-		cy_as_hal_print_message("<1>_cy_as_device: the device "
+		pr_debug("<1>_cy_as_device: the device "
 			"has already been initilaized. ignoring\n");
 		return -EBUSY;
 	}
@@ -213,7 +213,7 @@ static int cyasdevice_initialize(void)
 	/* cy_as_dev = CyAsHalAlloc (sizeof(cyasdevice), SLAB_KERNEL); */
 	cy_as_dev = cy_as_hal_alloc(sizeof(cyasdevice));
 	if (cy_as_dev == NULL) {
-		cy_as_hal_print_message("<1>_cy_as_device: "
+		pr_debug("<1>_cy_as_device: "
 			"memory allocation failed\n");
 		return -ENOMEM;
 	}
@@ -228,7 +228,7 @@ static int cyasdevice_initialize(void)
 	if (!start_o_m_a_p_kernel(dev_handle_name,
 		&(cy_as_dev->hal_tag), cy_false)) {
 
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_device: start OMAP34xx HAL failed\n");
 		goto done;
 	}
@@ -238,7 +238,7 @@ static int cyasdevice_initialize(void)
 	if (cy_as_misc_create_device(&(cy_as_dev->dev_handle),
 		cy_as_dev->hal_tag) != CY_AS_ERROR_SUCCESS) {
 
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_device: create device failed\n");
 		goto done;
 	}
@@ -249,7 +249,7 @@ static int cyasdevice_initialize(void)
 	ret = cy_as_misc_configure_device(cy_as_dev->dev_handle, &config);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_device: configure device "
 			"failed. reason code: %d\n", ret);
 		goto done;
@@ -258,7 +258,7 @@ static int cyasdevice_initialize(void)
 	ret = cy_as_misc_register_callback(cy_as_dev->dev_handle,
 		cy_misc_callback);
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("<1>_cy_as_device: "
+		pr_debug("<1>_cy_as_device: "
 			"cy_as_misc_register_callback failed. "
 			"reason code: %d\n", ret);
 		goto done;
@@ -278,10 +278,10 @@ static int cyasdevice_initialize(void)
 	ret = request_firmware(&fw_entry,
 		"west bridge fw", &westbridge_pd->dev);
 	if (ret) {
-		cy_as_hal_print_message("cy_as_device: "
+		pr_debug("cy_as_device: "
 			"request_firmware failed return val = %d\n", ret);
 	} else {
-		cy_as_hal_print_message("cy_as_device: "
+		pr_debug("cy_as_device: "
 			"got the firmware %d size=0x%x\n", ret, fw_entry->size);
 
 		ret = cy_as_misc_download_firmware(
@@ -292,7 +292,7 @@ static int cyasdevice_initialize(void)
 	}
 
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("<1>_cy_as_device: cannot download "
+		pr_debug("<1>_cy_as_device: cannot download "
 			"firmware. reason code: %d\n", ret);
 		goto done;
 	}
@@ -308,7 +308,7 @@ static int cyasdevice_initialize(void)
 		cy_as_hal_sleep_on(&channel, 100);
 
 		if (spin_lim-- <= 0) {
-			cy_as_hal_print_message(
+			pr_debug(
 			"<1>\n_e_r_r_o_r!: "
 			"wait for FW init has timed out !!!");
 			break;
@@ -317,13 +317,13 @@ static int cyasdevice_initialize(void)
 	cy_as_hal_destroy_sleep_channel(&channel);
 
 	if (spin_lim > 0)
-		cy_as_hal_print_message(
+		pr_debug(
 			"cy_as_device: astoria firmware is loaded\n");
 
 	ret = cy_as_misc_get_firmware_version(cy_as_dev->dev_handle,
 		&ver_data, 0, 0);
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("<1>_cy_as_device: cannot get firmware "
+		pr_debug("<1>_cy_as_device: cannot get firmware "
 			"version. reason code: %d\n", ret);
 		goto done;
 	}
@@ -339,7 +339,7 @@ static int cyasdevice_initialize(void)
 	else
 		str = "SD/MMC.";
 
-	cy_as_hal_print_message("<1> cy_as_device:_firmware version: %s "
+	pr_debug("<1> cy_as_device:_firmware version: %s "
 		"major=%d minor=%d build=%d,\n_media types supported:%s\n",
 		((ver_data.is_debug_mode) ? "debug" : "release"),
 		ver_data.major, ver_data.minor, ver_data.build, str);
diff -uprN -X linux-2.6.39_vanilla/Documentation/dontdiff linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c linux-2.6.39/drivers/staging/westbridge/astoria/gadget/cyasgadget.c
--- linux-2.6.39_vanilla/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2011-04-04 17:56:07.000000000 -0700
+++ linux-2.6.39/drivers/staging/westbridge/astoria/gadget/cyasgadget.c	2011-04-28 10:56:34.646281777 -0700
@@ -115,7 +115,7 @@ static void cy_as_gadget_usb_event_callb
 	switch (ev) {
 	case cy_as_event_usb_suspend:
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_event_usb_suspend received\n");
 		#endif
 		cy_as_dev->driver->suspend(&cy_as_dev->gadget);
@@ -123,7 +123,7 @@ static void cy_as_gadget_usb_event_callb
 
 	case cy_as_event_usb_resume:
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_event_usb_resume received\n");
 		#endif
 		cy_as_dev->driver->resume(&cy_as_dev->gadget);
@@ -131,21 +131,21 @@ static void cy_as_gadget_usb_event_callb
 
 	case cy_as_event_usb_reset:
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_event_usb_reset received\n");
 		#endif
 		break;
 
 	case cy_as_event_usb_speed_change:
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_event_usb_speed_change received\n");
 		#endif
 		break;
 
 	case cy_as_event_usb_set_config:
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_event_usb_set_config received\n");
 		#endif
 		break;
@@ -154,7 +154,7 @@ static void cy_as_gadget_usb_event_callb
 		#ifndef WESTBRIDGE_NDEBUG
 		ctrlreq = (struct usb_ctrlrequest *)evdata;
 
-		cy_as_hal_print_message("<1>_cy_as_event_usb_setup_packet "
+		pr_debug("<1>_cy_as_event_usb_setup_packet "
 							"received"
 							"bRequestType=0x%x,"
 							"bRequest=0x%x,"
@@ -177,28 +177,28 @@ static void cy_as_gadget_usb_event_callb
 
 	case cy_as_event_usb_status_packet:
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_event_usb_status_packet received\n");
 		#endif
 		break;
 
 	case cy_as_event_usb_inquiry_before:
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_event_usb_inquiry_before received\n");
 		#endif
 		break;
 
 	case cy_as_event_usb_inquiry_after:
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_event_usb_inquiry_after received\n");
 		#endif
 		break;
 
 	case cy_as_event_usb_start_stop:
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"<1>_cy_as_event_usb_start_stop received\n");
 		#endif
 		break;
@@ -225,9 +225,9 @@ static void cy_as_gadget_mtp_event_callb
 				(cy_as_mtp_send_object_complete_data *) evdata;
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"<6>MTP EVENT: send_object_complete\n");
-			cy_as_hal_print_message(
+			pr_debug(
 				"<6>_bytes sent = %d\n_send status = %d",
 					send_obj_data->byte_count,
 					send_obj_data->status);
@@ -248,9 +248,9 @@ static void cy_as_gadget_mtp_event_callb
 				(cy_as_mtp_get_object_complete_data *) evdata;
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"<6>MTP EVENT: get_object_complete\n");
-			cy_as_hal_print_message(
+			pr_debug(
 				"<6>_bytes got = %d\n_get status = %d",
 				get_obj_data->byte_count, get_obj_data->status);
 			#endif
@@ -266,7 +266,7 @@ static void cy_as_gadget_mtp_event_callb
 		{
 			dev->tmtp_need_new_blk_tbl = cy_true;
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"<6>MTP EVENT: cy_as_mtp_block_table_needed\n");
 			#endif
 			break;
@@ -300,7 +300,7 @@ cyasgadget_setupreadcallback(
 	stopped = an_ep->stopped;
 
 #ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message(
+	pr_debug(
 		"%s: ep=%d, count=%d, "
 		"status=%d\n", __func__,  ep, count, status);
 #endif
@@ -341,7 +341,7 @@ static void cyasgadget_setupwritecallbac
 	(void)buf;
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>%s called status=0x%x\n",
+		pr_debug("<1>%s called status=0x%x\n",
 			__func__, status);
 	#endif
 
@@ -357,7 +357,7 @@ static void cyasgadget_setupwritecallbac
 	stopped = an_ep->stopped;
 
 #ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("setup_write_callback: ep=%d, "
+	pr_debug("setup_write_callback: ep=%d, "
 		"count=%d, status=%d\n", ep, count, status);
 #endif
 
@@ -404,7 +404,7 @@ static void cyasgadget_readcallback(
 	stopped = an_ep->stopped;
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: ep=%d, count=%d, status=%d\n",
+		pr_debug("%s: ep=%d, count=%d, status=%d\n",
 			__func__, ep, count, status);
 	#endif
 
@@ -447,7 +447,7 @@ static void cyasgadget_readcallback(
 				an_req->req.buf, cyasgadget_readcallback);
 
 			if (ret != CY_AS_ERROR_SUCCESS)
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				pr_debug("<1>_cy_as_gadget: "
 					"cy_as_usb_read_data_async failed "
 					"with error code %d\n", ret);
 			else
@@ -485,7 +485,7 @@ static void cyasgadget_writecallback(
 		return;
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: ep=%d, count=%d, status=%d\n",
+		pr_debug("%s: ep=%d, count=%d, status=%d\n",
 			__func__, ep, count, status);
 	#endif
 
@@ -524,7 +524,7 @@ static void cyasgadget_writecallback(
 				cy_false, cyasgadget_writecallback);
 
 			if (ret != CY_AS_ERROR_SUCCESS)
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				pr_debug("<1>_cy_as_gadget: "
 					"cy_as_usb_write_data_async "
 					"failed with error code %d\n", ret);
 			else
@@ -543,7 +543,7 @@ static void cyasgadget_stallcallback(
 {
 	#ifndef WESTBRIDGE_NDEBUG
 	if (status != CY_AS_ERROR_SUCCESS)
-		cy_as_hal_print_message("<1>_set/_clear stall "
+		pr_debug("<1>_set/_clear stall "
 			"failed with status %d\n", status);
 	#endif
 }
@@ -583,7 +583,7 @@ static int cyasgadget_enable(
 
 	if (an_ep->cyepconfig.enabled != cy_true) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>_cy_as_gadget: "
+		pr_debug("<1>_cy_as_gadget: "
 			"cy_as_usb_end_point_config EP %s mismatch "
 			"on enabled\n", an_ep->usb_ep_inst.name);
 		#endif
@@ -599,7 +599,7 @@ static int cyasgadget_enable(
 	case USB_ENDPOINT_XFER_ISOC:
 		if (an_ep->cyepconfig.type != cy_as_usb_iso) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			pr_debug("<1>_cy_as_gadget: "
 				"cy_as_usb_end_point_config EP %s mismatch "
 				"on type %d %d\n", an_ep->usb_ep_inst.name,
 				an_ep->cyepconfig.type, cy_as_usb_iso);
@@ -610,7 +610,7 @@ static int cyasgadget_enable(
 	case USB_ENDPOINT_XFER_INT:
 		if (an_ep->cyepconfig.type != cy_as_usb_int) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			pr_debug("<1>_cy_as_gadget: "
 				"cy_as_usb_end_point_config EP %s mismatch "
 				"on type %d %d\n", an_ep->usb_ep_inst.name,
 				an_ep->cyepconfig.type, cy_as_usb_int);
@@ -621,7 +621,7 @@ static int cyasgadget_enable(
 	default:
 		if (an_ep->cyepconfig.type != cy_as_usb_bulk) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			pr_debug("<1>_cy_as_gadget: "
 				"cy_as_usb_end_point_config EP %s mismatch "
 				"on type %d %d\n", an_ep->usb_ep_inst.name,
 				an_ep->cyepconfig.type, cy_as_usb_bulk);
@@ -637,7 +637,7 @@ static int cyasgadget_enable(
 	if ((an_ep->cyepconfig.dir == cy_as_usb_in) &&
 	(!an_ep->is_in)) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>_cy_as_gadget: "
+		pr_debug("<1>_cy_as_gadget: "
 			"cy_as_usb_end_point_config EP %s mismatch "
 			"on dir %d %d\n", an_ep->usb_ep_inst.name,
 			an_ep->cyepconfig.dir, cy_as_usb_in);
@@ -646,7 +646,7 @@ static int cyasgadget_enable(
 	} else if ((an_ep->cyepconfig.dir == cy_as_usb_out) &&
 	(an_ep->is_in)) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>_cy_as_gadget: "
+		pr_debug("<1>_cy_as_gadget: "
 			"cy_as_usb_end_point_config EP %s mismatch "
 			"on dir %d %d\n", an_ep->usb_ep_inst.name,
 			an_ep->cyepconfig.dir, cy_as_usb_out);
@@ -657,7 +657,7 @@ static int cyasgadget_enable(
 	cy_as_usb_clear_stall(an_dev->dev_handle, an_ep->num,
 		cyasgadget_stallcallback, 0);
 
-	cy_as_hal_print_message("%s enabled %s (ep%d-%d) max %04x\n",
+	pr_debug("%s enabled %s (ep%d-%d) max %04x\n",
 		__func__, _ep->name, an_ep->num, tmp, max);
 
 	return 0;
@@ -757,7 +757,7 @@ static int cyasgadget_queue(
 	/* Call Async functions */
 	if (as_ep->is_in) {
 		#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			pr_debug("<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async being called "
 				"on ep %d\n", as_ep->num);
 		#endif
@@ -766,7 +766,7 @@ static int cyasgadget_queue(
 			as_ep->num, _req->length, _req->buf,
 			cy_false, cyasgadget_writecallback);
 		if (ret != CY_AS_ERROR_SUCCESS)
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			pr_debug("<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async failed with "
 				"error code %d\n", ret);
 		else
@@ -778,13 +778,13 @@ static int cyasgadget_queue(
 			cyasgadget_setupwritecallback);
 
 		if (ret != CY_AS_ERROR_SUCCESS)
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			pr_debug("<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async failed with error "
 				"code %d\n", ret);
 		*/
 		if ((cy_as_dev->outsetupreq) && (_req->length)) {
 			#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				pr_debug("<1>_cy_as_gadget: "
 					"cy_as_usb_read_data_async "
 					"being called on ep %d\n",
 					as_ep->num);
@@ -796,13 +796,13 @@ static int cyasgadget_queue(
 				cyasgadget_setupreadcallback);
 
 			if (ret != CY_AS_ERROR_SUCCESS)
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				pr_debug("<1>_cy_as_gadget: "
 				"cy_as_usb_read_data_async failed with "
 				"error code %d\n", ret);
 
 		} else {
 			#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				pr_debug("<1>_cy_as_gadget: "
 					"cy_as_usb_write_data_async "
 					"being called on ep %d\n",
 					as_ep->num);
@@ -813,14 +813,14 @@ static int cyasgadget_queue(
 			cyasgadget_setupwritecallback);
 
 			if (ret != CY_AS_ERROR_SUCCESS)
-				cy_as_hal_print_message("<1>_cy_as_gadget: "
+				pr_debug("<1>_cy_as_gadget: "
 				"cy_as_usb_write_data_async failed with "
 				"error code %d\n", ret);
 		}
 
 	} else if (list_empty(&as_ep->queue)) {
 		#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			pr_debug("<1>_cy_as_gadget: "
 				"cy_as_usb_read_data_async being called since "
 				"ep queue empty%d\n", ret);
 		#endif
@@ -829,7 +829,7 @@ static int cyasgadget_queue(
 			as_ep->num, cy_false, _req->length, _req->buf,
 			cyasgadget_readcallback);
 		if (ret != CY_AS_ERROR_SUCCESS)
-			cy_as_hal_print_message("<1>_cy_as_gadget: "
+			pr_debug("<1>_cy_as_gadget: "
 				"cy_as_usb_read_data_async failed with error "
 				"code %d\n", ret);
 		else
@@ -858,7 +858,7 @@ static int cyasgadget_dequeue(
 	dev = an_ep->dev;
 
 	#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>%s called\n", __func__);
+		pr_debug("<1>%s called\n", __func__);
 	#endif
 
 	cy_as_usb_cancel_async(dev->dev_handle, an_ep->num);
@@ -875,7 +875,7 @@ static int cyasgadget_set_halt(
 	int			retval = 0;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 
 	an_ep = container_of(_ep, cyasgadget_ep, usb_ep_inst);
@@ -913,7 +913,7 @@ static int cyasgadget_fifo_status(
 				)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 
 	return 0;
@@ -924,7 +924,7 @@ static void cyasgadget_fifo_flush(
 				)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 }
 
@@ -948,7 +948,7 @@ static int cyasgadget_get_frame(
 				)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 	return 0;
 }
@@ -958,7 +958,7 @@ static int cyasgadget_wakeup(
 					)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 	return 0;
 }
@@ -969,7 +969,7 @@ static int cyasgadget_set_selfpowered(
 					)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 	return 0;
 }
@@ -983,7 +983,7 @@ static int cyasgadget_pullup(
 	unsigned long   flags;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 
 	if (!_gadget)
@@ -1015,7 +1015,7 @@ static int cyasgadget_ioctl(
 	cyasgadget *dev = cy_as_gadget_controller;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called, code=%d, param=%ld\n",
+	pr_debug("<1>%s called, code=%d, param=%ld\n",
 		__func__, code, param);
 	#endif
 	/*
@@ -1024,7 +1024,7 @@ static int cyasgadget_ioctl(
 	 */
 	if (_IOC_TYPE(code) != CYASGADGET_IOC_MAGIC) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s, bad magic number = 0x%x\n",
+		pr_debug("%s, bad magic number = 0x%x\n",
 			__func__, _IOC_TYPE(code));
 		#endif
 		return -ENOTTY;
@@ -1032,7 +1032,7 @@ static int cyasgadget_ioctl(
 
 	if (_IOC_NR(code) > CYASGADGET_IOC_MAXNR) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s, bad ioctl code = 0x%x\n",
+		pr_debug("%s, bad ioctl code = 0x%x\n",
 			__func__, _IOC_NR(code));
 		#endif
 		return -ENOTTY;
@@ -1052,7 +1052,7 @@ static int cyasgadget_ioctl(
 			(void __user *)param, _IOC_SIZE(code));
 
 	if (err) {
-		cy_as_hal_print_message("%s, bad ioctl dir = 0x%x\n",
+		pr_debug("%s, bad ioctl dir = 0x%x\n",
 			__func__, _IOC_DIR(code));
 		return -EFAULT;
 	}
@@ -1064,7 +1064,7 @@ static int cyasgadget_ioctl(
 			(cy_as_gadget_ioctl_tmtp_status *)param;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: got CYASGADGET_GETMTPSTATUS\n",
+		pr_debug("%s: got CYASGADGET_GETMTPSTATUS\n",
 			__func__);
 		#endif
 
@@ -1089,7 +1089,7 @@ static int cyasgadget_ioctl(
 	case CYASGADGET_CLEARTMTPSTATUS:
 		{
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s got CYASGADGET_CLEARTMTPSTATUS\n",
+		pr_debug("%s got CYASGADGET_CLEARTMTPSTATUS\n",
 			__func__);
 		#endif
 
@@ -1110,7 +1110,7 @@ static int cyasgadget_ioctl(
 		struct file *file_to_allocate;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s got CYASGADGET_INITSOJ\n",
+		pr_debug("%s got CYASGADGET_INITSOJ\n",
 			__func__);
 		#endif
 
@@ -1130,7 +1130,7 @@ static int cyasgadget_ioctl(
 		if (copy_from_user(alloc_filename, k_d.file_name,
 			k_d.name_length + 1)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: CYASGADGET_INITSOJ, "
+			pr_debug("%s: CYASGADGET_INITSOJ, "
 				"copy file name from user space failed\n",
 				__func__);
 			#endif
@@ -1156,7 +1156,7 @@ static int cyasgadget_ioctl(
 			int ret_stat = 0;
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: fhandle is OK, "
+			pr_debug("%s: fhandle is OK, "
 				"calling vfs_getattr\n", __func__);
 			#endif
 
@@ -1164,7 +1164,7 @@ static int cyasgadget_ioctl(
 				file_to_allocate->f_path.dentry, &stat);
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: returned from "
+			pr_debug("%s: returned from "
 				"vfs_getattr() stat->blksize=0x%lx\n",
 				__func__, stat.blksize);
 			#endif
@@ -1198,12 +1198,12 @@ static int cyasgadget_ioctl(
 			#ifndef WESTBRIDGE_NDEBUG
 			/*check out how many pages where actually allocated */
 			if (mapping->nrpages != nr_pages)
-				cy_as_hal_print_message("%s mpage_cleardirty "
+				pr_debug("%s mpage_cleardirty "
 					"mapping->nrpages %d != num_pages %d\n",
 					__func__, (int) mapping->nrpages,
 					nr_pages);
 
-				cy_as_hal_print_message("%s: calling "
+				pr_debug("%s: calling "
 					"mpage_cleardirty() "
 					"for %d pages\n", __func__, nr_pages);
 			#endif
@@ -1219,7 +1219,7 @@ static int cyasgadget_ioctl(
 
 				#ifndef WESTBRIDGE_NDEBUG
 				if (alloc_inode->i_bytes == 0)
-						cy_as_hal_print_message(
+						pr_debug(
 						"%s: alloc_inode->ibytes =0\n",
 						__func__);
 				#endif
@@ -1238,7 +1238,7 @@ static int cyasgadget_ioctl(
 					/*no valid mapping*/
 					if (curr_blk_addr_map == 0) {
 						#ifndef WESTBRIDGE_NDEBUG
-						cy_as_hal_print_message(
+						pr_debug(
 							"%s:hit invalid "
 							"mapping\n", __func__);
 						#endif
@@ -1262,7 +1262,7 @@ static int cyasgadget_ioctl(
 
 						#ifndef WESTBRIDGE_NDEBUG
 						if (file_block_idx != 0)
-							cy_as_hal_print_message(
+							pr_debug(
 							 "<*> next table "
 							 "entry:%d required\n",
 							 blk_table_idx);
@@ -1281,12 +1281,12 @@ static int cyasgadget_ioctl(
 				/*print result for verification*/
 				{
 					int i;
-					cy_as_hal_print_message(
+					pr_debug(
 						"%s: print block table "
 						"mapping:\n",
 						__func__);
 					for (i = 0; i <= blk_table_idx; i++) {
-						cy_as_hal_print_message(
+						pr_debug(
 						"<1> %d 0x%x 0x%x\n", i,
 						blk_table.start_blocks[i],
 						blk_table.num_blocks[i]);
@@ -1319,7 +1319,7 @@ static int cyasgadget_ioctl(
 			dev->tmtp_need_new_blk_tbl = 0;
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"%s: calling cy_as_mtp_init_send_object()\n",
 				__func__);
 			#endif
@@ -1328,14 +1328,14 @@ static int cyasgadget_ioctl(
 				(cy_as_mtp_block_table *)&sg,
 				k_d.num_bytes, 0, 0);
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: returned from "
+			pr_debug("%s: returned from "
 				"cy_as_mtp_init_send_object()\n", __func__);
 			#endif
 
 		}
 		#ifndef WESTBRIDGE_NDEBUG
 		else {
-			cy_as_hal_print_message(
+			pr_debug(
 				"%s: failed to allocate the file %s\n",
 				__func__, alloc_filename);
 		} /* end if (file_to_allocate)*/
@@ -1359,7 +1359,7 @@ initsoj_safe_exit:
 		struct file *file_to_map;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message(
+		pr_debug(
 			"%s: got CYASGADGET_INITGOJ\n",
 				__func__);
 		#endif
@@ -1377,7 +1377,7 @@ initsoj_safe_exit:
 		if (copy_from_user(map_filename, k_d.file_name,
 			k_d.name_length + 1)) {
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message("%s: copy file name from "
+			pr_debug("%s: copy file name from "
 				"user space failed\n", __func__);
 			#endif
 			kfree(map_filename);
@@ -1385,7 +1385,7 @@ initsoj_safe_exit:
 		}
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<*>%s: opening %s for kernel "
+		pr_debug("<*>%s: opening %s for kernel "
 			"mode access map\n", __func__, map_filename);
 		#endif
 		file_to_map = filp_open(map_filename, O_RDWR, 0);
@@ -1402,7 +1402,7 @@ initsoj_safe_exit:
 			/*verify operation exists*/
 			if (a_ops->bmap) {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"<*>%s: bmap found, i_bytes=0x%x, "
 					"i_size=0x%x, i_blocks=0x%x\n",
 					__func__, inode->i_bytes,
@@ -1413,7 +1413,7 @@ initsoj_safe_exit:
 				k_d.num_bytes = inode->i_size;
 
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"<*>%s: k_d.num_bytes=0x%x\n",
 					__func__, k_d.num_bytes);
 				#endif
@@ -1428,7 +1428,7 @@ initsoj_safe_exit:
 					if (curr_blk_addr_map == 0) {
 						/*no valid mapping*/
 						#ifndef WESTBRIDGE_NDEBUG
-						cy_as_hal_print_message(
+						pr_debug(
 							"%s: no valid "
 							"mapping\n", __func__);
 						#endif
@@ -1443,7 +1443,7 @@ initsoj_safe_exit:
 						blk_table.num_blocks
 							[blk_table_idx]++;
 						#ifndef WESTBRIDGE_NDEBUG
-						cy_as_hal_print_message(
+						pr_debug(
 							"%s: found non-"
 							"contiguous break",
 							__func__);
@@ -1462,7 +1462,7 @@ initsoj_safe_exit:
 					int i = 0;
 
 					for (i = 0; i <= blk_table_idx; i++) {
-						cy_as_hal_print_message(
+						pr_debug(
 						"%s %d 0x%x 0x%x\n",
 						__func__, i,
 						blk_table.start_blocks[i],
@@ -1472,7 +1472,7 @@ initsoj_safe_exit:
 				#endif
 			} else {
 				#ifndef WESTBRIDGE_NDEBUG
-				cy_as_hal_print_message(
+				pr_debug(
 					"%s: could not find "
 					"a_ops->bmap\n", __func__);
 				#endif
@@ -1495,7 +1495,7 @@ initsoj_safe_exit:
 			sg_init_one(&sg, &blk_table, sizeof(blk_table));
 
 			#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"%s: calling cy_as_mtp_init_get_object() "
 				"start=0x%x, num =0x%x, tid=0x%x, "
 				"num_bytes=0x%x\n",
@@ -1512,7 +1512,7 @@ initsoj_safe_exit:
 				k_d.num_bytes, k_d.tid, 0, 0);
 			if (ret_stat != CY_AS_ERROR_SUCCESS) {
 					#ifndef WESTBRIDGE_NDEBUG
-					cy_as_hal_print_message(
+					pr_debug(
 						"%s: cy_as_mtp_init_get_object "
 						"failed ret_stat=0x%x\n",
 						__func__, ret_stat);
@@ -1521,7 +1521,7 @@ initsoj_safe_exit:
 		}
 		#ifndef WESTBRIDGE_NDEBUG
 		else {
-				cy_as_hal_print_message(
+				pr_debug(
 					"%s: failed to open file %s\n",
 					__func__, map_filename);
 		}
@@ -1539,7 +1539,7 @@ initsoj_safe_exit:
 			(cy_as_gadget_ioctl_cancel *)param;
 
 		#ifndef WESTBRIDGE_NDEBUG
-			cy_as_hal_print_message(
+			pr_debug(
 				"%s: got CYASGADGET_CANCELSOJ\n",
 				__func__);
 		#endif
@@ -1556,7 +1556,7 @@ initsoj_safe_exit:
 			(cy_as_gadget_ioctl_cancel *)param;
 
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: got CYASGADGET_CANCELGOJ\n",
+		pr_debug("%s: got CYASGADGET_CANCELGOJ\n",
 			__func__);
 		#endif
 
@@ -1569,10 +1569,10 @@ initsoj_safe_exit:
 	default:
 		{
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: unknown ioctl received: %d\n",
+		pr_debug("%s: unknown ioctl received: %d\n",
 			__func__, code);
 
-		cy_as_hal_print_message("%s: known codes:\n"
+		pr_debug("%s: known codes:\n"
 			"CYASGADGET_GETMTPSTATUS=%d\n"
 			"CYASGADGET_CLEARTMTPSTATUS=%d\n"
 			"CYASGADGET_INITSOJ=%d\n"
@@ -1617,7 +1617,7 @@ static void cyas_ep_reset(
 				)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 
 	an_ep->desc = NULL;
@@ -1640,7 +1640,7 @@ static void cyas_usb_reset(
 	#ifndef WESTBRIDGE_NDEBUG
 	cy_as_device *dev_p = (cy_as_device *)cy_as_dev->dev_handle;
 
-	cy_as_hal_print_message("<1>%s called mtp_firmware=0x%x\n",
+	pr_debug("<1>%s called mtp_firmware=0x%x\n",
 		__func__, dev_p->is_mtp_firmware);
 	#endif
 
@@ -1648,7 +1648,7 @@ static void cyas_usb_reset(
 		cy_as_bus_u_s_b);
 	if (ret != CY_AS_ERROR_SUCCESS && ret !=
 		CY_AS_ERROR_RESOURCE_NOT_OWNED) {
-		cy_as_hal_print_message("<1>_cy_as_gadget: cannot "
+		pr_debug("<1>_cy_as_gadget: cannot "
 			"release usb resource: failed with error code %d\n",
 			ret);
 		return;
@@ -1658,7 +1658,7 @@ static void cyas_usb_reset(
 
 	ret = cy_as_usb_start(cy_as_dev->dev_handle, 0, 0);
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("<1>_cy_as_gadget: "
+		pr_debug("<1>_cy_as_gadget: "
 			"cy_as_usb_start failed with error code %d\n",
 			ret);
 		return;
@@ -1674,7 +1674,7 @@ static void cyas_usb_reset(
 		ret = cy_as_mtp_start(cy_as_dev->dev_handle,
 			cy_as_gadget_mtp_event_callback, 0, 0);
 		if (ret == CY_AS_ERROR_SUCCESS)  {
-			cy_as_hal_print_message("MTP start passed, enumerating "
+			pr_debug("MTP start passed, enumerating "
 				"MTP interface\n");
 			config.mtp_interface = append_mtp;
 			/*Do not enumerate NAND storage*/
@@ -1684,7 +1684,7 @@ static void cyas_usb_reset(
 			config.devices_to_enumerate[1][0] = cy_true;
 		}
 	} else {
-		cy_as_hal_print_message("MTP start not attempted, not "
+		pr_debug("MTP start not attempted, not "
 			"enumerating MTP interface\n");
 		config.mtp_interface = 0;
 		/* enumerate mass storage based on module parameters */
@@ -1695,7 +1695,7 @@ static void cyas_usb_reset(
 	ret = cy_as_usb_set_enum_config(cy_as_dev->dev_handle,
 		&config, 0, 0);
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("<1>_cy_as_gadget: "
+		pr_debug("<1>_cy_as_gadget: "
 			"cy_as_usb_set_enum_config failed with error "
 			"code %d\n", ret);
 		return;
@@ -1717,7 +1717,7 @@ static void cyas_usb_reinit(
 	INIT_LIST_HEAD(&cy_as_dev->gadget.ep_list);
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called, is_mtp_firmware = "
+	pr_debug("<1>%s called, is_mtp_firmware = "
 		"0x%x\n", __func__, dev_p->is_mtp_firmware);
 	#endif
 
@@ -1758,7 +1758,7 @@ static void cyas_usb_reinit(
 	ret = cy_as_usb_set_end_point_config(an_ep_p->dev->dev_handle,
 		3, &an_ep_p->cyepconfig);
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("cy_as_usb_set_end_point_config "
+		pr_debug("cy_as_usb_set_end_point_config "
 			"failed with error code %d\n", ret);
 	}
 
@@ -1773,7 +1773,7 @@ static void cyas_usb_reinit(
 	ret = cy_as_usb_set_end_point_config(an_ep_p->dev->dev_handle,
 		5, &an_ep_p->cyepconfig);
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("cy_as_usb_set_end_point_config "
+		pr_debug("cy_as_usb_set_end_point_config "
 			"failed with error code %d\n", ret);
 	}
 
@@ -1788,7 +1788,7 @@ static void cyas_usb_reinit(
 	ret = cy_as_usb_set_end_point_config(an_ep_p->dev->dev_handle,
 		9, &an_ep_p->cyepconfig);
 	if (ret != CY_AS_ERROR_SUCCESS) {
-		cy_as_hal_print_message("cy_as_usb_set_end_point_config "
+		pr_debug("cy_as_usb_set_end_point_config "
 			"failed with error code %d\n", ret);
 	}
 
@@ -1833,14 +1833,14 @@ static void cyas_ep0_start(
 	cy_as_return_status_t ret;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 
 	ret = cy_as_usb_register_callback(dev->dev_handle,
 		cy_as_gadget_usb_event_callback);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: cy_as_usb_register_callback "
+		pr_debug("%s: cy_as_usb_register_callback "
 			"failed with error code %d\n", __func__, ret);
 		#endif
 		return;
@@ -1849,28 +1849,28 @@ static void cyas_ep0_start(
 	ret = cy_as_usb_commit_config(dev->dev_handle, 0, 0);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: cy_as_usb_commit_config "
+		pr_debug("%s: cy_as_usb_commit_config "
 			"failed with error code %d\n", __func__, ret);
 		#endif
 		return;
 	}
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("%s: cy_as_usb_commit_config "
+	pr_debug("%s: cy_as_usb_commit_config "
 		"message sent\n", __func__);
 	#endif
 
 	ret = cy_as_usb_connect(dev->dev_handle, 0, 0);
 	if (ret != CY_AS_ERROR_SUCCESS) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s: cy_as_usb_connect failed "
+		pr_debug("%s: cy_as_usb_connect failed "
 			"with error code %d\n", __func__, ret);
 		#endif
 		return;
 	}
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("%s: cy_as_usb_connect message "
+	pr_debug("%s: cy_as_usb_connect message "
 		"sent\n", __func__);
 	#endif
 }
@@ -1889,7 +1889,7 @@ int usb_gadget_probe_driver(struct usb_g
 	int		retval;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called driver=0x%x\n",
+	pr_debug("<1>%s called driver=0x%x\n",
 		__func__, (unsigned int) driver);
 	#endif
 
@@ -1921,7 +1921,7 @@ int usb_gadget_probe_driver(struct usb_g
 	retval = bind(&dev->gadget);
 	if (retval) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("%s bind to driver %s --> %d\n",
+		pr_debug("%s bind to driver %s --> %d\n",
 			__func__, driver->driver.name, retval);
 		#endif
 
@@ -1946,7 +1946,7 @@ static void cyasgadget_nuke(
 	cyasgadget	*dev = cy_as_gadget_controller;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 
 	cy_as_usb_cancel_async(dev->dev_handle, an_ep->num);
@@ -1969,7 +1969,7 @@ static void cyasgadget_stop_activity(
 	int index;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 
 	/* don't disconnect if it's not connected */
@@ -1999,14 +1999,14 @@ static void cyasgadget_stop_activity(
 		driver->disconnect(&dev->gadget);
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("cy_as_usb_disconnect returned success");
+	pr_debug("cy_as_usb_disconnect returned success");
 	#endif
 
 	/* Stop Usb */
 	cy_as_usb_stop(dev->dev_handle, 0, 0);
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("cy_as_usb_stop returned success");
+	pr_debug("cy_as_usb_stop returned success");
 	#endif
 }
 
@@ -2017,7 +2017,7 @@ int usb_gadget_unregister_driver(
 	cyasgadget	*dev = cy_as_gadget_controller;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 
 	if (!dev)
@@ -2033,7 +2033,7 @@ int usb_gadget_unregister_driver(
 	dev->driver = NULL;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("unregistered driver '%s'\n",
+	pr_debug("unregistered driver '%s'\n",
 		driver->driver.name);
 	#endif
 
@@ -2048,7 +2048,7 @@ static void cyas_gadget_release(
 	cyasgadget *dev = dev_get_drvdata(_dev);
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>%s called\n", __func__);
+	pr_debug("<1>%s called\n", __func__);
 	#endif
 
 	kfree(dev);
@@ -2060,12 +2060,12 @@ static void cyasgadget_deinit(
 			)
 {
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>_cy_as_gadget deinitialize called\n");
+	pr_debug("<1>_cy_as_gadget deinitialize called\n");
 	#endif
 
 	if (!cy_as_dev) {
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1>_cy_as_gadget_deinit: "
+		pr_debug("<1>_cy_as_gadget_deinit: "
 			"invalid cyasgadget device\n");
 		#endif
 		return;
@@ -2074,7 +2074,7 @@ static void cyasgadget_deinit(
 	if (cy_as_dev->driver) {
 		/* should have been done already by driver model core */
 		#ifndef WESTBRIDGE_NDEBUG
-		cy_as_hal_print_message("<1> cy_as_gadget: '%s' "
+		pr_debug("<1> cy_as_gadget: '%s' "
 			"is still registered\n",
 			cy_as_dev->driver->driver.name);
 		#endif
@@ -2092,18 +2092,18 @@ static int cyasgadget_initialize(void)
 	int		 retval = 0;
 
 	#ifndef WESTBRIDGE_NDEBUG
-	cy_as_hal_print_message("<1>_cy_as_gadget [V1.1] initialize called\n");
+	pr_debug("<1>_cy_as_gadget [V1.1] initialize called\n");
 	#endif
 
 	if (cy_as_gadget_controller != 0) {
-		cy_as_hal_print_message("<1> cy_as_gadget: the device has "
+		pr_debug("<1> cy_as_gadget: the device has "
 			"already been initilaized. ignoring\n");
 		return -EBUSY;
 	}
 
 	cy_as_dev = kzalloc(sizeof(cyasgadget), GFP_ATOMIC);
 	if (cy_as_dev == NULL) {
-		cy_as_hal_print_message("<1> cy_as_gadget: memory "
+		pr_debug("<1> cy_as_gadget: memory "
 			"allocation failed\n");
 		return -ENOMEM;
 	}
@@ -2121,7 +2121,7 @@ static int cyasgadget_initialize(void)
 	cy_as_dev->dev_handle = cyasdevice_getdevhandle();
 	if (0 == cy_as_dev->dev_handle) {
 		#ifndef NDEBUG
-		cy_as_hal_print_message("<1> cy_as_gadget: "
+		pr_debug("<1> cy_as_gadget: "
 			"no west bridge device\n");
 		#endif
 		retval = -EFAULT;

