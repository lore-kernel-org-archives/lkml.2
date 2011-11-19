Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab1KSAJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 19:09:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38687 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758448Ab1KSAJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 19:09:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Nov 18 16:03:29 2011
Message-Id: <20111119000329.509568923@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Fri, 18 Nov 2011 16:02:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Weber <weber@corscience.de>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: [18/26] mfd: Fix twl4030 dependencies for audio codec
In-Reply-To: <20111119000336.GA8452@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weber <weber@corscience.de>

commit f09ee0451a44a4e913a7c3cec3805508f7de6c54 upstream.

The codec for Devkit8000 (TWL4030)  was not detected except
when build with CONFIG_SND_SOC_ALL_CODECS.

twl-core.c still uses the CONFIG_TWL4030_CODEC for
twl_has_codec().

In commit 57fe7251f5bfc4332f24479376de48a1e8ca6211
the CONFIG_TWL4030_CODEC was renamed
into CONFIG_MFD_TWL4030_AUDIO, thatswhy the codec
was not detected.

This patch renames the CONFIG_ TWL4030_CODEC into
CONFIG_MFD_TWL4030_AUDIO in twl-core.c.

Signed-off-by: Thomas Weber <weber@corscience.de>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/mfd/twl-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mfd/twl-core.c
+++ b/drivers/mfd/twl-core.c
@@ -109,7 +109,7 @@
 #define twl_has_watchdog()        false
 #endif
 
-#if defined(CONFIG_TWL4030_CODEC) || defined(CONFIG_TWL4030_CODEC_MODULE) ||\
+#if defined(CONFIG_MFD_TWL4030_AUDIO) || defined(CONFIG_MFD_TWL4030_AUDIO_MODULE) ||\
 	defined(CONFIG_TWL6040_CORE) || defined(CONFIG_TWL6040_CORE_MODULE)
 #define twl_has_codec()	true
 #else


