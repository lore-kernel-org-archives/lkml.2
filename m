Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933303Ab2JKCMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:12:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55625 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933216Ab2JKCMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:12:18 -0400
X-Sasl-enc: 2qDoFOGVmacNtqOMSWN2eWuWwHILGC1QE2XVQIZrkE4Y 1349921537
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 25/84] sierra_net: Endianess bug fix.
Date: Thu, 11 Oct 2012 11:03:09 +0900
Message-Id: <20121011015421.606262968@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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


