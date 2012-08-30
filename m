Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab2H3LTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 07:19:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16583 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab2H3LTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 07:19:17 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-72-503f4c14b6a2
From: "SeungGoo, Kim" <nolja.kim@samsung.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org, "SeungGoo, Kim" <nolja.kim@samsung.com>
Subject: [PATCH] [PATCH] usbnet: code clean up using checkpatch
Date: Thu, 30 Aug 2012 20:18:41 +0900
Message-id: <1346325521-27388-1-git-send-email-nolja.kim@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jAV0RH/sAgxWHuSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG/DdHWAtW3GGquPr9NlsD458ZTF2MnBwSAiYS/w/PZISwxSQu
	3FvPBmILCSxilJiyXaOLkQvIXskkcW/bRVaQBJuArsTMLa/AmkUElCV+r5sA1MDBwSzgKbH7
	oT9IWFjAXuLP1cfsIDaLgKpEw4fTYPN5BVwlTvfuYofYpSDRuuwQ+wRG7gWMDKsYRVMLkguK
	k9JzDfWKE3OLS/PS9ZLzczcxgn34TGoH48oGi0OMAhyMSjy8HJl2AUKsiWXFlbmHGCU4mJVE
	eJm87AOEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zqdA6oWSE8sSc1OTS1ILYLJMnFwSjUwntHd
	G1N063j+2/mPLi6LVZo7S33iSaHLixgTHqfLL927wDFh/jwtQ93KCy8U7To22zH7cPqL3z90
	qc+crdXnna0ZV1V6Y4cnq+qqD6dlZj45trhp7ayFy5dabVsctPKlpS37VnvFUvG1k2e4irvO
	lJh82vtK4y215s8e8/fsfMi/8qHmv60T+5RYijMSDbWYi4oTAWsqPlndAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: SeungGoo, Kim <nolja.kim@samsung.com>
---
 drivers/net/usb/usbnet.c |  522 +++++++++++++++++++++++----------------------
 1 files changed, 267 insertions(+), 255 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 8531c1c..91bd08e 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -30,8 +30,10 @@
  * issues can usefully be addressed by this framework.
  */
 
-// #define	DEBUG			// error path messages, extra info
-// #define	VERBOSE			// more; success messages
+#if 0
+#define	DEBUG			/* error path messages, extra info */
+#define	VERBOSE			/* more; success messages */
+#endif
 
 #include <linux/module.h>
 #include <linux/init.h>
@@ -69,27 +71,27 @@
 #define	TX_QLEN(dev) (((dev)->udev->speed == USB_SPEED_HIGH) ? \
 			(RX_MAX_QUEUE_MEMORY/(dev)->hard_mtu) : 4)
 
-// reawaken network queue this soon after stopping; else watchdog barks
+/*  reawaken network queue this soon after stopping; else watchdog barks */
 #define TX_TIMEOUT_JIFFIES	(5*HZ)
 
-// throttle rx/tx briefly after some faults, so khubd might disconnect()
-// us (it polls at HZ/4 usually) before we report too many false errors.
+/* throttle rx/tx briefly after some faults, so khubd might disconnect()
+ * us (it polls at HZ/4 usually) before we report too many false errors. */
 #define THROTTLE_JIFFIES	(HZ/8)
 
-// between wakeups
+/* between wakeups */
 #define UNLINK_TIMEOUT_MS	3
 
 /*-------------------------------------------------------------------------*/
 
-// randomly generated ethernet address
-static u8	node_id [ETH_ALEN];
+/* randomly generated ethernet address */
+static u8	node_id[ETH_ALEN];
 
-static const char driver_name [] = "usbnet";
+static const char driver_name[] = "usbnet";
 
 /* use ethtool to change the level for any given device */
 static int msg_level = -1;
-module_param (msg_level, int, 0);
-MODULE_PARM_DESC (msg_level, "Override default message level");
+module_param(msg_level, int, 0);
+MODULE_PARM_DESC(msg_level, "Override default message level");
 
 /*-------------------------------------------------------------------------*/
 
@@ -145,15 +147,15 @@ int usbnet_get_endpoints(struct usbnet *dev, struct usb_interface *intf)
 
 	if (alt->desc.bAlternateSetting != 0 ||
 	    !(dev->driver_info->flags & FLAG_NO_SETINT)) {
-		tmp = usb_set_interface (dev->udev, alt->desc.bInterfaceNumber,
+		tmp = usb_set_interface(dev->udev, alt->desc.bInterfaceNumber,
 				alt->desc.bAlternateSetting);
 		if (tmp < 0)
 			return tmp;
 	}
 
-	dev->in = usb_rcvbulkpipe (dev->udev,
+	dev->in = usb_rcvbulkpipe(dev->udev,
 			in->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
-	dev->out = usb_sndbulkpipe (dev->udev,
+	dev->out = usb_sndbulkpipe(dev->udev,
 			out->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK);
 	dev->status = status;
 	return 0;
@@ -162,10 +164,10 @@ EXPORT_SYMBOL_GPL(usbnet_get_endpoints);
 
 int usbnet_get_ethernet_addr(struct usbnet *dev, int iMACAddress)
 {
-	int 		tmp, i;
-	unsigned char	buf [13];
+	int		tmp, i;
+	unsigned char	buf[13];
 
-	tmp = usb_string(dev->udev, iMACAddress, buf, sizeof buf);
+	tmp = usb_string(dev->udev, iMACAddress, buf, sizeof(buf));
 	if (tmp != 12) {
 		dev_dbg(&dev->udev->dev,
 			"bad MAC string %d fetch, %d\n", iMACAddress, tmp);
@@ -174,13 +176,13 @@ int usbnet_get_ethernet_addr(struct usbnet *dev, int iMACAddress)
 		return tmp;
 	}
 	for (i = tmp = 0; i < 6; i++, tmp += 2)
-		dev->net->dev_addr [i] =
+		dev->net->dev_addr[i] =
 			(hex_to_bin(buf[tmp]) << 4) + hex_to_bin(buf[tmp + 1]);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(usbnet_get_ethernet_addr);
 
-static void intr_complete (struct urb *urb)
+static void intr_complete(struct urb *urb)
 {
 	struct usbnet	*dev = urb->context;
 	int		status = urb->status;
@@ -206,16 +208,16 @@ static void intr_complete (struct urb *urb)
 		break;
 	}
 
-	if (!netif_running (dev->net))
+	if (!netif_running(dev->net))
 		return;
 
-	status = usb_submit_urb (urb, GFP_ATOMIC);
+	status = usb_submit_urb(urb, GFP_ATOMIC);
 	if (status != 0)
 		netif_err(dev, timer, dev->net,
 			  "intr resubmit --> %d\n", status);
 }
 
-static int init_status (struct usbnet *dev, struct usb_interface *intf)
+static int init_status(struct usbnet *dev, struct usb_interface *intf)
 {
 	char		*buf = NULL;
 	unsigned	pipe = 0;
@@ -225,20 +227,20 @@ static int init_status (struct usbnet *dev, struct usb_interface *intf)
 	if (!dev->driver_info->status)
 		return 0;
 
-	pipe = usb_rcvintpipe (dev->udev,
+	pipe = usb_rcvintpipe(dev->udev,
 			dev->status->desc.bEndpointAddress
 				& USB_ENDPOINT_NUMBER_MASK);
-	maxp = usb_maxpacket (dev->udev, pipe, 0);
+	maxp = usb_maxpacket(dev->udev, pipe, 0);
 
 	/* avoid 1 msec chatter:  min 8 msec poll rate */
-	period = max ((int) dev->status->desc.bInterval,
+	period = max((int) dev->status->desc.bInterval,
 		(dev->udev->speed == USB_SPEED_HIGH) ? 7 : 3);
 
-	buf = kmalloc (maxp, GFP_KERNEL);
+	buf = kmalloc(maxp, GFP_KERNEL);
 	if (buf) {
-		dev->interrupt = usb_alloc_urb (0, GFP_KERNEL);
+		dev->interrupt = usb_alloc_urb(0, GFP_KERNEL);
 		if (!dev->interrupt) {
-			kfree (buf);
+			kfree(buf);
 			return -ENOMEM;
 		} else {
 			usb_fill_int_urb(dev->interrupt, dev->udev, pipe,
@@ -256,7 +258,7 @@ static int init_status (struct usbnet *dev, struct usb_interface *intf)
  * Some link protocols batch packets, so their rx_fixup paths
  * can return clones as well as just modify the original skb.
  */
-void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
+void usbnet_skb_return(struct usbnet *dev, struct sk_buff *skb)
 {
 	int	status;
 
@@ -265,32 +267,30 @@ void usbnet_skb_return (struct usbnet *dev, struct sk_buff *skb)
 		return;
 	}
 
-	skb->protocol = eth_type_trans (skb, dev->net);
+	skb->protocol = eth_type_trans(skb, dev->net);
 	dev->net->stats.rx_packets++;
 	dev->net->stats.rx_bytes += skb->len;
 
 	netif_dbg(dev, rx_status, dev->net, "< rx, len %zu, type 0x%x\n",
-		  skb->len + sizeof (struct ethhdr), skb->protocol);
-	memset (skb->cb, 0, sizeof (struct skb_data));
+		  skb->len + sizeof(struct ethhdr), skb->protocol);
+	memset(skb->cb, 0, sizeof(struct skb_data));
 
 	if (skb_defer_rx_timestamp(skb))
 		return;
 
-	status = netif_rx (skb);
+	status = netif_rx(skb);
 	if (status != NET_RX_SUCCESS)
 		netif_dbg(dev, rx_err, dev->net,
 			  "netif_rx status %d\n", status);
 }
 EXPORT_SYMBOL_GPL(usbnet_skb_return);
 
-
 /*-------------------------------------------------------------------------
  *
  * Network Device Driver (peer link to "Host Device", from USB host)
  *
  *-------------------------------------------------------------------------*/
-
-int usbnet_change_mtu (struct net_device *net, int new_mtu)
+int usbnet_change_mtu(struct net_device *net, int new_mtu)
 {
 	struct usbnet	*dev = netdev_priv(net);
 	int		ll_mtu = new_mtu + net->hard_header_len;
@@ -299,7 +299,7 @@ int usbnet_change_mtu (struct net_device *net, int new_mtu)
 
 	if (new_mtu <= 0)
 		return -EINVAL;
-	// no second zero-length packet read wanted after mtu-sized packets
+	/* no second zero-length packet read wanted after mtu-sized packets */
 	if ((ll_mtu % dev->maxpacket) == 0)
 		return -EDOM;
 	net->mtu = new_mtu;
@@ -319,7 +319,7 @@ EXPORT_SYMBOL_GPL(usbnet_change_mtu);
 static void __usbnet_queue_skb(struct sk_buff_head *list,
 			struct sk_buff *newsk, enum skb_state state)
 {
-	struct skb_data *entry = (struct skb_data *) newsk->cb;
+	struct skb_data *entry = (struct skb_data *)newsk->cb;
 
 	__skb_queue_tail(list, newsk);
 	entry->state = state;
@@ -335,8 +335,8 @@ static enum skb_state defer_bh(struct usbnet *dev, struct sk_buff *skb,
 		struct sk_buff_head *list, enum skb_state state)
 {
 	unsigned long		flags;
-	enum skb_state 		old_state;
-	struct skb_data *entry = (struct skb_data *) skb->cb;
+	enum skb_state		old_state;
+	struct skb_data *entry = (struct skb_data *)skb->cb;
 
 	spin_lock_irqsave(&list->lock, flags);
 	old_state = entry->state;
@@ -356,10 +356,10 @@ static enum skb_state defer_bh(struct usbnet *dev, struct sk_buff *skb,
  * NOTE:  annoying asymmetry:  if it's active, schedule_work() fails,
  * but tasklet_schedule() doesn't.  hope the failure is rare.
  */
-void usbnet_defer_kevent (struct usbnet *dev, int work)
+void usbnet_defer_kevent(struct usbnet *dev, int work)
 {
-	set_bit (work, &dev->flags);
-	if (!schedule_work (&dev->kevent))
+	set_bit(work, &dev->flags);
+	if (!schedule_work(&dev->kevent))
 		netdev_err(dev->net, "kevent %d may have been dropped\n", work);
 	else
 		netdev_dbg(dev->net, "kevent %d scheduled\n", work);
@@ -368,9 +368,9 @@ EXPORT_SYMBOL_GPL(usbnet_defer_kevent);
 
 /*-------------------------------------------------------------------------*/
 
-static void rx_complete (struct urb *urb);
+static void rx_complete(struct urb *urb);
 
-static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
+static int rx_submit(struct usbnet *dev, struct urb *urb, gfp_t flags)
 {
 	struct sk_buff		*skb;
 	struct skb_data		*entry;
@@ -381,35 +381,35 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
 	skb = __netdev_alloc_skb_ip_align(dev->net, size, flags);
 	if (!skb) {
 		netif_dbg(dev, rx_err, dev->net, "no rx skb\n");
-		usbnet_defer_kevent (dev, EVENT_RX_MEMORY);
-		usb_free_urb (urb);
+		usbnet_defer_kevent(dev, EVENT_RX_MEMORY);
+		usb_free_urb(urb);
 		return -ENOMEM;
 	}
 
-	entry = (struct skb_data *) skb->cb;
+	entry = (struct skb_data *)skb->cb;
 	entry->urb = urb;
 	entry->dev = dev;
 	entry->length = 0;
 
-	usb_fill_bulk_urb (urb, dev->udev, dev->in,
+	usb_fill_bulk_urb(urb, dev->udev, dev->in,
 		skb->data, size, rx_complete, skb);
 
-	spin_lock_irqsave (&dev->rxq.lock, lockflags);
+	spin_lock_irqsave(&dev->rxq.lock, lockflags);
 
-	if (netif_running (dev->net) &&
-	    netif_device_present (dev->net) &&
-	    !test_bit (EVENT_RX_HALT, &dev->flags) &&
-	    !test_bit (EVENT_DEV_ASLEEP, &dev->flags)) {
-		switch (retval = usb_submit_urb (urb, GFP_ATOMIC)) {
+	if (netif_running(dev->net) &&
+	    netif_device_present(dev->net) &&
+	    !test_bit(EVENT_RX_HALT, &dev->flags) &&
+	    !test_bit(EVENT_DEV_ASLEEP, &dev->flags)) {
+		switch (retval = usb_submit_urb(urb, GFP_ATOMIC)) {
 		case -EPIPE:
-			usbnet_defer_kevent (dev, EVENT_RX_HALT);
+			usbnet_defer_kevent(dev, EVENT_RX_HALT);
 			break;
 		case -ENOMEM:
-			usbnet_defer_kevent (dev, EVENT_RX_MEMORY);
+			usbnet_defer_kevent(dev, EVENT_RX_MEMORY);
 			break;
 		case -ENODEV:
 			netif_dbg(dev, ifdown, dev->net, "device gone\n");
-			netif_device_detach (dev->net);
+			netif_device_detach(dev->net);
 			break;
 		case -EHOSTUNREACH:
 			retval = -ENOLINK;
@@ -417,7 +417,7 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
 		default:
 			netif_dbg(dev, rx_err, dev->net,
 				  "rx submit, %d\n", retval);
-			tasklet_schedule (&dev->bh);
+			tasklet_schedule(&dev->bh);
 			break;
 		case 0:
 			__usbnet_queue_skb(&dev->rxq, skb, rx_start);
@@ -426,10 +426,10 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
 		netif_dbg(dev, ifdown, dev->net, "rx: stopped\n");
 		retval = -ENOLINK;
 	}
-	spin_unlock_irqrestore (&dev->rxq.lock, lockflags);
+	spin_unlock_irqrestore(&dev->rxq.lock, lockflags);
 	if (retval) {
-		dev_kfree_skb_any (skb);
-		usb_free_urb (urb);
+		dev_kfree_skb_any(skb);
+		usb_free_urb(urb);
 	}
 	return retval;
 }
@@ -437,16 +437,16 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
 
 /*-------------------------------------------------------------------------*/
 
-static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
+static inline void rx_process(struct usbnet *dev, struct sk_buff *skb)
 {
 	if (dev->driver_info->rx_fixup &&
-	    !dev->driver_info->rx_fixup (dev, skb)) {
+	    !dev->driver_info->rx_fixup(dev, skb)) {
 		/* With RX_ASSEMBLE, rx_fixup() must update counters */
 		if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
 			dev->net->stats.rx_errors++;
 		goto done;
 	}
-	// else network stack removes extra byte if we forced a short packet
+	/* else network stack removes extra byte if we forced a short packet */
 
 	if (skb->len) {
 		/* all data was already cloned from skb inside the driver */
@@ -465,15 +465,15 @@ done:
 
 /*-------------------------------------------------------------------------*/
 
-static void rx_complete (struct urb *urb)
+static void rx_complete(struct urb *urb)
 {
-	struct sk_buff		*skb = (struct sk_buff *) urb->context;
-	struct skb_data		*entry = (struct skb_data *) skb->cb;
+	struct sk_buff		*skb = (struct sk_buff *)urb->context;
+	struct skb_data		*entry = (struct skb_data *)skb->cb;
 	struct usbnet		*dev = entry->dev;
 	int			urb_status = urb->status;
 	enum skb_state		state;
 
-	skb_put (skb, urb->actual_length);
+	skb_put(skb, urb->actual_length);
 	state = rx_done;
 	entry->urb = NULL;
 
@@ -496,8 +496,8 @@ static void rx_complete (struct urb *urb)
 	 */
 	case -EPIPE:
 		dev->net->stats.rx_errors++;
-		usbnet_defer_kevent (dev, EVENT_RX_HALT);
-		// FALLTHROUGH
+		usbnet_defer_kevent(dev, EVENT_RX_HALT);
+		/* FALLTHROUGH */
 
 	/* software-driven interface shutdown */
 	case -ECONNRESET:		/* async unlink */
@@ -514,8 +514,8 @@ static void rx_complete (struct urb *urb)
 	case -ETIME:
 	case -EILSEQ:
 		dev->net->stats.rx_errors++;
-		if (!timer_pending (&dev->delay)) {
-			mod_timer (&dev->delay, jiffies + THROTTLE_JIFFIES);
+		if (!timer_pending(&dev->delay)) {
+			mod_timer(&dev->delay, jiffies + THROTTLE_JIFFIES);
 			netif_dbg(dev, link, dev->net,
 				  "rx throttle %d\n", urb_status);
 		}
@@ -528,7 +528,7 @@ block:
 	/* data overrun ... flush fifo? */
 	case -EOVERFLOW:
 		dev->net->stats.rx_over_errors++;
-		// FALLTHROUGH
+		/* FALLTHROUGH */
 
 	default:
 		state = rx_cleanup;
@@ -540,14 +540,14 @@ block:
 	state = defer_bh(dev, skb, &dev->rxq, state);
 
 	if (urb) {
-		if (netif_running (dev->net) &&
-		    !test_bit (EVENT_RX_HALT, &dev->flags) &&
+		if (netif_running(dev->net) &&
+		    !test_bit(EVENT_RX_HALT, &dev->flags) &&
 		    state != unlink_start) {
-			rx_submit (dev, urb, GFP_ATOMIC);
+			rx_submit(dev, urb, GFP_ATOMIC);
 			usb_mark_last_busy(dev->udev);
 			return;
 		}
-		usb_free_urb (urb);
+		usb_free_urb(urb);
 	}
 	netif_dbg(dev, rx_err, dev->net, "no read resubmitted\n");
 }
@@ -588,22 +588,22 @@ EXPORT_SYMBOL_GPL(usbnet_purge_paused_rxq);
 
 /*-------------------------------------------------------------------------*/
 
-// unlink pending rx/tx; completion handlers do all other cleanup
+/* unlink pending rx/tx; completion handlers do all other cleanup */
 
-static int unlink_urbs (struct usbnet *dev, struct sk_buff_head *q)
+static int unlink_urbs(struct usbnet *dev, struct sk_buff_head *q)
 {
 	unsigned long		flags;
 	struct sk_buff		*skb;
 	int			count = 0;
 
-	spin_lock_irqsave (&q->lock, flags);
+	spin_lock_irqsave(&q->lock, flags);
 	while (!skb_queue_empty(q)) {
 		struct skb_data		*entry;
 		struct urb		*urb;
 		int			retval;
 
 		skb_queue_walk(q, skb) {
-			entry = (struct skb_data *) skb->cb;
+			entry = (struct skb_data *)skb->cb;
 			if (entry->state != unlink_start)
 				goto found;
 		}
@@ -621,9 +621,11 @@ found:
 		 */
 		usb_get_urb(urb);
 		spin_unlock_irqrestore(&q->lock, flags);
-		// during some PM-driven resume scenarios,
-		// these (async) unlinks complete immediately
-		retval = usb_unlink_urb (urb);
+		/*
+		 * during some PM-driven resume scenarios,
+		 * these (async) unlinks complete immediately
+		 */
+		retval = usb_unlink_urb(urb);
 		if (retval != -EINPROGRESS && retval != 0)
 			netdev_dbg(dev->net, "unlink urb err, %d\n", retval);
 		else
@@ -631,17 +633,19 @@ found:
 		usb_put_urb(urb);
 		spin_lock_irqsave(&q->lock, flags);
 	}
-	spin_unlock_irqrestore (&q->lock, flags);
+	spin_unlock_irqrestore(&q->lock, flags);
 	return count;
 }
 
-// Flush all pending rx urbs
-// minidrivers may need to do this when the MTU changes
+/*
+ * Flush all pending rx urbs
+ * minidrivers may need to do this when the MTU changes
+ */
 
 void usbnet_unlink_rx_urbs(struct usbnet *dev)
 {
 	if (netif_running(dev->net)) {
-		(void) unlink_urbs (dev, &dev->rxq);
+		(void)unlink_urbs(dev, &dev->rxq);
 		tasklet_schedule(&dev->bh);
 	}
 }
@@ -649,7 +653,7 @@ EXPORT_SYMBOL_GPL(usbnet_unlink_rx_urbs);
 
 /*-------------------------------------------------------------------------*/
 
-// precondition: never called in_interrupt
+/* precondition: never called in_interrupt */
 static void usbnet_terminate_urbs(struct usbnet *dev)
 {
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(unlink_wakeup);
@@ -677,14 +681,14 @@ static void usbnet_terminate_urbs(struct usbnet *dev)
 	remove_wait_queue(&unlink_wakeup, &wait);
 }
 
-int usbnet_stop (struct net_device *net)
+int usbnet_stop(struct net_device *net)
 {
 	struct usbnet		*dev = netdev_priv(net);
 	struct driver_info	*info = dev->driver_info;
 	int			retval;
 
 	clear_bit(EVENT_DEV_OPEN, &dev->flags);
-	netif_stop_queue (net);
+	netif_stop_queue(net);
 
 	netif_info(dev, ifdown, dev->net,
 		   "stop stats: rx/tx %lu/%lu, errs %lu/%lu\n",
@@ -715,8 +719,8 @@ int usbnet_stop (struct net_device *net)
 	 * else workers could deadlock; so make workers a NOP.
 	 */
 	dev->flags = 0;
-	del_timer_sync (&dev->delay);
-	tasklet_kill (&dev->bh);
+	del_timer_sync(&dev->delay);
+	tasklet_kill(&dev->bh);
 	if (info->manage_power)
 		info->manage_power(dev, 0);
 	else
@@ -728,17 +732,17 @@ EXPORT_SYMBOL_GPL(usbnet_stop);
 
 /*-------------------------------------------------------------------------*/
 
-// posts reads, and enables write queuing
+/* posts reads, and enables write queuing
+ * precondition: never called in_interrupt */
 
-// precondition: never called in_interrupt
-
-int usbnet_open (struct net_device *net)
+int usbnet_open(struct net_device *net)
 {
 	struct usbnet		*dev = netdev_priv(net);
 	int			retval;
 	struct driver_info	*info = dev->driver_info;
 
-	if ((retval = usb_autopm_get_interface(dev->intf)) < 0) {
+	retval = usb_autopm_get_interface(dev->intf);
+	if (retval < 0) {
 		netif_info(dev, ifup, dev->net,
 			   "resumption fail (%d) usbnet usb-%s-%s, %s\n",
 			   retval,
@@ -748,8 +752,9 @@ int usbnet_open (struct net_device *net)
 		goto done_nopm;
 	}
 
-	// put into "known safe" state
-	if (info->reset && (retval = info->reset (dev)) < 0) {
+	/* put into "known safe" state */
+	retval = info->reset(dev);
+	if (info->reset && retval < 0) {
 		netif_info(dev, ifup, dev->net,
 			   "open reset fail (%d) usbnet usb-%s-%s, %s\n",
 			   retval,
@@ -759,15 +764,16 @@ int usbnet_open (struct net_device *net)
 		goto done;
 	}
 
-	// insist peer be connected
-	if (info->check_connect && (retval = info->check_connect (dev)) < 0) {
+	/* insist peer be connected */
+	retval = info->check_connect(dev);
+	if (info->check_connect && retval < 0) {
 		netif_dbg(dev, ifup, dev->net, "can't open; %d\n", retval);
 		goto done;
 	}
 
 	/* start any status interrupt transfer */
 	if (dev->interrupt) {
-		retval = usb_submit_urb (dev->interrupt, GFP_KERNEL);
+		retval = usb_submit_urb(dev->interrupt, GFP_KERNEL);
 		if (retval < 0) {
 			netif_err(dev, ifup, dev->net,
 				  "intr submit %d\n", retval);
@@ -776,7 +782,7 @@ int usbnet_open (struct net_device *net)
 	}
 
 	set_bit(EVENT_DEV_OPEN, &dev->flags);
-	netif_start_queue (net);
+	netif_start_queue(net);
 	netif_info(dev, ifup, dev->net,
 		   "open: enable queueing (rx %d, tx %d) mtu %d %s framing\n",
 		   (int)RX_QLEN(dev), (int)TX_QLEN(dev),
@@ -788,8 +794,8 @@ int usbnet_open (struct net_device *net)
 		   (dev->driver_info->flags & FLAG_FRAMING_AX) ? "ASIX" :
 		   "simple");
 
-	// delay posting reads until we're fully open
-	tasklet_schedule (&dev->bh);
+	/* delay posting reads until we're fully open */
+	tasklet_schedule(&dev->bh);
 	if (info->manage_power) {
 		retval = info->manage_power(dev, 1);
 		if (retval < 0)
@@ -813,7 +819,7 @@ EXPORT_SYMBOL_GPL(usbnet_open);
  * they'll probably want to use this base set.
  */
 
-int usbnet_get_settings (struct net_device *net, struct ethtool_cmd *cmd)
+int usbnet_get_settings(struct net_device *net, struct ethtool_cmd *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
 
@@ -824,7 +830,7 @@ int usbnet_get_settings (struct net_device *net, struct ethtool_cmd *cmd)
 }
 EXPORT_SYMBOL_GPL(usbnet_get_settings);
 
-int usbnet_set_settings (struct net_device *net, struct ethtool_cmd *cmd)
+int usbnet_set_settings(struct net_device *net, struct ethtool_cmd *cmd)
 {
 	struct usbnet *dev = netdev_priv(net);
 	int retval;
@@ -843,13 +849,13 @@ int usbnet_set_settings (struct net_device *net, struct ethtool_cmd *cmd)
 }
 EXPORT_SYMBOL_GPL(usbnet_set_settings);
 
-u32 usbnet_get_link (struct net_device *net)
+u32 usbnet_get_link(struct net_device *net)
 {
 	struct usbnet *dev = netdev_priv(net);
 
 	/* If a check_connect is defined, return its result */
 	if (dev->driver_info->check_connect)
-		return dev->driver_info->check_connect (dev) == 0;
+		return dev->driver_info->check_connect(dev) == 0;
 
 	/* if the device has mii operations, use those */
 	if (dev->mii.mdio_read)
@@ -871,19 +877,19 @@ int usbnet_nway_reset(struct net_device *net)
 }
 EXPORT_SYMBOL_GPL(usbnet_nway_reset);
 
-void usbnet_get_drvinfo (struct net_device *net, struct ethtool_drvinfo *info)
+void usbnet_get_drvinfo(struct net_device *net, struct ethtool_drvinfo *info)
 {
 	struct usbnet *dev = netdev_priv(net);
 
-	strlcpy (info->driver, dev->driver_name, sizeof info->driver);
-	strlcpy (info->version, DRIVER_VERSION, sizeof info->version);
-	strlcpy (info->fw_version, dev->driver_info->description,
-		sizeof info->fw_version);
-	usb_make_path (dev->udev, info->bus_info, sizeof info->bus_info);
+	strlcpy(info->driver, dev->driver_name, sizeof(info->driver));
+	strlcpy(info->version, DRIVER_VERSION, sizeof(info->version));
+	strlcpy(info->fw_version, dev->driver_info->description,
+		sizeof(info->fw_version));
+	usb_make_path(dev->udev, info->bus_info, sizeof(info->bus_info));
 }
 EXPORT_SYMBOL_GPL(usbnet_get_drvinfo);
 
-u32 usbnet_get_msglevel (struct net_device *net)
+u32 usbnet_get_msglevel(struct net_device *net)
 {
 	struct usbnet *dev = netdev_priv(net);
 
@@ -891,7 +897,7 @@ u32 usbnet_get_msglevel (struct net_device *net)
 }
 EXPORT_SYMBOL_GPL(usbnet_get_msglevel);
 
-void usbnet_set_msglevel (struct net_device *net, u32 level)
+void usbnet_set_msglevel(struct net_device *net, u32 level)
 {
 	struct usbnet *dev = netdev_priv(net);
 
@@ -919,87 +925,89 @@ static const struct ethtool_ops usbnet_ethtool_ops = {
  * especially now that control transfers can be queued.
  */
 static void
-kevent (struct work_struct *work)
+kevent(struct work_struct *work)
 {
 	struct usbnet		*dev =
 		container_of(work, struct usbnet, kevent);
 	int			status;
 
 	/* usb_clear_halt() needs a thread context */
-	if (test_bit (EVENT_TX_HALT, &dev->flags)) {
-		unlink_urbs (dev, &dev->txq);
+	if (test_bit(EVENT_TX_HALT, &dev->flags)) {
+		unlink_urbs(dev, &dev->txq);
 		status = usb_autopm_get_interface(dev->intf);
 		if (status < 0)
 			goto fail_pipe;
-		status = usb_clear_halt (dev->udev, dev->out);
+		status = usb_clear_halt(dev->udev, dev->out);
 		usb_autopm_put_interface(dev->intf);
 		if (status < 0 &&
 		    status != -EPIPE &&
 		    status != -ESHUTDOWN) {
-			if (netif_msg_tx_err (dev))
+			if (netif_msg_tx_err(dev))
 fail_pipe:
 				netdev_err(dev->net, "can't clear tx halt, status %d\n",
 					   status);
 		} else {
-			clear_bit (EVENT_TX_HALT, &dev->flags);
+			clear_bit(EVENT_TX_HALT, &dev->flags);
 			if (status != -ESHUTDOWN)
-				netif_wake_queue (dev->net);
+				netif_wake_queue(dev->net);
 		}
 	}
-	if (test_bit (EVENT_RX_HALT, &dev->flags)) {
-		unlink_urbs (dev, &dev->rxq);
+	if (test_bit(EVENT_RX_HALT, &dev->flags)) {
+		unlink_urbs(dev, &dev->rxq);
 		status = usb_autopm_get_interface(dev->intf);
 		if (status < 0)
 			goto fail_halt;
-		status = usb_clear_halt (dev->udev, dev->in);
+		status = usb_clear_halt(dev->udev, dev->in);
 		usb_autopm_put_interface(dev->intf);
 		if (status < 0 &&
 		    status != -EPIPE &&
 		    status != -ESHUTDOWN) {
-			if (netif_msg_rx_err (dev))
+			if (netif_msg_rx_err(dev))
 fail_halt:
 				netdev_err(dev->net, "can't clear rx halt, status %d\n",
 					   status);
 		} else {
-			clear_bit (EVENT_RX_HALT, &dev->flags);
-			tasklet_schedule (&dev->bh);
+			clear_bit(EVENT_RX_HALT, &dev->flags);
+			tasklet_schedule(&dev->bh);
 		}
 	}
 
 	/* tasklet could resubmit itself forever if memory is tight */
-	if (test_bit (EVENT_RX_MEMORY, &dev->flags)) {
+	if (test_bit(EVENT_RX_MEMORY, &dev->flags)) {
 		struct urb	*urb = NULL;
 		int resched = 1;
 
-		if (netif_running (dev->net))
-			urb = usb_alloc_urb (0, GFP_KERNEL);
+		if (netif_running(dev->net))
+			urb = usb_alloc_urb(0, GFP_KERNEL);
 		else
-			clear_bit (EVENT_RX_MEMORY, &dev->flags);
+			clear_bit(EVENT_RX_MEMORY, &dev->flags);
 		if (urb != NULL) {
-			clear_bit (EVENT_RX_MEMORY, &dev->flags);
+			clear_bit(EVENT_RX_MEMORY, &dev->flags);
 			status = usb_autopm_get_interface(dev->intf);
 			if (status < 0) {
 				usb_free_urb(urb);
 				goto fail_lowmem;
 			}
-			if (rx_submit (dev, urb, GFP_KERNEL) == -ENOLINK)
+			if (rx_submit(dev, urb, GFP_KERNEL) == -ENOLINK)
 				resched = 0;
 			usb_autopm_put_interface(dev->intf);
 fail_lowmem:
 			if (resched)
-				tasklet_schedule (&dev->bh);
+				tasklet_schedule(&dev->bh);
 		}
 	}
 
-	if (test_bit (EVENT_LINK_RESET, &dev->flags)) {
+	if (test_bit(EVENT_LINK_RESET, &dev->flags)) {
 		struct driver_info	*info = dev->driver_info;
 		int			retval = 0;
 
-		clear_bit (EVENT_LINK_RESET, &dev->flags);
+		clear_bit(EVENT_LINK_RESET, &dev->flags);
 		status = usb_autopm_get_interface(dev->intf);
 		if (status < 0)
 			goto skip_reset;
-		if(info->link_reset && (retval = info->link_reset(dev)) < 0) {
+
+		retval = info->link_reset(dev);
+		if (info->link_reset && retval < 0) {
 			usb_autopm_put_interface(dev->intf);
 skip_reset:
 			netdev_info(dev->net, "link reset failed (%d) usbnet usb-%s-%s, %s\n",
@@ -1013,15 +1021,16 @@ skip_reset:
 	}
 
 	if (dev->flags)
-		netdev_dbg(dev->net, "kevent done, flags = 0x%lx\n", dev->flags);
+		netdev_dbg(dev->net, "kevent done, flags = 0x%lx\n",
+			dev->flags);
 }
 
 /*-------------------------------------------------------------------------*/
 
-static void tx_complete (struct urb *urb)
+static void tx_complete(struct urb *urb)
 {
-	struct sk_buff		*skb = (struct sk_buff *) urb->context;
-	struct skb_data		*entry = (struct skb_data *) skb->cb;
+	struct sk_buff		*skb = (struct sk_buff *)urb->context;
+	struct skb_data		*entry = (struct skb_data *)skb->cb;
 	struct usbnet		*dev = entry->dev;
 
 	if (urb->status == 0) {
@@ -1033,27 +1042,28 @@ static void tx_complete (struct urb *urb)
 
 		switch (urb->status) {
 		case -EPIPE:
-			usbnet_defer_kevent (dev, EVENT_TX_HALT);
+			usbnet_defer_kevent(dev, EVENT_TX_HALT);
 			break;
 
 		/* software-driven interface shutdown */
-		case -ECONNRESET:		// async unlink
-		case -ESHUTDOWN:		// hardware gone
+		case -ECONNRESET:		/* async unlink */
+		case -ESHUTDOWN:		/* hardware gone */
 			break;
 
-		// like rx, tx gets controller i/o faults during khubd delays
-		// and so it uses the same throttling mechanism.
+		/* like rx, tx gets controller i/o faults during khubd delays
+		 * and so it uses the same throttling mechanism.
+		 */
 		case -EPROTO:
 		case -ETIME:
 		case -EILSEQ:
 			usb_mark_last_busy(dev->udev);
-			if (!timer_pending (&dev->delay)) {
-				mod_timer (&dev->delay,
+			if (!timer_pending(&dev->delay)) {
+				mod_timer(&dev->delay,
 					jiffies + THROTTLE_JIFFIES);
 				netif_dbg(dev, link, dev->net,
 					  "tx throttle %d\n", urb->status);
 			}
-			netif_stop_queue (dev->net);
+			netif_stop_queue(dev->net);
 			break;
 		default:
 			netif_dbg(dev, tx_err, dev->net,
@@ -1063,25 +1073,25 @@ static void tx_complete (struct urb *urb)
 	}
 
 	usb_autopm_put_interface_async(dev->intf);
-	(void) defer_bh(dev, skb, &dev->txq, tx_done);
+	(void)defer_bh(dev, skb, &dev->txq, tx_done);
 }
 
 /*-------------------------------------------------------------------------*/
 
-void usbnet_tx_timeout (struct net_device *net)
+void usbnet_tx_timeout(struct net_device *net)
 {
 	struct usbnet		*dev = netdev_priv(net);
 
-	unlink_urbs (dev, &dev->txq);
-	tasklet_schedule (&dev->bh);
+	unlink_urbs(dev, &dev->txq);
+	tasklet_schedule(&dev->bh);
 
-	// FIXME: device recovery -- reset?
+	/* FIXME: device recovery -- reset? */
 }
 EXPORT_SYMBOL_GPL(usbnet_tx_timeout);
 
 /*-------------------------------------------------------------------------*/
 
-netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
+netdev_tx_t usbnet_start_xmit(struct sk_buff *skb,
 				     struct net_device *net)
 {
 	struct usbnet		*dev = netdev_priv(net);
@@ -1095,10 +1105,11 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 	if (skb)
 		skb_tx_timestamp(skb);
 
-	// some devices want funky USB-level framing, for
-	// win32 driver (usually) and/or hardware quirks
+	/* some devices want funky USB-level framing, for
+	 * win32 driver (usually) and/or hardware quirks
+	 */
 	if (info->tx_fixup) {
-		skb = info->tx_fixup (dev, skb, GFP_ATOMIC);
+		skb = info->tx_fixup(dev, skb, GFP_ATOMIC);
 		if (!skb) {
 			if (netif_msg_tx_err(dev)) {
 				netif_dbg(dev, tx_err, dev->net, "can't tx_fixup skb\n");
@@ -1110,18 +1121,18 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 		}
 	}
 	length = skb->len;
-
-	if (!(urb = usb_alloc_urb (0, GFP_ATOMIC))) {
+	urb = usb_alloc_urb(0, GFP_ATOMIC);
+	if (!urb) {
 		netif_dbg(dev, tx_err, dev->net, "no urb\n");
 		goto drop;
 	}
 
-	entry = (struct skb_data *) skb->cb;
+	entry = (struct skb_data *)skb->cb;
 	entry->urb = urb;
 	entry->dev = dev;
 	entry->length = length;
 
-	usb_fill_bulk_urb (urb, dev->udev, dev->out,
+	usb_fill_bulk_urb(urb, dev->udev, dev->out,
 			skb->data, skb->len, tx_complete, skb);
 
 	/* don't assume the hardware handles USB_ZERO_PACKET
@@ -1164,10 +1175,10 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 	}
 #endif
 
-	switch ((retval = usb_submit_urb (urb, GFP_ATOMIC))) {
+	switch ((retval = usb_submit_urb(urb, GFP_ATOMIC))) {
 	case -EPIPE:
-		netif_stop_queue (net);
-		usbnet_defer_kevent (dev, EVENT_TX_HALT);
+		netif_stop_queue(net);
+		usbnet_defer_kevent(dev, EVENT_TX_HALT);
 		usb_autopm_put_interface_async(dev->intf);
 		break;
 	default:
@@ -1178,10 +1189,10 @@ netdev_tx_t usbnet_start_xmit (struct sk_buff *skb,
 	case 0:
 		net->trans_start = jiffies;
 		__usbnet_queue_skb(&dev->txq, skb, tx_start);
-		if (dev->txq.qlen >= TX_QLEN (dev))
-			netif_stop_queue (net);
+		if (dev->txq.qlen >= TX_QLEN(dev))
+			netif_stop_queue(net);
 	}
-	spin_unlock_irqrestore (&dev->txq.lock, flags);
+	spin_unlock_irqrestore(&dev->txq.lock, flags);
 
 	if (retval) {
 		netif_dbg(dev, tx_err, dev->net, "drop, code %d\n", retval);
@@ -1189,8 +1200,8 @@ drop:
 		dev->net->stats.tx_dropped++;
 not_drop:
 		if (skb)
-			dev_kfree_skb_any (skb);
-		usb_free_urb (urb);
+			dev_kfree_skb_any(skb);
+		usb_free_urb(urb);
 	} else
 		netif_dbg(dev, tx_queued, dev->net,
 			  "> tx, len %d, type 0x%x\n", length, skb->protocol);
@@ -1218,42 +1229,41 @@ static void rx_alloc_submit(struct usbnet *dev, gfp_t flags)
 
 /*-------------------------------------------------------------------------*/
 
-// tasklet (work deferred from completions, in_irq) or timer
+/* tasklet (work deferred from completions, in_irq) or timer */
 
-static void usbnet_bh (unsigned long param)
+static void usbnet_bh(unsigned long param)
 {
 	struct usbnet		*dev = (struct usbnet *) param;
 	struct sk_buff		*skb;
 	struct skb_data		*entry;
 
-	while ((skb = skb_dequeue (&dev->done))) {
-		entry = (struct skb_data *) skb->cb;
+	while ((skb = skb_dequeue(&dev->done))) {
+		entry = (struct skb_data *)skb->cb;
 		switch (entry->state) {
 		case rx_done:
 			entry->state = rx_cleanup;
-			rx_process (dev, skb);
+			rx_process(dev, skb);
 			continue;
 		case tx_done:
 		case rx_cleanup:
-			usb_free_urb (entry->urb);
-			dev_kfree_skb (skb);
+			usb_free_urb(entry->urb);
+			dev_kfree_skb(skb);
 			continue;
 		default:
-			netdev_dbg(dev->net, "bogus skb state %d\n", entry->state);
+			netdev_dbg(dev->net, "bogus skb state %d\n",
+				entry->state);
 		}
 	}
 
-	// waiting for all pending urbs to complete?
+	/* waiting for all pending urbs to complete? */
 	if (dev->wait) {
-		if ((dev->txq.qlen + dev->rxq.qlen + dev->done.qlen) == 0) {
-			wake_up (dev->wait);
-		}
-
-	// or are we maybe short a few urbs?
-	} else if (netif_running (dev->net) &&
-		   netif_device_present (dev->net) &&
-		   !timer_pending (&dev->delay) &&
-		   !test_bit (EVENT_RX_HALT, &dev->flags)) {
+		if ((dev->txq.qlen + dev->rxq.qlen + dev->done.qlen) == 0)
+			wake_up(dev->wait);
+	/* or are we maybe short a few urbs? */
+	} else if (netif_running(dev->net) &&
+		   netif_device_present(dev->net) &&
+		   !timer_pending(&dev->delay) &&
+		   !test_bit(EVENT_RX_HALT, &dev->flags)) {
 		int	temp = dev->rxq.qlen;
 
 		if (temp < RX_QLEN(dev)) {
@@ -1263,10 +1273,10 @@ static void usbnet_bh (unsigned long param)
 					  "rxqlen %d --> %d\n",
 					  temp, dev->rxq.qlen);
 			if (dev->rxq.qlen < RX_QLEN(dev))
-				tasklet_schedule (&dev->bh);
+				tasklet_schedule(&dev->bh);
 		}
-		if (dev->txq.qlen < TX_QLEN (dev))
-			netif_wake_queue (dev->net);
+		if (dev->txq.qlen < TX_QLEN(dev))
+			netif_wake_queue(dev->net);
 	}
 }
 
@@ -1277,9 +1287,9 @@ static void usbnet_bh (unsigned long param)
  *
  *-------------------------------------------------------------------------*/
 
-// precondition: never called in_interrupt
+/* precondition: never called in_interrupt */
 
-void usbnet_disconnect (struct usb_interface *intf)
+void usbnet_disconnect(struct usb_interface *intf)
 {
 	struct usbnet		*dev;
 	struct usb_device	*xdev;
@@ -1290,7 +1300,7 @@ void usbnet_disconnect (struct usb_interface *intf)
 	if (!dev)
 		return;
 
-	xdev = interface_to_usbdev (intf);
+	xdev = interface_to_usbdev(intf);
 
 	netif_info(dev, probe, dev->net, "unregister '%s' usb-%s-%s, %s\n",
 		   intf->dev.driver->name,
@@ -1298,12 +1308,12 @@ void usbnet_disconnect (struct usb_interface *intf)
 		   dev->driver_info->description);
 
 	net = dev->net;
-	unregister_netdev (net);
+	unregister_netdev(net);
 
 	cancel_work_sync(&dev->kevent);
 
 	if (dev->driver_info->unbind)
-		dev->driver_info->unbind (dev, intf);
+		dev->driver_info->unbind(dev, intf);
 
 	usb_kill_urb(dev->interrupt);
 	usb_free_urb(dev->interrupt);
@@ -1318,13 +1328,13 @@ static const struct net_device_ops usbnet_netdev_ops = {
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
 /*-------------------------------------------------------------------------*/
 
-// precondition: never called in_interrupt
+/* precondition: never called in_interrupt */
 
 static struct device_type wlan_type = {
 	.name	= "wlan",
@@ -1335,16 +1345,16 @@ static struct device_type wwan_type = {
 };
 
 int
-usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
+usbnet_probe(struct usb_interface *udev, const struct usb_device_id *prod)
 {
-	struct usbnet			*dev;
-	struct net_device		*net;
-	struct usb_host_interface	*interface;
-	struct driver_info		*info;
-	struct usb_device		*xdev;
-	int				status;
-	const char			*name;
-	struct usb_driver 	*driver = to_usb_driver(udev->dev.driver);
+	struct usbnet		*dev;
+	struct net_device	*net;
+	struct driver_info	*info;
+	struct usb_device	*xdev;
+	int			status;
+	const char		*name;
+	struct usb_driver	*driver = to_usb_driver(udev->dev.driver);
+	struct usb_host_interface *interface;
 
 	/* usbnet already took usb runtime pm, so have to enable the feature
 	 * for usb interface, otherwise usb_autopm_get_interface may return
@@ -1356,17 +1366,17 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	}
 
 	name = udev->dev.driver->name;
-	info = (struct driver_info *) prod->driver_info;
+	info = (struct driver_info *)prod->driver_info;
 	if (!info) {
-		dev_dbg (&udev->dev, "blacklisted by %s\n", name);
+		dev_dbg(&udev->dev, "blacklisted by %s\n", name);
 		return -ENODEV;
 	}
-	xdev = interface_to_usbdev (udev);
+	xdev = interface_to_usbdev(udev);
 	interface = udev->cur_altsetting;
 
 	status = -ENOMEM;
 
-	// set up our own records
+	/* set up our own records */
 	net = alloc_etherdev(sizeof(*dev));
 	if (!net)
 		goto out;
@@ -1379,33 +1389,34 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->intf = udev;
 	dev->driver_info = info;
 	dev->driver_name = name;
-	dev->msg_enable = netif_msg_init (msg_level, NETIF_MSG_DRV
+	dev->msg_enable = netif_msg_init(msg_level, NETIF_MSG_DRV
 				| NETIF_MSG_PROBE | NETIF_MSG_LINK);
-	skb_queue_head_init (&dev->rxq);
-	skb_queue_head_init (&dev->txq);
-	skb_queue_head_init (&dev->done);
+	skb_queue_head_init(&dev->rxq);
+	skb_queue_head_init(&dev->txq);
+	skb_queue_head_init(&dev->done);
 	skb_queue_head_init(&dev->rxq_pause);
 	dev->bh.func = usbnet_bh;
-	dev->bh.data = (unsigned long) dev;
-	INIT_WORK (&dev->kevent, kevent);
+	dev->bh.data = (unsigned long)dev;
+	INIT_WORK(&dev->kevent, kevent);
 	init_usb_anchor(&dev->deferred);
 	dev->delay.function = usbnet_bh;
-	dev->delay.data = (unsigned long) dev;
-	init_timer (&dev->delay);
-	mutex_init (&dev->phy_mutex);
+	dev->delay.data = (unsigned long)dev;
+	init_timer(&dev->delay);
+	mutex_init(&dev->phy_mutex);
 
 	dev->net = net;
-	strcpy (net->name, "usb%d");
-	memcpy (net->dev_addr, node_id, sizeof node_id);
+	strcpy(net->name, "usb%d");
+	memcpy(net->dev_addr, node_id, sizeof(node_id));
 
 	/* rx and tx sides can use different message sizes;
 	 * bind() should set rx_urb_size in that case.
 	 */
 	dev->hard_mtu = net->mtu + net->hard_header_len;
 #if 0
-// dma_supported() is deeply broken on almost all architectures
-	// possible with some EHCI controllers
-	if (dma_supported (&udev->dev, DMA_BIT_MASK(64)))
+	/* dma_supported() is deeply broken on almost all architectures
+	 * possible with some EHCI controllers
+	 */
+	if (dma_supported(&udev->dev, DMA_BIT_MASK(64)))
 		net->features |= NETIF_F_HIGHDMA;
 #endif
 
@@ -1413,20 +1424,22 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	net->watchdog_timeo = TX_TIMEOUT_JIFFIES;
 	net->ethtool_ops = &usbnet_ethtool_ops;
 
-	// allow device-specific bind/init procedures
-	// NOTE net->name still not usable ...
+	/* allow device-specific bind/init procedures
+	 * NOTE net->name still not usable ...
+	 */
 	if (info->bind) {
-		status = info->bind (dev, udev);
+		status = info->bind(dev, udev);
 		if (status < 0)
 			goto out1;
 
-		// heuristic:  "usb%d" for links we know are two-host,
-		// else "eth%d" when there's reasonable doubt.  userspace
-		// can rename the link if it knows better.
+		/* heuristic:  "usb%d" for links we know are two-host,
+		 * else "eth%d" when there's reasonable doubt.  userspace
+		 * can rename the link if it knows better.
+		 */
 		if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
 		    ((dev->driver_info->flags & FLAG_POINTTOPOINT) == 0 ||
-		     (net->dev_addr [0] & 0x02) == 0))
-			strcpy (net->name, "eth%d");
+		     (net->dev_addr[0] & 0x02) == 0))
+			strcpy(net->name, "eth%d");
 		/* WLAN devices should always be named "wlan%d" */
 		if ((dev->driver_info->flags & FLAG_WLAN) != 0)
 			strcpy(net->name, "wlan%d");
@@ -1438,12 +1451,12 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		if (net->mtu > (dev->hard_mtu - net->hard_header_len))
 			net->mtu = dev->hard_mtu - net->hard_header_len;
 	} else if (!info->in || !info->out)
-		status = usbnet_get_endpoints (dev, udev);
+		status = usbnet_get_endpoints(dev, udev);
 	else {
-		dev->in = usb_rcvbulkpipe (xdev, info->in);
-		dev->out = usb_sndbulkpipe (xdev, info->out);
+		dev->in = usb_rcvbulkpipe(xdev, info->in);
+		dev->out = usb_sndbulkpipe(xdev, info->out);
 		if (!(info->flags & FLAG_NO_SETINT))
-			status = usb_set_interface (xdev,
+			status = usb_set_interface(xdev,
 				interface->desc.bInterfaceNumber,
 				interface->desc.bAlternateSetting);
 		else
@@ -1451,20 +1464,20 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 
 	}
 	if (status >= 0 && dev->status)
-		status = init_status (dev, udev);
+		status = init_status(dev, udev);
 	if (status < 0)
 		goto out3;
 
 	if (!dev->rx_urb_size)
 		dev->rx_urb_size = dev->hard_mtu;
-	dev->maxpacket = usb_maxpacket (dev->udev, dev->out, 1);
+	dev->maxpacket = usb_maxpacket(dev->udev, dev->out, 1);
 
 	if ((dev->driver_info->flags & FLAG_WLAN) != 0)
 		SET_NETDEV_DEVTYPE(net, &wlan_type);
 	if ((dev->driver_info->flags & FLAG_WWAN) != 0)
 		SET_NETDEV_DEVTYPE(net, &wwan_type);
 
-	status = register_netdev (net);
+	status = register_netdev(net);
 	if (status)
 		goto out4;
 	netif_info(dev, probe, dev->net,
@@ -1474,10 +1487,10 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		   dev->driver_info->description,
 		   net->dev_addr);
 
-	// ok, it's ready to go.
-	usb_set_intfdata (udev, dev);
+	/* ok, it's ready to go. */
+	usb_set_intfdata(udev, dev);
 
-	netif_device_attach (net);
+	netif_device_attach(net);
 
 	if (dev->driver_info->flags & FLAG_LINK_INTR)
 		netif_carrier_off(net);
@@ -1488,7 +1501,7 @@ out4:
 	usb_free_urb(dev->interrupt);
 out3:
 	if (info->unbind)
-		info->unbind (dev, udev);
+		info->unbind(dev, udev);
 out1:
 	free_netdev(net);
 out:
@@ -1503,7 +1516,7 @@ EXPORT_SYMBOL_GPL(usbnet_probe);
  * resume only when the last interface is resumed
  */
 
-int usbnet_suspend (struct usb_interface *intf, pm_message_t message)
+int usbnet_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct usbnet		*dev = usb_get_intfdata(intf);
 
@@ -1522,7 +1535,7 @@ int usbnet_suspend (struct usb_interface *intf, pm_message_t message)
 		 * accelerate emptying of the rx and queues, to avoid
 		 * having everything error out.
 		 */
-		netif_device_detach (dev->net);
+		netif_device_detach(dev->net);
 		usbnet_terminate_urbs(dev);
 		usb_kill_urb(dev->interrupt);
 
@@ -1530,13 +1543,13 @@ int usbnet_suspend (struct usb_interface *intf, pm_message_t message)
 		 * reattach so runtime management can use and
 		 * wake the device
 		 */
-		netif_device_attach (dev->net);
+		netif_device_attach(dev->net);
 	}
 	return 0;
 }
 EXPORT_SYMBOL_GPL(usbnet_suspend);
 
-int usbnet_resume (struct usb_interface *intf)
+int usbnet_resume(struct usb_interface *intf)
 {
 	struct usbnet		*dev = usb_get_intfdata(intf);
 	struct sk_buff          *skb;
@@ -1550,7 +1563,6 @@ int usbnet_resume (struct usb_interface *intf)
 
 		spin_lock_irq(&dev->txq.lock);
 		while ((res = usb_get_from_anchor(&dev->deferred))) {
-
 			skb = (struct sk_buff *)res->context;
 			retval = usb_submit_urb(res, GFP_ATOMIC);
 			if (retval < 0) {
@@ -1577,7 +1589,7 @@ int usbnet_resume (struct usb_interface *intf)
 
 			if (!(dev->txq.qlen >= TX_QLEN(dev)))
 				netif_tx_wake_all_queues(dev->net);
-			tasklet_schedule (&dev->bh);
+			tasklet_schedule(&dev->bh);
 		}
 	}
 	return 0;
-- 
1.7.0.4

