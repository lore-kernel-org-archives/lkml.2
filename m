Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0G0TWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:22:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61865 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab0G0TWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 15:22:15 -0400
Message-ID: <4C4F31AF.2090701@oracle.com>
Date: Tue, 27 Jul 2010 12:21:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Markus Grabner <grabner@icg.tugraz.at>, gregkh@suse.de,
        devel@driverdev.osuosl.org
Subject: [PATCH -next] staging/line6: needs to select SND_PCM
References: <20100727160708.722c39c1.sfr@canb.auug.org.au>
In-Reply-To: <20100727160708.722c39c1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C4F31C3.01CB:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

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
---
 drivers/staging/line6/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Third patch to staging/line6/Kconfig.  :(
Developers should know what kernel services their code needs
and how to configure for those needs.

--- linux-next-20100727.orig/drivers/staging/line6/Kconfig
+++ linux-next-20100727/drivers/staging/line6/Kconfig
@@ -2,6 +2,7 @@ config LINE6_USB
 	tristate "Line6 USB support"
 	depends on USB && SND
 	select SND_RAWMIDI
+	select SND_PCM
 	help
 	  This is a driver for the guitar amp, cab, and effects modeller
 	  PODxt Pro by Line6 (and similar devices), supporting the
