Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab0CVPay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:30:54 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:52676 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753294Ab0CVPax convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:30:53 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [rt2x00-users] [PATCH RFC] rt2500usb: disable broken HW  encryption by default
Date: Mon, 22 Mar 2010 16:30:46 +0100
User-Agent: KMail/1.9.10
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
       linux-kernel@vger.kernel.org
References: <201003221601.36559.linux@rainbow-software.org> <a32f33a41003220810r3da5a8d3mb4e884fdef03eb89@mail.gmail.com>
In-Reply-To: <a32f33a41003220810r3da5a8d3mb4e884fdef03eb89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003221630.47510.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 March 2010, Ivo Van Doorn wrote:
> On Mon, Mar 22, 2010 at 4:01 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
> > Since HW encryption was added to rt2500usb in 2.6.29, the driver does not
> > work. It has been discussed before but never solved:
> > http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
> > https://bugzilla.redhat.com/show_bug.cgi?id=484888
> >
> > The problem is caused by this patch:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> >;h=dddfb478b26e29a2b47f655ec219e743b8111015
> >
> > Disable HW encryption by default to fix it.
> >
> >
> > --- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c      
> > 2010-03-20 02:17:57.000000000 +0100 +++
> > linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c    2010-03-22
> > 15:40:39.000000000 +0100 @@ -36,11 +36,11 @@
> >  #include "rt2500usb.h"
> >
> >  /*
> > - * Allow hardware encryption to be disabled.
> > + * Allow hardware encryption to be enabled.
> >  */
> > -static int modparam_nohwcrypt = 0;
> > -module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
> > -MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
> > +static int modparam_hwcrypt = 0;
> > +module_param_named(hwcrypt, modparam_hwcrypt, bool, S_IRUGO);
> > +MODULE_PARM_DESC(hwcrypt, "Enable hardware encryption.");
>
> Large patch for something which can be done much simpler. How about:
>
> static int modparam_nohwcrypt = 1
>
> That way the module parameter does not have to be renamed, so current
> configurations and documentation do not have to be changed. The name
> remains consistent with the other rt2x00 modules (and the other
> mac80211 modules for that matter).

OK, that seems better.

> But I though it was mentioned that disabling HW crypto didn't solve
> the issue due to a second bug in a later kernel?

That was a false positive. Probably because the device was not unplugged
between the tests (and looks like the driver does not initialize the chip completely).
It's not reliable, it sometimes stops working after reboot.



Since HW encryption was added to rt2500usb in 2.6.29, the driver does not
work. It has been discussed before but never solved:
http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=4&t=4834
https://bugzilla.redhat.com/show_bug.cgi?id=484888

The problem is caused by this patch:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dddfb478b26e29a2b47f655ec219e743b8111015

Disable HW encryption by default to fix it.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.34-rc2-orig/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-20 02:17:57.000000000 +0100
+++ linux-2.6.34-rc2/drivers/net/wireless/rt2x00/rt2500usb.c	2010-03-22 16:16:55.000000000 +0100
@@ -36,11 +36,11 @@
 #include "rt2500usb.h"
 
 /*
- * Allow hardware encryption to be disabled.
+ * Allow hardware encryption to be enabled.
  */
-static int modparam_nohwcrypt = 0;
+static int modparam_nohwcrypt = 1;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
-MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
+MODULE_PARM_DESC(nohwcrypt, "Hardware encryption disabled by default, use nohwcrypt=0 to enable.");
 
 /*
  * Register access.

-- 
Ondrej Zary
