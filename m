Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2JDXDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 19:03:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54778 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab2JDXDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 19:03:20 -0400
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dmytro Milinevskyy <milinevskyy@gmail.com>
Subject: [PATCH] usb: gadget: ncm: correct endianess conversion
Date: Fri,  5 Oct 2012 01:58:21 +0300
Message-Id: <1349391501-15799-1-git-send-email-milinevskyy@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
---
 drivers/usb/gadget/f_ncm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
index b651b52..fce45ab 100644
--- a/drivers/usb/gadget/f_ncm.c
+++ b/drivers/usb/gadget/f_ncm.c
@@ -869,11 +869,11 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *port,
 	struct sk_buff	*skb2;
 	int		ncb_len = 0;
 	__le16		*tmp;
-	int		div = ntb_parameters.wNdpInDivisor;
-	int		rem = ntb_parameters.wNdpInPayloadRemainder;
-	int		pad;
-	int		ndp_align = ntb_parameters.wNdpInAlignment;
-	int		ndp_pad;
+	int	div = le16_to_cpu(ntb_parameters.wNdpInDivisor);
+	int	rem = le16_to_cpu(ntb_parameters.wNdpInPayloadRemainder);
+	int	pad;
+	int	ndp_align = le16_to_cpu(ntb_parameters.wNdpInAlignment);
+	int	ndp_pad;
 	unsigned	max_size = ncm->port.fixed_in_len;
 	struct ndp_parser_opts *opts = ncm->parser_opts;
 	unsigned	crc_len = ncm->is_crc ? sizeof(uint32_t) : 0;
-- 
1.7.12

