Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229Ab2LXNwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 08:52:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:39507 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2LXNv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 08:51:56 -0500
X-AuditID: cbfee61b-b7f616d00000319b-e2-50d85dfaa119
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com,
        Doug Anderson <dianders@chromium.org>
Subject: [PATCH RFC] usb: dwc3: Remove dwc3 dependency on gadget.
Date: Mon, 24 Dec 2012 19:28:33 +0530
Message-id: <1356357513-8892-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWyRsSkTvdX7I0Ag/93pCwu75rDZjF7ST+L
	xaJlrcwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZXRdaWcqOCBXse/bbfYGxsOSXYycHBICJhJr
	Xt9ghrDFJC7cW8/WxcjFISSwlFGi5VAbG0zR5nedUIlFjBJ7105hgnAmM0kcuj6DEaSKTUBX
	ountLjBbREBW4vCV38wgRcwC/YwSB9d1gu0QFnCU6N0+F2wsi4CqxLvGpWBxXgF3ick3T0Ld
	oSDx5vYzZogaAYlvkw+xdDFyAMVlJTYdAJspIXCETeLRqVdQ9ZISB1fcYJnAKLiAkWEVo2hq
	QXJBcVJ6rpFecWJucWleul5yfu4mRmConf73THoH46oGi0OMAhyMSjy8kXOvBwixJpYVV+Ye
	YpTgYFYS4VWQuREgxJuSWFmVWpQfX1Sak1p8iNEH6JKJzFKiyfnAOMgriTc0NjE3NTa1NDIy
	MzXFIawkztvskRIgJJCeWJKanZpakFoEM46Jg1OqgXGeHmfeT/0FPrt3LIwuFbx8b5Z2bHn7
	hE/iLMJHv4j8uTo3m2fxvNY9bmd1rytU7+W+Ou2Sl4nosTmzHOffuXMjcafZpv+ZE97yr7Ta
	c8fYfvWb5EWf3/0pLb+aVfpC48SnhGMFfgdWdt/e/cvkbkbN/99fn7HV70huvLdo5r4tz58b
	nLFZVduposRSnJFoqMVcVJwIAB473hJiAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9jAd1fsTcCDH5d4LG4vGsOm8XsJf0s
	FouWtTI7MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jRdaWd
	qeCAXMW+b7fZGxgPS3YxcnJICJhIbH7XyQZhi0lcuLceyObiEBJYxCixd+0UJghnMpPEoesz
	GEGq2AR0JZre7gKzRQRkJQ5f+c0MUsQs0M8ocXBdJzNIQljAUaJ3+1ywsSwCqhLvGpeCxXkF
	3CUm3zzJDLFOQeLN7WfMExi5FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDuRn0jsY
	VzVYHGIU4GBU4uGNnHs9QIg1say4MvcQowQHs5IIr4LMjQAh3pTEyqrUovz4otKc1OJDjD5A
	2ycyS4km5wOjLK8k3tDYxNzU2NTSxMLEzBKHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkG
	Rq96tyqVhqmWvbZzP6enBIa9cs58s0B07x9f1h1z739QLbr5w7Xg1qMTn+7qb9oZUdX7JUHk
	seLNfc7iPXo/331NWZP5qpOxat29lccuveu34Wc0NLGbWj/liiCPzLNAg3Wra1/7r1Sbtq6y
	KX6rpI+hs3/huV696B8WL2S5P6bYbbov4tB8W4mlOCPRUIu5qDgRAAIQmWWRAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DWC3 controller curretly depends on CONFIG_USB and CONFIG_USB_GADGET.
Some hardware may like to use only host feature on dwc3.
So, removing the dependency of USB_DWC3 on USB_GADGET
and further modulating the dwc3 core to enable gadget features
only with USB_GADGET.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
CC: Doug Anderson <dianders@chromium.org>
---
 drivers/usb/dwc3/Kconfig   |    4 ++--
 drivers/usb/dwc3/Makefile  |    2 +-
 drivers/usb/dwc3/core.h    |    7 +++++++
 drivers/usb/dwc3/debugfs.c |    6 ++++--
 drivers/usb/dwc3/gadget.h  |    8 ++++++++
 5 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index f6a6e07..b70dcf1 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -1,7 +1,7 @@
 config USB_DWC3
 	tristate "DesignWare USB3 DRD Core Support"
-	depends on (USB && USB_GADGET)
-	select USB_OTG_UTILS
+	depends on USB
+	select USB_OTG_UTILS if USB_GADGET
 	select USB_XHCI_PLATFORM if USB_SUPPORT && USB_XHCI_HCD
 	help
 	  Say Y or M here if your system has a Dual Role SuperSpeed
diff --git a/drivers/usb/dwc3/Makefile b/drivers/usb/dwc3/Makefile
index 4502648..8f469cb 100644
--- a/drivers/usb/dwc3/Makefile
+++ b/drivers/usb/dwc3/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_USB_DWC3)			+= dwc3.o
 
 dwc3-y					:= core.o
 dwc3-y					+= host.o
-dwc3-y					+= gadget.o ep0.o
+obj-$(CONFIG_USB_GADGET)               += gadget.o ep0.o
 
 ifneq ($(CONFIG_DEBUG_FS),)
 	dwc3-y				+= debugfs.o
diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
index 4999563..4dc7ef2 100644
--- a/drivers/usb/dwc3/core.h
+++ b/drivers/usb/dwc3/core.h
@@ -865,7 +865,14 @@ int dwc3_gadget_resize_tx_fifos(struct dwc3 *dwc);
 int dwc3_host_init(struct dwc3 *dwc);
 void dwc3_host_exit(struct dwc3 *dwc);
 
+#ifdef CONFIG_USB_GADGET
 int dwc3_gadget_init(struct dwc3 *dwc);
 void dwc3_gadget_exit(struct dwc3 *dwc);
+#else
+static inline int dwc3_gadget_init(struct dwc3 *dwc)
+{ return -EINVAL; }
+static inline void dwc3_gadget_exit(struct dwc3 *dwc)
+{ }
+#endif
 
 #endif /* __DRIVERS_USB_DWC3_CORE_H */
diff --git a/drivers/usb/dwc3/debugfs.c b/drivers/usb/dwc3/debugfs.c
index d4a30f1..553bbaa 100644
--- a/drivers/usb/dwc3/debugfs.c
+++ b/drivers/usb/dwc3/debugfs.c
@@ -535,7 +535,8 @@ static ssize_t dwc3_testmode_write(struct file *file,
 		testmode = 0;
 
 	spin_lock_irqsave(&dwc->lock, flags);
-	dwc3_gadget_set_test_mode(dwc, testmode);
+	if (dwc3_gadget_set_test_mode(dwc, testmode))
+		dev_dbg(dwc->dev, "host: Invalid request\n");
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return count;
@@ -638,7 +639,8 @@ static ssize_t dwc3_link_state_write(struct file *file,
 		return -EINVAL;
 
 	spin_lock_irqsave(&dwc->lock, flags);
-	dwc3_gadget_set_link_state(dwc, state);
+	if (dwc3_gadget_set_link_state(dwc, state))
+		dev_dbg(dwc->dev, "host: Invalid request\n");
 	spin_unlock_irqrestore(&dwc->lock, flags);
 
 	return count;
diff --git a/drivers/usb/dwc3/gadget.h b/drivers/usb/dwc3/gadget.h
index 99e6d72..28e82db 100644
--- a/drivers/usb/dwc3/gadget.h
+++ b/drivers/usb/dwc3/gadget.h
@@ -105,8 +105,16 @@ static inline void dwc3_gadget_move_request_queued(struct dwc3_request *req)
 void dwc3_gadget_giveback(struct dwc3_ep *dep, struct dwc3_request *req,
 		int status);
 
+#ifdef CONFIG_USB_GADGET
 int dwc3_gadget_set_test_mode(struct dwc3 *dwc, int mode);
 int dwc3_gadget_set_link_state(struct dwc3 *dwc, enum dwc3_link_state state);
+#else
+static inline int dwc3_gadget_set_test_mode(struct dwc3 *dwc, int mode)
+{ return -EINVAL; }
+static inline int dwc3_gadget_set_link_state(struct dwc3 *dwc,
+						enum dwc3_link_state state)
+{ return -EINVAL; }
+#endif
 
 void dwc3_ep0_interrupt(struct dwc3 *dwc,
 		const struct dwc3_event_depevt *event);
-- 
1.7.6.5

