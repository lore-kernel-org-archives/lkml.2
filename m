Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab1FMVrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:47:49 -0400
Received: from relay01.digicable.hu ([92.249.128.189]:37075 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1FMVrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:47:48 -0400
Message-ID: <4DF6857B.3050206@freemail.hu>
Date: Mon, 13 Jun 2011 23:47:39 +0200
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Max Vozeler <max@hinterhof.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] usbip: only dump valid port status
References: <4DF68151.4080109@freemail.hu> <1308001334.26699.18.camel@Joe-Laptop>
In-Reply-To: <1308001334.26699.18.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Original: 94.21.187.147
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The wIndex parameter of vhci_hub_control() is always zero when the
request type is GetHubDescriptor, see drivers/usb/core/hub.c::get_hub_descriptor()
and Universal Serial Bus Specification revision 2.0 (April 27, 2000) Section
11.24.2.5 "Get Hub Descriptor". This means the variable rhport will not contain
any useful index. Only use valid rhport values.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
 drivers/staging/usbip/vhci_hcd.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
index 359b464..512a97f 100644
--- a/drivers/staging/usbip/vhci_hcd.c
+++ b/drivers/staging/usbip/vhci_hcd.c
@@ -464,8 +464,11 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,

 	if (usbip_dbg_flag_vhci_rh) {
 		pr_debug("port %d\n", rhport);
-		dump_port_status(prev_port_status[rhport]);
-		dump_port_status(dum->port_status[rhport]);
+		/* Only dump valid port status */
+		if (rhport >= 0) {
+			dump_port_status(prev_port_status[rhport]);
+			dump_port_status(dum->port_status[rhport]);
+		}
 	}
 	usbip_dbg_vhci_rh(" bye\n");

--
1.7.2.5
