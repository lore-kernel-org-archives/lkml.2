Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1FNG2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 02:28:44 -0400
Received: from relay03.digicable.hu ([92.249.128.185]:51246 "EHLO
	relay03.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab1FNG2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 02:28:42 -0400
Message-ID: <4DF6FF94.9030501@freemail.hu>
Date: Tue, 14 Jun 2011 08:28:36 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Max Vozeler <max@hinterhof.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        Joe Perches <joe@perches.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] usbip: simplify port status saving
References: <4DF68161.5060304@freemail.hu>
In-Reply-To: <4DF68161.5060304@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 92.249.250.109
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Use memcpy() function to save port status instead of
a handwritten for loop.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
 drivers/staging/usbip/vhci_hcd.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index d3f11a3..878b5bf 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -287,9 +287,8 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,

 	/* store old status and compare now and old later */
 	if (usbip_dbg_flag_vhci_rh) {
-		int i = 0;
-		for (i = 0; i < VHCI_NPORTS; i++)
-			prev_port_status[i] = dum->port_status[i];
+		memcpy(prev_port_status, dum->port_status,
+			sizeof(prev_port_status));
 	}

 	switch (typeReq) {
-- 
1.7.2.5
