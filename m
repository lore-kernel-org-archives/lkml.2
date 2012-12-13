Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab2LMOLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:11:51 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:49297 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933070Ab2LMOLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:11:44 -0500
From: Armando Visconti <armando.visconti@st.com>
To: <balbi@ti.com>
Cc: <gregkh@linuxfoundation.org>, <pratyush.anand@st.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <spear-devel@list.st.com>
Subject: [PATCH] usb: gadget zero: avoid unnecessary reinit of data in f_sourcesink
Date: Thu, 13 Dec 2012 15:11:19 +0100
Message-ID: <1355407879-11784-1-git-send-email-armando.visconti@st.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the IN case, since the USB request is allocated only when
the source/sink function is started and never freed, the USB ept
buffer needs to be inited only at the beginning. This change
results into a more performant g_zero module, especially when
'pattern=1' is selected.

Signed-off-by: Armando Visconti <armando.visconti@st.com>
---
 drivers/usb/gadget/f_sourcesink.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/f_sourcesink.c b/drivers/usb/gadget/f_sourcesink.c
index 3c126fd..534cf8c 100644
--- a/drivers/usb/gadget/f_sourcesink.c
+++ b/drivers/usb/gadget/f_sourcesink.c
@@ -536,8 +536,7 @@ static void source_sink_complete(struct usb_ep *ep, struct usb_request *req)
 			check_read_data(ss, req);
 			if (pattern != 2)
 				memset(req->buf, 0x55, req->length);
-		} else
-			reinit_write_data(ep, req);
+		}
 		break;
 
 	/* this endpoint is normally active while we're configured */
-- 
1.7.4.4

