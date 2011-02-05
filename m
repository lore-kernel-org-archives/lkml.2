Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1BERhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:37:03 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60544 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab1BERhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:37:01 -0500
Date: Sat, 5 Feb 2011 09:36:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, rmthomas@sciolus.org,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, gregkh <greg@kroah.com>
Subject: [PATCH -mmotm] staging/easycap: fix build when SND is not enabled
Message-Id: <20110205093632.b76be846.randy.dunlap@oracle.com>
In-Reply-To: <201102042349.p14NnQEm025834@imap1.linux-foundation.org>
References: <201102042349.p14NnQEm025834@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D4D8AB2.0172:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix easycap build when CONFIG_SOUND is enabled but CONFIG_SND is
not enabled.

These functions are only built when CONFIG_SND is enabled, so the
driver should depend on SND.
This means that having SND enabled is required for the (obsolete)
EASYCAP_OSS config option.

drivers/built-in.o: In function `easycap_usb_disconnect':
easycap_main.c:(.text+0x2aba20): undefined reference to `snd_card_free'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b784b): undefined reference to `snd_card_create'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b78fb): undefined reference to `snd_pcm_new'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b7916): undefined reference to `snd_pcm_set_ops'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b795b): undefined reference to `snd_card_register'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b79d8): undefined reference to `snd_card_free'
drivers/built-in.o: In function `easycap_alsa_probe':
(.text+0x2b7a78): undefined reference to `snd_card_free'
drivers/built-in.o: In function `easycap_alsa_complete':
(.text+0x2b7e68): undefined reference to `snd_pcm_period_elapsed'
drivers/built-in.o:(.data+0x2cae8): undefined reference to `snd_pcm_lib_ioctl'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: R.M. Thomas <rmthomas@sciolus.org>
---
 drivers/staging/easycap/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2011-0204-1515.orig/drivers/staging/easycap/Kconfig
+++ mmotm-2011-0204-1515/drivers/staging/easycap/Kconfig
@@ -1,6 +1,6 @@
 config EASYCAP
 	tristate "EasyCAP USB ID 05e1:0408 support"
-	depends on USB && VIDEO_DEV && SOUND
+	depends on USB && VIDEO_DEV && SND
 
 	---help---
 	  This is an integrated audio/video driver for EasyCAP cards with
