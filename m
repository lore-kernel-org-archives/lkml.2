Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760756Ab2EJRgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:36:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46175 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760610Ab2EJRgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:36:45 -0400
Message-Id: <20120510173136.810567234@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josh Boyer <jwboyer@redhat.com>,
        Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>,
        maximilian attems <max@stro.at>
Subject: [ 45/52] sony-laptop: Enable keyboard backlight by default
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit 6fe6ae56a7cebaebc2e6daa11c423e4692f9b592 upstream.

When the keyboard backlight support was originally added, the commit said
to default it to on with a 10 second timeout.  That actually wasn't the
case, as the default value is commented out for the kbd_backlight parameter.
Because it is a static variable, it gets set to 0 by default without some
other form of initialization.

However, it seems the function to set the value wasn't actually called
immediately, so whatever state the keyboard was in initially would remain.
Then commit df410d522410e67660 was introduced during the 2.6.39 timeframe to
immediately set whatever value was present (as well as attempt to
restore/reset the state on module removal or resume).  That seems to have
now forced the light off immediately when the module is loaded unless
the option kbd_backlight=1 is specified.

Let's enable it by default again (for the first time).  This should solve
https://bugzilla.redhat.com/show_bug.cgi?id=728478

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Acked-by: Mattia Dongili <malattia@linux.it>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/sony-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -127,7 +127,7 @@ MODULE_PARM_DESC(minor,
 		 "default is -1 (automatic)");
 #endif
 
-static int kbd_backlight;	/* = 1 */
+static int kbd_backlight = 1;
 module_param(kbd_backlight, int, 0444);
 MODULE_PARM_DESC(kbd_backlight,
 		 "set this to 0 to disable keyboard backlight, "


