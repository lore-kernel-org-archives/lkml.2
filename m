Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965678Ab2B1QlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:41:04 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55485 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813Ab2B1QlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:41:01 -0500
From: Autif Khan <autifk@gmail.com>
To: gregkh@linuxfoundation.org, rusty@rustcorp.com.au, jhovold@gmail.com,
        stern@rowland.harvard.edu, mchehab@redhat.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Autif Khan <autifk@gmail.com>
Subject: [PATCH 3/3] drivers: net: usb: sierra_net - code formatting
Date: Tue, 28 Feb 2012 11:40:48 -0500
Message-Id: <1330447248-5848-1-git-send-email-autifk@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers: usb: serial: sierra - code formatting

Signed-off-by: Autif Khan <autifk@gmail.com>
---
 drivers/net/usb/sierra_net.c |   24 +++++++------
 drivers/usb/serial/sierra.c  |   74 ++++++++++++++++++++++--------------------
 2 files changed, 52 insertions(+), 46 deletions(-)

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index f6057d9..e8c9910 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -344,7 +344,7 @@ static void sierra_net_printk_buf(u8 *buf, u16 len)
 }
 
 static int sierra_net_send_cmd(struct usbnet *dev,
-		u8 *cmd, int cmdlen, const char * cmd_name)
+		u8 *cmd, int cmdlen, const char *cmd_name)
 {
 	struct sierra_net_data *priv = sierra_net_get_private(dev);
 	int  status;
@@ -371,7 +371,7 @@ static int sierra_net_send_sync(struct usbnet *dev)
 
 	status = sierra_net_send_cmd(dev, priv->sync_msg,
 			sizeof(priv->sync_msg), "SYNC");
-    return status;
+	return status;
 }
 
 static void sierra_net_send_shutdown(struct usbnet *dev)
@@ -581,8 +581,8 @@ static void sierra_net_kevent(struct work_struct *work)
 			case SIERRA_NET_HIP_RCGI:
 				/* Ignored. It is a firmware
 				 * workaround to solve a  Windows driver bug and
-				 * may be removed in the future. 
-				 */
+				 * may be removed in the future.
+				*/
 				break;
 			default:
 				netdev_err(dev->net, "Unrecognized HIP msg, "
@@ -610,9 +610,11 @@ static void sierra_net_defer_kevent(struct usbnet *dev, int work)
 
 	set_bit(work, &priv->kevent_flags);
 	if (!schedule_work(&priv->sierra_net_kevent))
-		dev_dbg(&dev->udev->dev, "sierra_net_kevent %d may have been dropped", work);
+		dev_dbg(&dev->udev->dev,
+			"sierra_net_kevent %d may have been dropped", work);
 	else
-		dev_dbg(&dev->udev->dev, "sierra_net_kevent %d scheduled", work);
+		dev_dbg(&dev->udev->dev,
+			"sierra_net_kevent %d scheduled", work);
 }
 
 /*
@@ -840,12 +842,12 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 	init_timer(&priv->sync_timer);
 	/* verify fw attributes */
 	status = sierra_net_get_fw_attr(dev, &fwattr);
-	dev_dbg(&dev->udev->dev, "Fw attr: %x\n", fwattr); 
+	dev_dbg(&dev->udev->dev, "Fw attr: %x\n", fwattr);
 	if (status == sizeof(fwattr) && (fwattr & SWI_GET_FW_ATTR_APM)) {
-/******************************************************************************* 
+/*******************************************************************************
  * If you want the default /sys/bus/usb/devices/.../.../power/level to be forced
  * to auto, the following needs to be compiled in.
- */ 
+*/
 #ifdef POWER_LEVEL_AUTO
 		/* make power level default be 'auto' */
 		dev_dbg(&dev->udev->dev, "Enabling APM");
@@ -973,7 +975,7 @@ static int sierra_net_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			ETH_HLEN);
 
 		ip = (struct iphdr *)((char *)skb->data + ETH_HLEN);
-		if(ip->version == 6) {
+		if (ip->version == 6) {
 			eth = (struct ethhdr *)skb->data;
 			eth->h_proto = cpu_to_be16(ETH_P_IPV6);
 		}
@@ -1023,7 +1025,7 @@ struct sk_buff *sierra_net_tx_fixup(struct usbnet *dev, struct sk_buff *skb,
 			}
 			build_hip(skb->data, len, priv);
 
-            sierra_net_printk_buf(skb->data, skb->len);
+			sierra_net_printk_buf(skb->data, skb->len);
 			return skb;
 		} else {
 			/*
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index e3ceda3..ddabfb3 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -205,7 +205,7 @@ static int is_himemory(const u8 ifnum,
 	if (himemorylist) {
 		info = himemorylist->ifaceinfo;
 
-		for (i=0; i < himemorylist->infolen; i++) {
+		for (i = 0; i < himemorylist->infolen; i++) {
 			if (info[i] == ifnum)
 				return 1;
 		}
@@ -292,11 +292,11 @@ static const struct sierra_iface_info typeB_interface_list = {
 /* 'blacklist' of interfaces not served by this driver */
 static const u8 direct_ip_non_serial_ifaces[] = { 7, 8, 9, 10, 11 };
 static const struct sierra_iface_info direct_ip_interface_blacklist = {
-	.infolen = ARRAY_SIZE( direct_ip_non_serial_ifaces ),
+	.infolen = ARRAY_SIZE(direct_ip_non_serial_ifaces),
 	.ifaceinfo = direct_ip_non_serial_ifaces,
 };
 
-static const struct usb_device_id id_table [] = {
+static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0F3D, 0x0112) }, /* Airprime/Sierra PC 5220 */
 	{ USB_DEVICE(0x03F0, 0x1B1D) },	/* HP ev2200 a.k.a MC5720 */
 	{ USB_DEVICE(0x03F0, 0x1E1D) },	/* HP hs2300 a.k.a MC8775 */
@@ -349,7 +349,7 @@ static const struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x1199, 0x683A) },	/* Sierra Wireless MC8785 */
 	{ USB_DEVICE(0x1199, 0x683B) },	/* Sierra Wireless MC8785 Composite */
 	/* Sierra Wireless MC8790, MC8791, MC8792 Composite */
-	{ USB_DEVICE(0x1199, 0x683C) },	
+	{ USB_DEVICE(0x1199, 0x683C) },
 	{ USB_DEVICE(0x1199, 0x683D) },	/* Sierra Wireless MC8791 Composite */
 	/* Sierra Wireless MC8790, MC8791, MC8792 */
 	{ USB_DEVICE(0x1199, 0x683E) },
@@ -372,19 +372,19 @@ static const struct usb_device_id id_table [] = {
 	{ USB_DEVICE(0x1199, 0x6893) },	/* Sierra Wireless Device */
 	/* Sierra Wireless Direct IP modems */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68A3, 0xFF, 0xFF, 0xFF),
-	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist 
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
 	/* AT&T Direct IP modems */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68A3, 0xFF, 0xFF, 0xFF),
-	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist 
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
 	/* Sierra Wireless Direct IP LTE modems */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x1199, 0x68AA, 0xFF, 0xFF, 0xFF),
-	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist 
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
 	/* AT&T Direct IP LTE modems */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0F3D, 0x68AA, 0xFF, 0xFF, 0xFF),
-	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist 
+	  .driver_info = (kernel_ulong_t)&direct_ip_interface_blacklist
 	},
 	/* Wireless 5720 VZW Mobile Broadband (EVDO Rev-A) Minicard GPS Port */
 	{ USB_DEVICE(0x413C, 0x8133) },
@@ -559,10 +559,16 @@ static ssize_t show_stats(struct device *dev,
 		"tx: %i B\toutdat: %i\toutdat err: %i\n"
 		"writes: %i\t\twrite err: %i\n"
 		"delayed writes: %i\tdelayed write err: %i\n",
-		atomic_read(&intfdata->stats.rx_bytes),	atomic_read(&intfdata->stats.indat_cb_cnt), atomic_read(&intfdata->stats.indat_cb_fail),
-		atomic_read(&intfdata->stats.tx_bytes), atomic_read(&intfdata->stats.outdat_cb_cnt), atomic_read(&intfdata->stats.outdat_cb_fail),
-		atomic_read(&intfdata->stats.write_cnt), atomic_read(&intfdata->stats.write_err),
-		atomic_read(&intfdata->stats.delayed_writes), atomic_read(&intfdata->stats.delayed_write_err)
+		atomic_read(&intfdata->stats.rx_bytes),
+		atomic_read(&intfdata->stats.indat_cb_cnt),
+		atomic_read(&intfdata->stats.indat_cb_fail),
+		atomic_read(&intfdata->stats.tx_bytes),
+		atomic_read(&intfdata->stats.outdat_cb_cnt),
+		atomic_read(&intfdata->stats.outdat_cb_fail),
+		atomic_read(&intfdata->stats.write_cnt),
+		atomic_read(&intfdata->stats.write_err),
+		atomic_read(&intfdata->stats.delayed_writes),
+		atomic_read(&intfdata->stats.delayed_write_err)
 	);
 }
 
@@ -578,7 +584,7 @@ static int sierra_create_sysfs_attrs(struct usb_serial_port *port)
 	int result = 0;
 
 	result = device_create_file(&port->dev, &dev_attr_stats);
-	if (unlikely (result < 0)) 
+	if (unlikely(result < 0))
 		return result;
 	return device_create_file(&port->dev, &dev_attr_suspend_status);
 }
@@ -622,7 +628,7 @@ static void sierra_outdat_callback(struct urb *urb)
 }
 
 /* Write */
-static int sierra_write(struct tty_struct *tty, 
+static int sierra_write(struct tty_struct *tty,
 			struct usb_serial_port *port,
 			const unsigned char *buf, int count)
 {
@@ -681,7 +687,7 @@ static int sierra_write(struct tty_struct *tty,
 		return -ENOMEM;
 	}
 
-	memcpy(buffer, buf, writesize); 
+	memcpy(buffer, buf, writesize);
 
 	usb_serial_debug_data(debug, &port->dev, __func__, writesize, buffer);
 
@@ -700,7 +706,7 @@ static int sierra_write(struct tty_struct *tty,
 	if (intfdata->suspended) {
 		usb_anchor_urb(urb, &portdata->delayed);
 		spin_unlock_irqrestore(&intfdata->susp_lock, flags);
-		/* release our reference to this urb, the USB core will 
+		/* release our reference to this urb, the USB core will
 		 * eventually free it entirely */
 		usb_free_urb(urb);
 		return writesize;
@@ -730,7 +736,7 @@ static int sierra_write(struct tty_struct *tty,
 	}
 	/* release our reference to this urb, the USB core will eventually
 	 * free it entirely */
-	usb_free_urb(urb); 
+	usb_free_urb(urb);
 
 	return writesize;
 }
@@ -810,7 +816,7 @@ static void sierra_instat_callback(struct urb *urb)
 		 * make sure we received that many bytes
 		 */
 		if (urb->actual_length >= sizeof(*req_pkt) + sizeof(*sigp) &&
-			req_pkt->bRequestType == USB_REQUEST_TYPE_CLASS && 
+			req_pkt->bRequestType == USB_REQUEST_TYPE_CLASS &&
 			req_pkt->bRequest == USB_REQUEST_IFACE) {
 			int old_dcd_state;
 			const u16 signals = get_unaligned_le16(sigp);
@@ -864,9 +870,8 @@ static int sierra_write_room(struct tty_struct *tty)
 	retval = MAX_TRANSFER;
 
 	spin_lock_irqsave(&portdata->lock, flags);
-	if (portdata->outstanding_urbs >= portdata->num_out_urbs) {
+	if (portdata->outstanding_urbs >= portdata->num_out_urbs)
 		retval = 0;
-	}
 	spin_unlock_irqrestore(&portdata->lock, flags);
 
 	return retval;
@@ -990,7 +995,7 @@ static void sierra_close(struct usb_serial_port *port)
 			sierra_release_urb(portdata->in_urbs[i]);
 			portdata->in_urbs[i] = NULL;
 		}
-		while((urb = usb_get_from_anchor(&portdata->delayed))) {
+		while ((urb = usb_get_from_anchor(&portdata->delayed))) {
 			sierra_release_urb(urb);
 			usb_autopm_put_interface(serial->interface);
 		}
@@ -1053,7 +1058,7 @@ static int sierra_open(struct tty_struct *tty, struct usb_serial_port *port)
 			sierra_release_urb(portdata->in_urbs[i]);
 			portdata->in_urbs[i] = NULL;
 		}
-		while((urb = usb_get_from_anchor(&portdata->delayed))) {
+		while ((urb = usb_get_from_anchor(&portdata->delayed))) {
 			sierra_release_urb(urb);
 			usb_autopm_put_interface(serial->interface);
 		}
@@ -1111,9 +1116,9 @@ static int sierra_startup(struct usb_serial *serial)
 		sierra_vsc_set_nmea(serial->dev, 1);
 
 	if (serial->num_ports) {
-		/* Note: One big piece of memory is allocated for all ports 
-		 * private data in one shot. This memory is split into equal 
-		 * pieces for each port. 
+		/* Note: One big piece of memory is allocated for all ports
+		 * private data in one shot. This memory is split into equal
+		 * pieces for each port.
 		 */
 		portdata = (struct sierra_port_private *)kzalloc
 			(sizeof(*portdata) * serial->num_ports, GFP_KERNEL);
@@ -1149,8 +1154,7 @@ static int sierra_startup(struct usb_serial *serial)
 				portdata->num_out_urbs = N_OUT_URB_HM;
 				portdata->num_in_urbs  = N_IN_URB_HM;
 			}
-		}
-		else {
+		} else {
 			himemoryp =
 			    (struct sierra_iface_info *)&typeA_interface_list;
 			if (is_himemory(i, himemoryp)) {
@@ -1158,22 +1162,22 @@ static int sierra_startup(struct usb_serial *serial)
 				portdata->num_in_urbs  = N_IN_URB_HM;
 			}
 		}
-		dev_dbg(&serial->dev->dev, 
+		dev_dbg(&serial->dev->dev,
 			"Memory usage (urbs) interface #%d, in=%d, out=%d\n",
-			ifnum,portdata->num_in_urbs, portdata->num_out_urbs );
+			ifnum, portdata->num_in_urbs, portdata->num_out_urbs);
 		/* Set the port private data pointer */
 		usb_set_serial_port_data(port, portdata);
 	}
 	serial->interface->needs_remote_wakeup = 1;
 
 	result = sierra_get_fw_attr(serial->dev, &fw_attr);
-	if (result == sizeof(fw_attr) && (fw_attr & SWI_FW_ATTR_PM_MASK) ) {
+	if (result == sizeof(fw_attr) && (fw_attr & SWI_FW_ATTR_PM_MASK)) {
 		dev_info(&serial->dev->dev,
 			"APM supported, enabling autosuspend.\n");
-/******************************************************************************* 
+/*******************************************************************************
  * If you want the default /sys/bus/usb/devices/.../.../power/level to be forced
  * to auto, the following needs to be compiled in.
- */ 
+ */
 #ifdef POWER_LEVEL_AUTO
 		/* make power level default be 'auto' */
 		usb_enable_autosuspend(serial->dev);
@@ -1196,12 +1200,12 @@ static void sierra_release(struct usb_serial *serial)
 	if (serial->num_ports > 0) {
 		port = serial->port[0];
 		if (port)
-			/* Note: The entire piece of memory that was allocated 
+			/* Note: The entire piece of memory that was allocated
 			 * in the startup routine can be released by passing
 			 * a pointer to the beginning of the piece.
 			 * This address corresponds to the address of the chunk
 			 * that was given to port 0.
-		 	 */
+			*/
 			kfree(usb_get_serial_port_data(port));
 	}
 
@@ -1265,7 +1269,7 @@ static int sierra_resume(struct usb_serial *serial)
 	int failed_submits;
 
 	dev_dbg(&serial->dev->dev, "%s\n", __func__);
-	
+
 	spin_lock_irq(&intfdata->susp_lock);
 	for (i = 0; i < serial->num_ports; i++) {
 		port = serial->port[i];
-- 
1.7.5.4

