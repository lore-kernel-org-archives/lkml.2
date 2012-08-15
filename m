Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756669Ab2HOTus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:50:48 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62920 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab2HOTuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:44 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Denis Pershin <dyp@perchine.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 074/165] usb: cdc-acm: Owen SI-30 support
Date: Wed, 15 Aug 2012 15:46:58 -0400
Message-ID: <1345060109-9187-75-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Denis Pershin <dyp@perchine.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/class/cdc-acm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index e907cfd..db34eb4 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1623,6 +1623,9 @@ static const struct usb_device_id acm_ids[] = {
 	{ NOKIA_PCSUITE_ACM_INFO(0x03cd), }, /* Nokia C7 */
 	{ SAMSUNG_PCSUITE_ACM_INFO(0x6651), }, /* Samsung GTi8510 (INNOV8) */
 
+	/* Support for Owen devices */
+	{ USB_DEVICE(0x03eb, 0x0030), }, /* Owen SI30 */
+
 	/* NOTE: non-Nokia COMM/ACM/0xff is likely MSFT RNDIS... NOT a modem! */
 
 	/* Support Lego NXT using pbLua firmware */
-- 
1.7.12.rc2

