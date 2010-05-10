Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933053Ab0EJXAe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:00:34 -0400
Received: from kroah.org ([198.145.64.141]:51704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714Ab0EJW5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:52 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:37 2010
Message-Id: <20100510223537.387310258@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: [33/98] Staging: hv: Fix a bug affecting IPv6
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 95beae90aa4afce57fb28e6f8238b78217bd7c98 upstream.

Fix a bug affecting IPv6
Added the multicast flag for proper IPv6 function.

Reported-by: Toshikazu Sakai <toshikas@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/RndisFilter.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/hv/RndisFilter.c
+++ b/drivers/staging/hv/RndisFilter.c
@@ -756,6 +756,7 @@ static int RndisFilterOpenDevice(struct
 
 	ret = RndisFilterSetPacketFilter(Device,
 					 NDIS_PACKET_TYPE_BROADCAST |
+					 NDIS_PACKET_TYPE_ALL_MULTICAST |
 					 NDIS_PACKET_TYPE_DIRECTED);
 	if (ret == 0)
 		Device->State = RNDIS_DEV_DATAINITIALIZED;


