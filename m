Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab1IDLAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 07:00:10 -0400
Received: from mx.ac-sw.com ([109.202.7.82]:35218 "EHLO gw.ac-sw.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab1IDLAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 07:00:04 -0400
X-Greylist: delayed 1341 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Sep 2011 07:00:03 EDT
Message-ID: <4E6354E1.3040608@perchine.com>
Date: Sun, 04 Sep 2011 17:37:21 +0700
From: Denis Pershin <dyp@perchine.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0.1) Gecko/20110830 Thunderbird/6.0.1
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.name>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: Owen SI-30 support
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here it is the patch to support Owen SI-30 device.
This is a pulse counter controller.
http://www.owen.ru/en/catalog/93788515

usb-drivers output:
T:  Bus=01 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  4 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=02(commc) Sub=00 Prot=00 MxPS= 8 #Cfgs=  1
P:  Vendor=03eb ProdID=0030 Rev=01.01
C:  #Ifs= 2 Cfg#= 1 Atr=c0 MxPwr=0mA
I:  If#= 0 Alt= 0 #EPs= 1 Cls=02(commc) Sub=02 Prot=00 Driver=cdc_acm
I:  If#= 1 Alt= 0 #EPs= 2 Cls=0a(data ) Sub=00 Prot=00 Driver=cdc_acm

Patch is made against 3.0.4 from kernel git.
This patch is installed on my home system which receives data from this 
controller connected to cold water counter.
It works well for more than 6 monthes. Please, include this patch to 
mainstream.

Signed-off-by: Denis Pershin<dyp@perchine.com>


diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index dac7676..5112f57 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1534,6 +1534,9 @@ static const struct usb_device_id acm_ids[] = {
      { NOKIA_PCSUITE_ACM_INFO(0x03cd), }, /* Nokia C7 */
      { SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */

+    /* Support for Owen devices */
+    { USB_DEVICE(0x03eb, 0x0030), }, /* Owen SI30 */
+
      /* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a 
modem! */

      /* Support Lego NXT using pbLua firmware */

--
Denis Pershin
CTO of Navitel

