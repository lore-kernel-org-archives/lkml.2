Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989Ab1KJDVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:21:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41780 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933975Ab1KJDVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:21:50 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:05 2011
Message-Id: <20111109212705.035307366@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:09 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Denis Pershin <dyp@perchine.com>
Subject: [047/262] usb: cdc-acm: Owen SI-30 support
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Pershin <dyp@perchine.com>

commit 65e52f41fa944cef2e6d4222b8c54f46cc575214 upstream.

here is the patch to support Owen SI-30 device.
This is a pulse counter controller.
http://www.owen.ru/en/catalog/93788515

usb-drivers output:
T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=02(commc) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=03eb ProdID=0030 Rev=01.01
C:  #Ifs= 2 Cfg#= 1 Atr=c0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=02 Prot=00 Driver=cdc_acm
I:  If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_acm

This patch is installed on my home system which receives data from this
controller connected to cold water counter.

Signed-off-by: Denis Pershin <dyp@perchine.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1534,6 +1534,9 @@ static const struct usb_device_id acm_id
 	{ NOKIA_PCSUITE_ACM_INFO(0x03cd), }, /* Nokia C7 */
 	{ SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */
 
+	/* Support for Owen devices */
+	{ USB_DEVICE(0x03eb, 0x0030), }, /* Owen SI30 */
+
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
 
 	/* Support Lego NXT using pbLua firmware */


