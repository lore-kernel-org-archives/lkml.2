Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098Ab0FKC4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 22:56:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1042 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab0FKC4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 22:56:34 -0400
Subject: [PATCH] drivers/usb: Remove unnecessary return;s from void
 functions
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Jun 2010 19:56:33 -0700
Message-ID: <1276224993.1556.455.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are about 2500 void functions in drivers/usb
Only a few used return; at end of function.

Standardize them a bit.

Moved a statement down a line in drivers/usb/host/u132-hcd.c

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/gadget/at91_udc.c     |    1 -
 drivers/usb/gadget/f_audio.c      |    2 --
 drivers/usb/gadget/f_hid.c        |    4 ----
 drivers/usb/gadget/fsl_udc_core.c |    6 ------
 drivers/usb/gadget/langwell_udc.c |    3 ---
 drivers/usb/gadget/pxa27x_udc.c   |    2 --
 drivers/usb/gadget/rndis.c        |    2 --
 drivers/usb/host/ehci-hcd.c       |    1 -
 drivers/usb/host/ohci-hcd.c       |    1 -
 drivers/usb/host/oxu210hp-hcd.c   |    9 ---------
 drivers/usb/host/pci-quirks.c     |    2 --
 drivers/usb/host/u132-hcd.c       |    8 ++------
 drivers/usb/image/microtek.c      |    9 ---------
 drivers/usb/misc/ftdi-elan.c      |    2 --
 drivers/usb/mon/mon_main.c        |    2 --
 drivers/usb/musb/musb_gadget.c    |    1 -
 drivers/usb/serial/cypress_m8.c   |    2 --
 drivers/usb/serial/ftdi_sio.c     |    1 -
 drivers/usb/serial/garmin_gps.c   |    1 -
 drivers/usb/serial/io_edgeport.c  |   11 -----------
 drivers/usb/serial/io_ti.c        |    4 ----
 drivers/usb/serial/iuu_phoenix.c  |    1 -
 drivers/usb/serial/keyspan_pda.c  |    1 -
 drivers/usb/serial/mos7720.c      |    6 ------
 drivers/usb/serial/mos7840.c      |    7 -------
 drivers/usb/serial/omninet.c      |    2 --
 drivers/usb/serial/sierra.c       |    2 --
 drivers/usb/serial/spcp8x5.c      |    1 -
 drivers/usb/serial/usb_wwan.c     |    1 -
 drivers/usb/serial/whiteheat.c    |    6 ------
 30 files changed, 2 insertions(+), 99 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index eaa79c8..82dbe42 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1247,7 +1247,6 @@ write_in:
 	csr |= AT91_UDP_TXPKTRDY;
 	__raw_writel(csr, creg);
 	udc->req_pending = 0;
-	return;
 }
 
 static void handle_ep0(struct at91_udc *udc)
diff --git a/drivers/usb/gadget/f_audio.c b/drivers/usb/gadget/f_audio.c
index b91115f..185ffbf 100644
--- a/drivers/usb/gadget/f_audio.c
+++ b/drivers/usb/gadget/f_audio.c
@@ -317,8 +317,6 @@ static void f_audio_playback_work(struct work_struct *data)
 
 	u_audio_playback(&audio->card, play_buf->buf, play_buf->actual);
 	f_audio_buffer_free(play_buf);
-
-	return;
 }
 
 static int f_audio_out_ep_complete(struct usb_ep *ep, struct usb_request *req)
diff --git a/drivers/usb/gadget/f_hid.c b/drivers/usb/gadget/f_hid.c
index 1e00ff9..9447427 100644
--- a/drivers/usb/gadget/f_hid.c
+++ b/drivers/usb/gadget/f_hid.c
@@ -318,8 +318,6 @@ static void hidg_set_report_complete(struct usb_ep *ep, struct usb_request *req)
 	spin_unlock(&hidg->spinlock);
 
 	wake_up(&hidg->read_queue);
-
-	return;
 }
 
 static int hidg_setup(struct usb_function *f,
@@ -413,8 +411,6 @@ static void hidg_disable(struct usb_function *f)
 
 	usb_ep_disable(hidg->in_ep);
 	hidg->in_ep->driver_data = NULL;
-
-	return;
 }
 
 static int hidg_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 08a9a62..d933e63 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -287,8 +287,6 @@ static void dr_controller_run(struct fsl_udc *udc)
 	temp = fsl_readl(&dr_regs->usbcmd);
 	temp |= USB_CMD_RUN_STOP;
 	fsl_writel(temp, &dr_regs->usbcmd);
-
-	return;
 }
 
 static void dr_controller_stop(struct fsl_udc *udc)
@@ -308,8 +306,6 @@ static void dr_controller_stop(struct fsl_udc *udc)
 	tmp = fsl_readl(&dr_regs->usbcmd);
 	tmp &= ~USB_CMD_RUN_STOP;
 	fsl_writel(tmp, &dr_regs->usbcmd);
-
-	return;
 }
 
 static void dr_ep_setup(unsigned char ep_num, unsigned char dir,
@@ -416,8 +412,6 @@ static void struct_ep_qh_setup(struct fsl_udc *udc, unsigned char ep_num,
 	p_QH->max_pkt_length = cpu_to_le32(tmp);
 	p_QH->next_dtd_ptr = 1;
 	p_QH->size_ioc_int_sts = 0;
-
-	return;
 }
 
 /* Setup qh structure and ep register for ep0. */
diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index a391351..f1a0702 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -284,7 +284,6 @@ static void ep0_reset(struct langwell_udc *dev)
 	}
 
 	VDBG(dev, "<--- %s()\n", __func__);
-	return;
 }
 
 
@@ -1486,7 +1485,6 @@ static void langwell_udc_start(struct langwell_udc *dev)
 	writel(usbcmd, &dev->op_regs->usbcmd);
 
 	DBG(dev, "<--- %s()\n", __func__);
-	return;
 }
 
 
@@ -1509,7 +1507,6 @@ static void langwell_udc_stop(struct langwell_udc *dev)
 	writel(usbcmd, &dev->op_regs->usbcmd);
 
 	DBG(dev, "<--- %s()\n", __func__);
-	return;
 }
 
 
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 85b0d89..831a06c 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -1394,8 +1394,6 @@ static void pxa_ep_fifo_flush(struct usb_ep *_ep)
 	}
 
 	spin_unlock_irqrestore(&ep->lock, flags);
-
-	return;
 }
 
 /**
diff --git a/drivers/usb/gadget/rndis.c b/drivers/usb/gadget/rndis.c
index 5c0d06c..6cce940 100644
--- a/drivers/usb/gadget/rndis.c
+++ b/drivers/usb/gadget/rndis.c
@@ -915,8 +915,6 @@ void rndis_deregister (int configNr)
 
 	if (configNr >= RNDIS_MAX_CONFIGS) return;
 	rndis_per_dev_params [configNr].used = 0;
-
-	return;
 }
 
 int rndis_set_param_dev(u8 configNr, struct net_device *dev, u16 *cdc_filter)
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index a3ef2a9..6fcffe1 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -1041,7 +1041,6 @@ nogood:
 	ep->hcpriv = NULL;
 done:
 	spin_unlock_irqrestore (&ehci->lock, flags);
-	return;
 }
 
 static void
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index fc57655..3ba883c 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -370,7 +370,6 @@ sanitize:
 	}
 	ep->hcpriv = NULL;
 	spin_unlock_irqrestore (&ohci->lock, flags);
-	return;
 }
 
 static int ohci_get_frame (struct usb_hcd *hcd)
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index f608dfd..de9e1c3 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -544,8 +544,6 @@ static void oxu_buf_free(struct oxu_hcd *oxu, struct ehci_qtd *qtd)
 	qtd->buffer = NULL;
 
 	spin_unlock(&oxu->mem_lock);
-
-	return;
 }
 
 static inline void ehci_qtd_init(struct ehci_qtd *qtd, dma_addr_t dma)
@@ -571,8 +569,6 @@ static inline void oxu_qtd_free(struct oxu_hcd *oxu, struct ehci_qtd *qtd)
 	oxu->qtd_used[index] = 0;
 
 	spin_unlock(&oxu->mem_lock);
-
-	return;
 }
 
 static struct ehci_qtd *ehci_qtd_alloc(struct oxu_hcd *oxu)
@@ -615,8 +611,6 @@ static void oxu_qh_free(struct oxu_hcd *oxu, struct ehci_qh *qh)
 	oxu->qh_used[index] = 0;
 
 	spin_unlock(&oxu->mem_lock);
-
-	return;
 }
 
 static void qh_destroy(struct kref *kref)
@@ -693,8 +687,6 @@ static void oxu_murb_free(struct oxu_hcd *oxu, struct oxu_murb *murb)
 	oxu->murb_used[index] = 0;
 
 	spin_unlock(&oxu->mem_lock);
-
-	return;
 }
 
 static struct oxu_murb *oxu_murb_alloc(struct oxu_hcd *oxu)
@@ -3073,7 +3065,6 @@ nogood:
 	ep->hcpriv = NULL;
 done:
 	spin_unlock_irqrestore(&oxu->lock, flags);
-	return;
 }
 
 static int oxu_get_frame(struct usb_hcd *hcd)
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 83b5f9c..5b37b08 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -338,8 +338,6 @@ static void __devinit quirk_usb_disable_ehci(struct pci_dev *pdev)
 	writel(0x3f, op_reg_base + EHCI_USBSTS);
 
 	iounmap(base);
-
-	return;
 }
 
 /*
diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index 5b31bae..fab7649 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -316,7 +316,6 @@ static void u132_ring_requeue_work(struct u132 *u132, struct u132_ring *ring,
 	} else if (queue_delayed_work(workqueue, &ring->scheduler, 0))
 		return;
 	kref_put(&u132->kref, u132_hcd_delete);
-	return;
 }
 
 static void u132_ring_queue_work(struct u132 *u132, struct u132_ring *ring,
@@ -324,7 +323,6 @@ static void u132_ring_queue_work(struct u132 *u132, struct u132_ring *ring,
 {
 	kref_get(&u132->kref);
 	u132_ring_requeue_work(u132, ring, delta);
-	return;
 }
 
 static void u132_ring_cancel_work(struct u132 *u132, struct u132_ring *ring)
@@ -543,7 +541,6 @@ static void u132_hcd_giveback_urb(struct u132 *u132, struct u132_endp *endp,
 	mutex_unlock(&u132->scheduler_lock);
 	u132_endp_put_kref(u132, endp);
 	usb_hcd_giveback_urb(hcd, urb, status);
-	return;
 }
 
 static void u132_hcd_forget_urb(struct u132 *u132, struct u132_endp *endp,
@@ -574,8 +571,8 @@ static void u132_hcd_abandon_urb(struct u132 *u132, struct u132_endp *endp,
 		endp->active = 0;
 		spin_unlock_irqrestore(&endp->queue_lock.slock, irqs);
 		kfree(urbq);
-	} usb_hcd_giveback_urb(hcd, urb, status);
-	return;
+	}
+	usb_hcd_giveback_urb(hcd, urb, status);
 }
 
 static inline int edset_input(struct u132 *u132, struct u132_ring *ring,
@@ -3085,7 +3082,6 @@ static void u132_initialise(struct u132 *u132, struct platform_device *pdev)
 		u132->endp[endps] = NULL;
 
 	mutex_unlock(&u132->sw_lock);
-	return;
 }
 
 static int __devinit u132_probe(struct platform_device *pdev)
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 3a6bcd5..5a47805 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -398,7 +398,6 @@ void mts_int_submit_urb (struct urb* transfer,
 		context->srb->result = DID_ERROR << 16;
 		mts_transfer_cleanup(transfer);
 	}
-	return;
 }
 
 
@@ -409,7 +408,6 @@ static void mts_transfer_cleanup( struct urb *transfer )
 
 	if ( likely(context->final_callback != NULL) )
 		context->final_callback(context->srb);
-
 }
 
 static void mts_transfer_done( struct urb *transfer )
@@ -420,8 +418,6 @@ static void mts_transfer_done( struct urb *transfer )
 	context->srb->result |= (unsigned)(*context->scsi_status)<<1;
 
 	mts_transfer_cleanup(transfer);
-
-	return;
 }
 
 
@@ -452,8 +448,6 @@ static void mts_data_done( struct urb* transfer )
 	}
 
 	mts_get_status(transfer);
-
-	return;
 }
 
 
@@ -496,8 +490,6 @@ static void mts_command_done( struct urb *transfer )
 			mts_get_status(transfer);
 		}
 	}
-
-	return;
 }
 
 static void mts_do_sg (struct urb* transfer)
@@ -522,7 +514,6 @@ static void mts_do_sg (struct urb* transfer)
 			   sg[context->fragment].length,
 			   context->fragment + 1 == scsi_sg_count(context->srb) ?
 			   mts_data_done : mts_do_sg);
-	return;
 }
 
 static const u8 mts_read_image_sig[] = { 0x28, 00, 00, 00 };
diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 82e1663..d7e034a 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -456,7 +456,6 @@ static void ftdi_elan_cancel_targets(struct usb_ftdi *ftdi)
 static void ftdi_elan_kick_command_queue(struct usb_ftdi *ftdi)
 {
         ftdi_command_queue_work(ftdi, 0);
-        return;
 }
 
 static void ftdi_elan_command_work(struct work_struct *work)
@@ -483,7 +482,6 @@ static void ftdi_elan_command_work(struct work_struct *work)
 static void ftdi_elan_kick_respond_queue(struct usb_ftdi *ftdi)
 {
         ftdi_respond_queue_work(ftdi, 0);
-        return;
 }
 
 static void ftdi_elan_respond_work(struct work_struct *work)
diff --git a/drivers/usb/mon/mon_main.c b/drivers/usb/mon/mon_main.c
index 812dc28..1040511 100644
--- a/drivers/usb/mon/mon_main.c
+++ b/drivers/usb/mon/mon_main.c
@@ -90,7 +90,6 @@ static void mon_bus_submit(struct mon_bus *mbus, struct urb *urb)
 		r->rnf_submit(r->r_data, urb);
 	}
 	spin_unlock_irqrestore(&mbus->lock, flags);
-	return;
 }
 
 static void mon_submit(struct usb_bus *ubus, struct urb *urb)
@@ -117,7 +116,6 @@ static void mon_bus_submit_error(struct mon_bus *mbus, struct urb *urb, int erro
 		r->rnf_error(r->r_data, urb, error);
 	}
 	spin_unlock_irqrestore(&mbus->lock, flags);
-	return;
 }
 
 static void mon_submit_error(struct usb_bus *ubus, struct urb *urb, int error)
diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 6fca870..a83a139 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -829,7 +829,6 @@ void musb_g_rx(struct musb *musb, u8 epnum)
 		DBG(3, "packet waiting for %s%s request\n",
 				musb_ep->desc ? "" : "inactive ",
 				musb_ep->end_point.name);
-	return;
 }
 
 /* ------------------------------------------------------------ */
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index f5d0674..2edf238 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -1320,8 +1320,6 @@ continue_read:
 			cypress_set_dead(port);
 		}
 	}
-
-	return;
 } /* cypress_read_int_callback */
 
 
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 79dd1ae..e06f630 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2057,7 +2057,6 @@ static void ftdi_set_termios(struct tty_struct *tty,
 		/* lower DTR/RTS */
 		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 	}
-	return;
 }
 
 static int ftdi_tiocmget(struct tty_struct *tty, struct file *file)
diff --git a/drivers/usb/serial/garmin_gps.c b/drivers/usb/serial/garmin_gps.c
index a42b29a..26710b1 100644
--- a/drivers/usb/serial/garmin_gps.c
+++ b/drivers/usb/serial/garmin_gps.c
@@ -1264,7 +1264,6 @@ static void garmin_read_bulk_callback(struct urb *urb)
 		garmin_data_p->flags &= ~FLAGS_BULK_IN_ACTIVE;
 		spin_unlock_irqrestore(&garmin_data_p->lock, flags);
 	}
-	return;
 }
 
 
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index 76e6fb3..892e916 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -1465,8 +1465,6 @@ static void edge_throttle(struct tty_struct *tty)
 		if (status != 0)
 			return;
 	}
-
-	return;
 }
 
 
@@ -1770,8 +1768,6 @@ static void edge_break(struct tty_struct *tty, int break_state)
 			dbg("%s - error sending break set/clear command.",
 				__func__);
 	}
-
-	return;
 }
 
 
@@ -2042,7 +2038,6 @@ static void process_rcvd_status(struct edgeport_serial *edge_serial,
 		dbg("%s - Unrecognized IOSP status code %u", __func__, code);
 		break;
 	}
-	return;
 }
 
 
@@ -2095,8 +2090,6 @@ static void handle_new_msr(struct edgeport_port *edge_port, __u8 newMsr)
 
 	/* Save the new modem status */
 	edge_port->shadowMSR = newMsr & 0xf0;
-
-	return;
 }
 
 
@@ -2143,8 +2136,6 @@ static void handle_new_lsr(struct edgeport_port *edge_port, __u8 lsrData,
 		icount->parity++;
 	if (newLsr & LSR_FRM_ERR)
 		icount->frame++;
-
-	return;
 }
 
 
@@ -2720,7 +2711,6 @@ static void change_port_settings(struct tty_struct *tty,
 		baud = tty_termios_baud_rate(old_termios);
 		tty_encode_baud_rate(tty, baud, baud);
 	}
-	return;
 }
 
 
@@ -2922,7 +2912,6 @@ static void load_application_firmware(struct edgeport_serial *edge_serial)
 				    0x40, 0x4000, 0x0001, NULL, 0, 3000);
 
 	release_firmware(fw);
-	return;
 }
 
 
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 0fca265..4a6da66 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1571,8 +1571,6 @@ static void handle_new_msr(struct edgeport_port *edge_port, __u8 msr)
 		}
 	}
 	tty_kref_put(tty);
-
-	return;
 }
 
 static void handle_new_lsr(struct edgeport_port *edge_port, int lsr_data,
@@ -2424,7 +2422,6 @@ static void change_port_settings(struct tty_struct *tty,
 		dbg("%s - error %d when trying to write config to device",
 		     __func__, status);
 	kfree(config);
-	return;
 }
 
 static void edge_set_termios(struct tty_struct *tty,
@@ -2445,7 +2442,6 @@ static void edge_set_termios(struct tty_struct *tty,
 		return;
 	/* change the port settings to the new ones specified */
 	change_port_settings(tty, edge_port, old_termios);
-	return;
 }
 
 static int edge_tiocmset(struct tty_struct *tty, struct file *file,
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 74551cb..55766a6 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -801,7 +801,6 @@ static void read_rxcmd_callback(struct urb *urb)
 			  iuu_uart_read_callback, port);
 	result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
 	dbg("%s - submit result = %d", __func__, result);
-	return;
 }
 
 static int iuu_uart_on(struct usb_serial_port *port)
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index 185fe9a..a10dd56 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -292,7 +292,6 @@ static void keyspan_pda_rx_unthrottle(struct tty_struct *tty)
 	port->interrupt_in_urb->dev = port->serial->dev;
 	if (usb_submit_urb(port->interrupt_in_urb, GFP_KERNEL))
 		dbg(" usb_submit_urb(read urb) failed");
-	return;
 }
 
 
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 30922a7..f442333 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -827,7 +827,6 @@ exit:
 		dev_err(&urb->dev->dev,
 			"%s - Error %d submitting control urb\n",
 			__func__, result);
-	return;
 }
 
 /*
@@ -907,7 +906,6 @@ exit:
 		dev_err(&urb->dev->dev,
 			"%s - Error %d submitting control urb\n",
 			__func__, result);
-	return;
 }
 
 /*
@@ -1227,8 +1225,6 @@ static void mos7720_break(struct tty_struct *tty, int break_state)
 	mos7720_port->shadowLCR  = data;
 	write_mos_reg(serial, port->number - port->serial->minor,
 		      LCR, mos7720_port->shadowLCR);
-
-	return;
 }
 
 /*
@@ -1746,7 +1742,6 @@ static void change_port_settings(struct tty_struct *tty,
 			dbg("usb_submit_urb(read bulk) failed, status = %d",
 			    status);
 	}
-	return;
 }
 
 /*
@@ -1803,7 +1798,6 @@ static void mos7720_set_termios(struct tty_struct *tty,
 			dbg("usb_submit_urb(read bulk) failed, status = %d",
 			    status);
 	}
-	return;
 }
 
 /*
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 585b7e6..d3fc30c 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1355,8 +1355,6 @@ static void mos7840_break(struct tty_struct *tty, int break_state)
 	    mos7840_port->shadowLCR);
 	mos7840_set_uart_reg(port, LINE_CONTROL_REGISTER,
 			     mos7840_port->shadowLCR);
-
-	return;
 }
 
 /*****************************************************************************
@@ -1587,8 +1585,6 @@ static void mos7840_throttle(struct tty_struct *tty)
 		if (status < 0)
 			return;
 	}
-
-	return;
 }
 
 /*****************************************************************************
@@ -2063,8 +2059,6 @@ static void mos7840_change_port_settings(struct tty_struct *tty,
 	mos7840_port->delta_msr_cond = 1;
 	dbg("mos7840_change_port_settings mos7840_port->shadowLCR is End %x",
 	    mos7840_port->shadowLCR);
-
-	return;
 }
 
 /*****************************************************************************
@@ -2133,7 +2127,6 @@ static void mos7840_set_termios(struct tty_struct *tty,
 			mos7840_port->read_urb_busy = false;
 		}
 	}
-	return;
 }
 
 /*****************************************************************************
diff --git a/drivers/usb/serial/omninet.c b/drivers/usb/serial/omninet.c
index 89c724c..60f38d5 100644
--- a/drivers/usb/serial/omninet.c
+++ b/drivers/usb/serial/omninet.c
@@ -246,8 +246,6 @@ static void omninet_read_bulk_callback(struct urb *urb)
 		dev_err(&port->dev,
 			"%s - failed resubmitting read urb, error %d\n",
 			__func__, result);
-
-	return;
 }
 
 static int omninet_write(struct tty_struct *tty, struct usb_serial_port *port,
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index ef0bdb0..2840964 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -619,8 +619,6 @@ static void sierra_indat_callback(struct urb *urb)
 			dev_err(&port->dev, "resubmit read urb failed."
 				"(%d)\n", err);
 	}
-
-	return;
 }
 
 static void sierra_instat_callback(struct urb *urb)
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index 329d311..765aa98 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -441,7 +441,6 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 		spcp8x5_set_workMode(serial->dev, 0x000a,
 				     SET_WORKING_MODE_U2C, priv->type);
 	}
-	return;
 }
 
 /* open the serial port. do some usb system call. set termios and get the line
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index 0c70b4a..fbc9467 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -234,7 +234,6 @@ static void usb_wwan_indat_callback(struct urb *urb)
 		}
 
 	}
-	return;
 }
 
 static void usb_wwan_outdat_callback(struct urb *urb)
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 12ed820..3f9ac88 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -655,8 +655,6 @@ static void whiteheat_release(struct usb_serial *serial)
 		}
 		kfree(info);
 	}
-
-	return;
 }
 
 static int whiteheat_open(struct tty_struct *tty, struct usb_serial_port *port)
@@ -955,8 +953,6 @@ static void whiteheat_throttle(struct tty_struct *tty)
 	spin_lock_irq(&info->lock);
 	info->flags |= THROTTLED;
 	spin_unlock_irq(&info->lock);
-
-	return;
 }
 
 
@@ -975,8 +971,6 @@ static void whiteheat_unthrottle(struct tty_struct *tty)
 
 	if (actually_throttled)
 		rx_data_softint(&info->rx_work);
-
-	return;
 }
 
 


