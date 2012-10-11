Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933956Ab2JKBUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:20:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35334 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933939Ab2JKBTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:19:50 -0400
X-Sasl-enc: 3hWinL6LeMfKihO2C2/iG0yNtYs6DBJXRSsB2g2mGo+S 1349918388
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 038/120] sierra_net: Endianess bug fix.
Date: Thu, 11 Oct 2012 09:59:50 +0900
Message-Id: <20121011005832.517402807@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

[ Upstream commit 2120c52da6fe741454a60644018ad2a6abd957ac ]

I discovered I couldn't get sierra_net to work on a powerpc.  Turns out
the firmware attribute check assumes the system is little endian and
hence fails because the attributes is a 16 bit value.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/sierra_net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -678,7 +678,7 @@ static int sierra_net_get_fw_attr(struct
 		return -EIO;
 	}
 
-	*datap = *attrdata;
+	*datap = le16_to_cpu(*attrdata);
 
 	kfree(attrdata);
 	return result;


