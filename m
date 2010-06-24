Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0FXWLX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 18:11:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20184 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0FXWLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 18:11:21 -0400
Date: Thu, 24 Jun 2010 15:11:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ben Collins <bcollins@bluecherry.net>, devel@driverdev.osuosl.org
Subject: [PATCH -next] solo: depends on SND
Message-Id: <20100624151104.8c96c25e.randy.dunlap@oracle.com>
In-Reply-To: <20100624171826.282ae29a.sfr@canb.auug.org.au>
References: <20100624171826.282ae29a.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C23D7FB.02AF:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix 56 undefined references to snd_*() functions. First 5 are:

drivers/built-in.o: In function `solo_g723_exit':
(.text+0xa4a4aa): undefined reference to `snd_card_free'
drivers/built-in.o: In function `solo_snd_pcm_init':
solo6010-g723.c:(.text+0xa4a677): undefined reference to `snd_pcm_new'
solo6010-g723.c:(.text+0xa4a6b1): undefined reference to `snd_pcm_set_ops'
solo6010-g723.c:(.text+0xa4a74d): undefined reference to `snd_pcm_lib_preallocate_pages_for_all'
drivers/built-in.o: In function `solo_g723_init':
(.text+0xa4a7f6): undefined reference to `snd_card_create'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ben Collins <bcollins@bluecherry.net>
---
 drivers/staging/solo6x10/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100624.orig/drivers/staging/solo6x10/Kconfig
+++ linux-next-20100624/drivers/staging/solo6x10/Kconfig
@@ -1,6 +1,6 @@
 config SOLO6X10
 	tristate "Softlogic 6x10 MPEG codec cards"
-	depends on PCI && VIDEO_DEV
+	depends on PCI && VIDEO_DEV && SND
 	select VIDEOBUF_DMA_CONTIG
 	---help---
 	  This driver supports the Softlogic based MPEG-4 and h.264 codec
