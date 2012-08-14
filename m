Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab2HNSlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:41:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40014 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066Ab2HNSlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:41:12 -0400
Message-ID: <502A9BB7.8020204@iki.fi>
Date: Tue, 14 Aug 2012 21:40:55 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 14 (media/dvb/dvb-usb-v2/anysee)
References: <20120814135506.b6b86e3c8cb9da1eefb7bbd6@canb.auug.org.au> <502A90EC.40201@xenotime.net>
In-Reply-To: <502A90EC.40201@xenotime.net>
Content-Type: multipart/mixed;
 boundary="------------060805000901090407040600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060805000901090407040600
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 08/14/2012 08:54 PM, Randy Dunlap wrote:
> On 08/13/2012 08:55 PM, Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20120813:
>>
>
>
>
> on x86_64:
>
> In file included from drivers/media/dvb/dvb-usb-v2/anysee.c:34:0:
> drivers/media/dvb/dvb-usb-v2/anysee.h:51:0: warning: "debug_dump" redefined
> drivers/media/dvb/dvb-usb-v2/anysee.h:47:0: note: this is the location of the previous definition

Thank you Randy for the report. Attached patch fix it.

Unfortunately it will not apply for current next as Mauro reorganized 
drivers/media/ today and this one is top of that. I will make another 
patch to change whole driver to use Kernel dev_* debugging and sent 
those linus-media. I hope those are in next quite soon.

regards
Antti

-- 
http://palosaari.fi/

--------------060805000901090407040600
Content-Type: text/x-patch;
 name="0001-anysee-fix-compiler-warning.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-anysee-fix-compiler-warning.patch"

>From cbd18c187db27686f2fd14348255713defe1d90a Mon Sep 17 00:00:00 2001
From: Antti Palosaari <crope@iki.fi>
Date: Tue, 14 Aug 2012 21:23:01 +0300
Subject: [PATCH] anysee: fix compiler warning

debug_dump macro was defined twice when CONFIG_DVB_USB_DEBUG was
not set. Move debug_dump macro to correct place.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/anysee.h | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.h b/drivers/media/usb/dvb-usb-v2/anysee.h
index dc40dcf..834dc12 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.h
+++ b/drivers/media/usb/dvb-usb-v2/anysee.h
@@ -41,19 +41,18 @@
 #ifdef CONFIG_DVB_USB_DEBUG
 #define dprintk(var, level, args...) \
 	do { if ((var & level)) printk(args); } while (0)
-#define DVB_USB_DEBUG_STATUS
-#else
-#define dprintk(args...)
-#define debug_dump(b, l, func)
-#define DVB_USB_DEBUG_STATUS " (debugging is not enabled)"
-#endif
-
 #define debug_dump(b, l, func) {\
 	int loop_; \
 	for (loop_ = 0; loop_ < l; loop_++) \
 		func("%02x ", b[loop_]); \
 	func("\n");\
 }
+#define DVB_USB_DEBUG_STATUS
+#else
+#define dprintk(args...)
+#define debug_dump(b, l, func)
+#define DVB_USB_DEBUG_STATUS " (debugging is not enabled)"
+#endif
 
 #define deb_info(args...) dprintk(dvb_usb_anysee_debug, 0x01, args)
 #define deb_xfer(args...) dprintk(dvb_usb_anysee_debug, 0x02, args)
-- 
1.7.11.2


--------------060805000901090407040600--
