Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758730Ab0HLApe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:45:34 -0400
Received: from kroah.org ([198.145.64.141]:40029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758685Ab0HKX53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:57:29 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:56 2010
Message-Id: <20100811235456.154443898@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:53:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Markus Grabner <grabner@icg.tugraz.at>
Subject: [006/111] Staging: line6: needs to select SND_PCM
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <randy.dunlap@oracle.com>

commit e928c077e5cdcd72ee762125b37232aec1ff49f3 upstream.

line6 uses snd_pcm*() functions, so it should select SND_PCM.

ERROR: "snd_pcm_period_elapsed" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_pcm_set_ops" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_pcm_lib_free_pages" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_pcm_lib_ioctl" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_pcm_lib_malloc_pages" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_pcm_hw_constraint_ratdens" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_pcm_format_physical_width" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_pcm_lib_preallocate_pages_for_all" [drivers/staging/line6/line6usb.ko] undefined!
ERROR: "snd_pcm_new" [drivers/staging/line6/line6usb.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Markus Grabner <grabner@icg.tugraz.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/line6/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/line6/Kconfig
+++ b/drivers/staging/line6/Kconfig
@@ -2,6 +2,7 @@ config LINE6_USB
 	tristate "Line6 USB support"
 	depends on USB && SND
 	select SND_RAWMIDI
+	select SND_PCM
 	help
 	  This is a driver for the guitar amp, cab, and effects modeller
 	  PODxt Pro by Line6 (and similar devices), supporting the


