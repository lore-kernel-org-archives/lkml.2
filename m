Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab2E1DlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:41:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52064 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753877Ab2E1D3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:40 -0400
Message-Id: <20120528031213.220721681@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Josh Boyer <jwboyer@redhat.com>,
        Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>
Subject: [ 075/117] sony-laptop: Enable keyboard backlight by default
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/platform/x86/sony-laptop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index c006dee..40c4705 100644
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


