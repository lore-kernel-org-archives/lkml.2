Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab0EZOUp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 10:20:45 -0400
Received: from cantor.suse.de ([195.135.220.2]:44898 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab0EZOUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 10:20:42 -0400
Date: Wed, 26 May 2010 16:20:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: cxt1e1: remove code guarded by
 GENERIC_HDLC_VERSION
Message-ID: <alpine.LNX.2.00.1005261619460.28092@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current linux kernel has GENERIC_HDLC_VERSION equal to 4, no need to have 
dead code in-kernel which was there for ancient kernel versions.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/staging/cxt1e1/linux.c |   40 ----------------------------------------
 drivers/staging/cxt1e1/pmcc4.h |    2 ++
 2 files changed, 2 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 4088347..eb0f4bd 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -318,34 +318,6 @@ chan_close (struct net_device * ndev)
 }
 
 
-#if !defined(GENERIC_HDLC_VERSION) || (GENERIC_HDLC_VERSION < 4)
-
-/** Linux 2.4.18-19 **/
-STATIC int
-chan_ioctl (hdlc_device * hdlc, struct ifreq * ifr, int cmd)
-{
-    if (cmd == HDLCSCLOCK)
-    {
-        ifr->ifr_ifru.ifru_ivalue = LINE_DEFAULT;
-        return 0;
-    }
-    return -EINVAL;
-}
-#endif
-
-
-#if !defined(GENERIC_HDLC_VERSION) || (GENERIC_HDLC_VERSION < 4)
-STATIC int
-chan_dev_ioctl (struct net_device * hdlc, struct ifreq * ifr, int cmd)
-{
-    if (cmd == HDLCSCLOCK)
-    {
-        ifr->ifr_ifru.ifru_ivalue = LINE_DEFAULT;
-        return 0;
-    }
-    return -EINVAL;
-}
-#else
 STATIC int
 chan_dev_ioctl (struct net_device * dev, struct ifreq * ifr, int cmd)
 {
@@ -359,7 +331,6 @@ chan_attach_noop (struct net_device * ndev, unsigned short foo_1, unsigned short
     return 0;                   /* our driver has nothing to do here, show's
                                  * over, go home */
 }
-#endif
 
 
 STATIC struct net_device_stats *
@@ -422,16 +393,6 @@ get_ci_by_dev (struct net_device * ndev)
 }
 
 
-#if !defined(GENERIC_HDLC_VERSION) || (GENERIC_HDLC_VERSION < 4)
-STATIC int
-c4_linux_xmit (hdlc_device * hdlc, struct sk_buff * skb)
-{
-    int         rval;
-
-    rval = musycc_start_xmit (DEV_TO_PRIV (hdlc)->ci, DEV_TO_PRIV (hdlc)->channum, skb);
-    return -rval;
-}
-#else                           /* new */
 STATIC int
 c4_linux_xmit (struct sk_buff * skb, struct net_device * ndev)
 {
@@ -445,7 +406,6 @@ c4_linux_xmit (struct sk_buff * skb, struct net_device * ndev)
     rval = musycc_start_xmit (priv->ci, priv->channum, skb);
     return -rval;
 }
-#endif                          /* GENERIC_HDLC_VERSION */
 
 static const struct net_device_ops chan_ops = {
        .ndo_open       = chan_open,
diff --git a/drivers/staging/cxt1e1/pmcc4.h b/drivers/staging/cxt1e1/pmcc4.h
index e288a0a..ef6ac7f 100644
--- a/drivers/staging/cxt1e1/pmcc4.h
+++ b/drivers/staging/cxt1e1/pmcc4.h
@@ -117,6 +117,8 @@ extern      "C"
 
 #include "pmcc4_private.h"
 
+char       *get_hdlc_name (hdlc_device *);
+
 /*
  * external interface
  */
-- 
1.6.4.2

