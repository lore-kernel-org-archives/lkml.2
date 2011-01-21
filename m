Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753871Ab1AUG17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:27:59 -0500
Received: from mailfilter1.ihug.co.nz ([203.109.136.1]:7630 "EHLO
	mailfilter65.ihug.co.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751198Ab1AUG14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:27:56 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAD62OE12XLpw/2dsb2JhbACkYnS+HoVQBIsfiAo
X-IronPort-AV: E=Sophos;i="4.60,356,1291546800"; 
   d="scan'208";a="87748869"
Date: Fri, 21 Jan 2011 19:27:53 +1300
From: Ralph Loader <suckfish@ihug.co.nz>
To: Greg KH <greg@kroah.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix some incorrect use of positive error codes.
Message-Id: <20110121192753.be68c316.suckfish@ihug.co.nz>
In-Reply-To: <20110121000518.GA14997@kroah.com>
References: <20101226185718.aa60e0cd.suckfish@ihug.co.nz>
	<alpine.LNX.2.00.1012271227260.16569@pobox.suse.cz>
	<20101229120116.9eeb9261.suckfish@ihug.co.nz>
	<20110121000518.GA14997@kroah.com>
X-Mailer: Sylpheed 3.1.0beta5 (GTK+ 2.23.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This doesn't seem to apply at the moment, care to redo it against the
> latest linux-next tree?
> 
> thanks,
> 
> greg k-h

Patch against latest linux-next below.

Cheers,
Ralph.

>From e7e2289874f776dea2a684d218ba9554e7459599 Mon Sep 17 00:00:00 2001
From: Ralph Loader <suckfish@ihug.co.nz>
Date: Wed, 29 Dec 2010 11:12:15 +1300
Subject: [PATCH] staging: Fix some incorrect use of positive error codes.

Use -E... instead of just E... in a few places where negative error
codes are expected by a functions callers.  These were found by grepping
with coccinelle & then inspecting by hand to determine which were bugs.

The staging/cxt1e1 driver appears to intentionally use positive E...
error codes in some places, and negative -E... error codes in others,
making it hard to know which is intended where - very likely I missed
some problems in that driver.

Signed-off-by: Ralph Loader <suckfish@ihug.co.nz>
---
 drivers/staging/ath6kl/os/linux/ioctl.c            |   10 +++++-----
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    2 +-
 drivers/staging/cxt1e1/linux.c                     |    2 +-
 .../staging/westbridge/astoria/device/cyasdevice.c |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/ath6kl/os/linux/ioctl.c b/drivers/staging/ath6kl/os/linux/ioctl.c
index d5f7ac0..0b10376 100644
--- a/drivers/staging/ath6kl/os/linux/ioctl.c
+++ b/drivers/staging/ath6kl/os/linux/ioctl.c
@@ -440,7 +440,7 @@ ar6000_ioctl_set_rssi_threshold(struct net_device *dev, struct ifreq *rq)
             if (ar->rssi_map[j+1].rssi < ar->rssi_map[j].rssi) {
                 SWAP_THOLD(ar->rssi_map[j+1], ar->rssi_map[j]);
             } else if (ar->rssi_map[j+1].rssi == ar->rssi_map[j].rssi) {
-                return EFAULT;
+                return -EFAULT;
             }
         }
     }
@@ -449,7 +449,7 @@ ar6000_ioctl_set_rssi_threshold(struct net_device *dev, struct ifreq *rq)
             if (ar->rssi_map[j+1].rssi < ar->rssi_map[j].rssi) {
                 SWAP_THOLD(ar->rssi_map[j+1], ar->rssi_map[j]);
             } else if (ar->rssi_map[j+1].rssi == ar->rssi_map[j].rssi) {
-                return EFAULT;
+                return -EFAULT;
             }
         }
     }
@@ -2870,7 +2870,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                                              gpio_output_set_cmd.enable_mask,
                                              gpio_output_set_cmd.disable_mask);
                 if (ret != A_OK) {
-                    ret = EIO;
+                    ret = -EIO;
                 }
             }
             up(&ar->arSem);
@@ -2950,7 +2950,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
                                                gpio_register_cmd.gpioreg_id,
                                                gpio_register_cmd.value);
                 if (ret != A_OK) {
-                    ret = EIO;
+                    ret = -EIO;
                 }
 
                 /* Wait for acknowledgement from Target */
@@ -3041,7 +3041,7 @@ int ar6000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
             } else {
                 ret = ar6000_gpio_intr_ack(dev, gpio_intr_ack_cmd.ack_mask);
                 if (ret != A_OK) {
-                    ret = EIO;
+                    ret = -EIO;
                 }
             }
             up(&ar->arSem);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index c039ef1..b50e3c4 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -1368,7 +1368,7 @@ wl_iw_iscan_set_scan(struct net_device *dev,
 	if (g_scan_specified_ssid) {
 		WL_TRACE("%s Specific SCAN already running ignoring BC scan\n",
 			 __func__);
-		return EBUSY;
+		return -EBUSY;
 	}
 
 	memset(&ssid, 0, sizeof(ssid));
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 0f78f89..9ced08f 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -548,7 +548,7 @@ do_set_port (struct net_device * ndev, void *data)
         return -EINVAL;             /* get card info */
 
     if (pp.portnum >= ci->max_port) /* sanity check */
-        return ENXIO;
+        return -ENXIO;
 
     memcpy (&ci->port[pp.portnum].p, &pp, sizeof (struct sbecom_port_param));
     return mkret (c4_set_port (ci, pp.portnum));
diff --git a/drivers/staging/westbridge/astoria/device/cyasdevice.c b/drivers/staging/westbridge/astoria/device/cyasdevice.c
index c76e383..0889730 100644
--- a/drivers/staging/westbridge/astoria/device/cyasdevice.c
+++ b/drivers/staging/westbridge/astoria/device/cyasdevice.c
@@ -389,7 +389,7 @@ EXPORT_SYMBOL(cyasdevice_gethaltag);
 static int __init cyasdevice_init(void)
 {
 	if (cyasdevice_initialize() != 0)
-		return ENODEV;
+		return -ENODEV;
 
 	return 0;
 }
-- 
1.7.3.4

