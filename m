Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab2ERQ4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:56:23 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:30388 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759071Ab2ERQ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:56:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1337360175!13012173!7
X-Originating-IP: [216.166.12.72]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Ian Abbott <abbotti@mev.co.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Date: Fri, 18 May 2012 11:56:15 -0500
Subject: RE: [PATCH] staging: comedi: cleanup all the comedi_driver 'detach'
 functions
Thread-Topic: [PATCH] staging: comedi: cleanup all the comedi_driver
 'detach' functions
Thread-Index: Ac004DxlDs5H0UOYRCuQKxYi3NFjqQANetGw
Message-ID: <ADE657CA350FB648AAC2C43247A983F0020698AE1272@AUSP01VMBX24.collaborationhost.net>
References: <201205171711.14968.hartleys@visionengravers.com>
 <4FB6230C.2080604@mev.co.uk>
In-Reply-To: <4FB6230C.2080604@mev.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4IGuRpk028183

On Friday, May 18, 2012 3:23 AM, Ian Abbott wrote:
> On 2012-05-18 01:11, H Hartley Sweeten wrote:
>> 2. Remove all the printk noise in the detach functions
>>
>> All of the printk output is really just noise. The user did a rmmod to
>> unload the driver, we really don't need to tell them about it.
>
> I disagree.  It's not that unusual for drivers to report device removal. 
> (It's not necessarily due to an rmmod either, not that that really 
> matters.)

If you feel the messages have value I think the comedi core can
handle displaying them instead of having the message in every
driver.

Can you test this patch and let me know what the resulting output
is? You may need to change the dev_dbg to dev_info or something
else if you don't have the proper kernel debugging enabled.

Thanks,
Hartley

---

From: H Hartley Sweeten <hsweeten@visionengravers.com>

staging: comedi: have the comedi core output the driver detach message

Instead of having a "detach" message in every comedi driver, have the
comedi core output the message. Output the message using dev_dbg.

Also, change the "BUG" message from a printk format to a dev_warn
format.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 1c3d638..d6bb1f9 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -91,11 +91,14 @@ static void cleanup_device(struct comedi_device *dev)
 static void __comedi_device_detach(struct comedi_device *dev)
 {
 	dev->attached = 0;
-	if (dev->driver)
+	if (dev->driver) {
 		dev->driver->detach(dev);
-	else
-		printk(KERN_WARNING
+		dev_dbg(dev->class_dev, "%s detached\n",
+			dev->driver->driver_name);
+	} else {
+		dev_warn(dev->class_dev,
 		       "BUG: dev->driver=NULL in comedi_device_detach()\n");
+	}
 	cleanup_device(dev);
 }

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
