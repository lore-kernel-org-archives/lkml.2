Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab0GYO6v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 10:58:51 -0400
Received: from trinity.trinnet.net ([69.12.138.16]:61693 "EHLO
	trinity4.trinnet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750923Ab0GYO6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 10:58:49 -0400
X-Greylist: delayed 1358 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Jul 2010 10:58:49 EDT
Message-ID: <4C4C4BD8.7040008@trinnet.net>
Date: Sun, 25 Jul 2010 07:36:08 -0700
From: "David A. Ranch" <dranch@trinnet.net>
User-Agent: Thunderbird 2.0.0.24 (X11/20100721)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, bryder@sgi.com, linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] small FTDI USB serial driver update
References: <4C4B826E.8050009@trinnet.net> <20100725045859.GA7631@kroah.com>
In-Reply-To: <20100725045859.GA7631@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello Greg,

Thanks for getting back to me!  I didn't know what you meant by 
"Sign-off" but I just researched it per http://lwn.net/Articles/139918 
(please let me know if that post doesn't apply anymore).  This will be 
my first kernel patch.  Let's try again:

Reason for patch:
-----------------
This patch is for a US Interface, Inc. "Navigator" USB device. 
Specifically, it's a HAM Radio USB sound modem that also incorporates 
three pairs of unique FTDI serial ports.  The standard Linux FTDI serial 
driver will only recognize the first two serial ports of an unknown FDTI 
derived device and this patch adds in recognition to these specific new IDs.


Diffs are against a vanilla 2.6.34


--- ftdi_sio_ids.h.orig 2010-07-25 07:17:44.000000000 -0700
+++ ftdi_sio_ids.h      2010-07-25 07:20:46.000000000 -0700
@@ -40,6 +40,13 @@

  #define FTDI_NXTCAM_PID                0xABB8 /* NXTCam for Mindstorms 
NXT */

+/* US Interface Navigator (http://www.usinterface.com/). */
+/* Submitted by David Ranch */
+#define FTDI_USINT_CAT_PID     0xB810  /* Navigator CAT and 2nd PTT 
lines */
+#define FTDI_USINT_WKEY_PID    0xB811  /* Navigator WKEY and FSK lines */
+#define FTDI_USINT_RS232_PID   0xB812  /* Navigator RS232 and CONFIG 
lines */
+
+
  /* OOCDlink by Joern Kaipf <joernk@web.de>
   * 
(http://www.joernonline.de/dw/doku.php?id=start&idx=projects:oocdlink) */
  #define FTDI_OOCDLINK_PID      0xbaf8  /* Amontec JTAGkey */



--- ftdi_sio.c.orig     2010-07-25 07:21:10.000000000 -0700
+++ ftdi_sio.c  2010-07-25 07:24:21.000000000 -0700
@@ -162,6 +162,9 @@ static struct usb_device_id id_table_com
         { USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_5_PID) },
         { USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_6_PID) },
         { USB_DEVICE(FTDI_VID, FTDI_SCS_DEVICE_7_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_USINT_CAT_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_USINT_WKEY_PID) },
+       { USB_DEVICE(FTDI_VID, FTDI_USINT_RS232_PID) },
         { USB_DEVICE(FTDI_VID, FTDI_ACTZWAVE_PID) },
         { USB_DEVICE(FTDI_VID, FTDI_IRTRANS_PID) },
         { USB_DEVICE(FTDI_VID, FTDI_IPLUS_PID) },


Signed-off-by: David A. Ranch <dranch@trinnet.net>


--David


> On Sat, Jul 24, 2010 at 05:16:46PM -0700, David Ranch wrote:
>> Hello Greg,
>>
>> I've trying to get an additional vendor's ID added to the fdti_sio driver 
>> in Linux without any luck and I was curious if you could help.  The changes 
>> are posted here:
>>
>>   http://www.trinityos.com/HAM/US-Interface/usr/src/linux/
>>
>>
>> My second attempt post with no luck
>>  http://www.spinics.net/lists/linux-hams/msg02455.html
>>
>> My first request went to greg@kroah.com
> 
> Are you sure?  I don't have any record of it.
> 
> Can you resend your patch, with a signed-off-by line, so I can apply it?
> 
> thanks,
> 
> greg k-h
