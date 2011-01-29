Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab1A2BZp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 20:25:45 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:26814 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1A2BZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 20:25:44 -0500
Date: Sat, 29 Jan 2011 02:26:51 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB, Mass Storage, composite, gadget: Fix build failure and
 memset of a struct
Message-ID: <alpine.LNX.2.00.1101290216500.6465@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-671475880-1296264411=:6465"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-671475880-1296264411=:6465
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Trying to compile drivers/usb/gadget/f_mass_storage.o currently fails and 
spews a ton of warnings :

  CC      drivers/usb/gadget/f_mass_storage.o
drivers/usb/gadget/f_mass_storage.c:436:22: error: field ¡function¢ has incomplete type
drivers/usb/gadget/f_mass_storage.c: In function ¡fsg_from_func¢:
drivers/usb/gadget/f_mass_storage.c:466:9: warning: type defaults to ¡int¢ in declaration of ¡__mptr¢
drivers/usb/gadget/f_mass_storage.c:466:9: warning: initialization from incompatible pointer type
drivers/usb/gadget/f_mass_storage.c: At top level:
drivers/usb/gadget/f_mass_storage.c:2743:15: warning: ¡struct usb_composite_dev¢ declared inside parameter list
drivers/usb/gadget/f_mass_storage.c:2743:15: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/usb/gadget/f_mass_storage.c: In function ¡fsg_common_init¢:
drivers/usb/gadget/f_mass_storage.c:2745:34: error: dereferencing pointer to incomplete type
drivers/usb/gadget/f_mass_storage.c:2775:23: error: dereferencing pointer to incomplete type
drivers/usb/gadget/f_mass_storage.c:2779:3: error: implicit declaration of function ¡usb_string_id¢
drivers/usb/gadget/f_mass_storage.c: At top level:
drivers/usb/gadget/f_mass_storage.c:2984:60: warning: ¡struct usb_configuration¢ declared inside parameter list
drivers/usb/gadget/f_mass_storage.c:3003:57: warning: ¡struct usb_configuration¢ declared inside parameter list
drivers/usb/gadget/f_mass_storage.c: In function ¡fsg_bind¢:
drivers/usb/gadget/f_mass_storage.c:3006:31: error: dereferencing pointer to incomplete type
drivers/usb/gadget/f_mass_storage.c:3013:2: error: implicit declaration of function ¡usb_interface_id¢
drivers/usb/gadget/f_mass_storage.c:3033:3: error: dereferencing pointer to incomplete type
drivers/usb/gadget/f_mass_storage.c:3034:6: error: dereferencing pointer to incomplete type
drivers/usb/gadget/f_mass_storage.c:3043:4: error: dereferencing pointer to incomplete type
drivers/usb/gadget/f_mass_storage.c:3044:7: error: dereferencing pointer to incomplete type
drivers/usb/gadget/f_mass_storage.c:3045:26: error: dereferencing pointer to incomplete type
drivers/usb/gadget/f_mass_storage.c: At top level:
drivers/usb/gadget/f_mass_storage.c:3067:14: warning: ¡struct usb_configuration¢ declared inside parameter list
drivers/usb/gadget/f_mass_storage.c:3067:14: warning: ¡struct usb_composite_dev¢ declared inside parameter list
drivers/usb/gadget/f_mass_storage.c: In function ¡fsg_bind_config¢:
drivers/usb/gadget/f_mass_storage.c:3093:2: error: implicit declaration of function ¡usb_add_function¢
drivers/usb/gadget/f_mass_storage.c: At top level:
drivers/usb/gadget/f_mass_storage.c:3103:9: warning: ¡struct usb_configuration¢ declared inside parameter list
drivers/usb/gadget/f_mass_storage.c:3103:9: warning: ¡struct usb_composite_dev¢ declared inside parameter list
drivers/usb/gadget/f_mass_storage.c: In function ¡fsg_add¢:
drivers/usb/gadget/f_mass_storage.c:3105:2: warning: passing argument 1 of ¡fsg_bind_config¢ from incompatible pointer type
drivers/usb/gadget/f_mass_storage.c:3065:12: note: expected ¡struct usb_composite_dev *¢ but argument is of type ¡struct usb_composite_dev *¢
drivers/usb/gadget/f_mass_storage.c:3105:2: warning: passing argument 2 of ¡fsg_bind_config¢ from incompatible pointer type
drivers/usb/gadget/f_mass_storage.c:3065:12: note: expected ¡struct usb_configuration *¢ but argument is of type ¡struct usb_configuration *¢
drivers/usb/gadget/f_mass_storage.c: At top level:
drivers/usb/gadget/f_mass_storage.c:3190:23: warning: ¡struct usb_composite_dev¢ declared inside parameter list
drivers/usb/gadget/f_mass_storage.c:3195:23: warning: ¡struct usb_composite_dev¢ declared inside parameter list
drivers/usb/gadget/f_mass_storage.c:3193:1: error: conflicting types for ¡fsg_common_from_params¢
drivers/usb/gadget/f_mass_storage.c:3188:1: note: previous declaration of ¡fsg_common_from_params¢ was here
drivers/usb/gadget/f_mass_storage.c: In function ¡fsg_common_from_params¢:
drivers/usb/gadget/f_mass_storage.c:3199:2: warning: passing argument 2 of ¡fsg_common_init¢ from incompatible pointer type
drivers/usb/gadget/f_mass_storage.c:2741:27: note: expected ¡struct usb_composite_dev *¢ but argument is of type ¡struct usb_composite_dev *¢
make[1]: *** [drivers/usb/gadget/f_mass_storage.o] Error 1
make: *** [drivers/usb/gadget/f_mass_storage.o] Error 2

This is due to the missing include of linux/usb/composite.h - this patch 
adds the missing include.

In addition there's also a problem in fsg_common_init() where we memset 
'common', but we use the size of a pointer to 'struct fsg_common' as the 
size argument to memset(), not the actual size of the struct. This patch 
fixes the sizeof so we zero the entire struct as intended.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 f_mass_storage.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

  compile tested only.

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index b5dbb23..6d8e533 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -293,6 +293,7 @@
 
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
+#include <linux/usb/composite.h>
 
 #include "gadget_chips.h"
 
@@ -2763,7 +2764,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 			return ERR_PTR(-ENOMEM);
 		common->free_storage_on_release = 1;
 	} else {
-		memset(common, 0, sizeof common);
+		memset(common, 0, sizeof *common);
 		common->free_storage_on_release = 0;
 	}
 


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-671475880-1296264411=:6465--
