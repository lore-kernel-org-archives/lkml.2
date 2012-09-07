Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab2IGWVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 18:21:10 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:46190 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab2IGWVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 18:21:07 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Fri, 7 Sep 2012 18:14:02 -0400
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Len Sorensen <lsorense@csclub.uwaterloo.ca>, linux@sierrawireless.com,
        netdev@vger.kernel.org
Subject: Endianess bug fix for sierra_net
Message-ID: <20120907221402.GJ15650@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I discovered I couldn't get sierra_net to work on a powerpc.  Turns out
the firmware attribute check assumes the system is little endian and
hence fails because the attributes is a 16 bit value.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index 7be49ea..8e22417 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -656,7 +656,7 @@ static int sierra_net_get_fw_attr(struct usbnet *dev, u16 *datap)
 		return -EIO;
 	}
 
-	*datap = *attrdata;
+	*datap = le16_to_cpu(*attrdata);
 
 	kfree(attrdata);
 	return result;
