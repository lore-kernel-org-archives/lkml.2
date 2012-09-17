Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2IQReF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:34:05 -0400
Received: from oproxy12-pub.bluehost.com ([50.87.16.10]:45167 "HELO
	oproxy12-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756031Ab2IQReC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:34:02 -0400
Message-ID: <50575EDE.5040207@xenotime.net>
Date: Mon, 17 Sep 2012 10:33:18 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH -next] staging: fix csr printk format warning
References: <20120917215938.11c456c113ac3b015cb2d5ae@canb.auug.org.au>
In-Reply-To: <20120917215938.11c456c113ac3b015cb2d5ae@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning on i386/X86_32 by using 't' for ptrdiff_t.
Also builds cleanly on x86_64.

drivers/staging/csr/csr_wifi_hip_udi.c: In function 'unifi_print_status':
drivers/staging/csr/csr_wifi_hip_udi.c:151:27: warning: format '%ld' expects type 'long int', but argument 5 has type 'int'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/staging/csr/csr_wifi_hip_udi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120917.orig/drivers/staging/csr/csr_wifi_hip_udi.c
+++ linux-next-20120917/drivers/staging/csr/csr_wifi_hip_udi.c
@@ -146,7 +146,7 @@ s32 unifi_print_status(card_t *card, cha
                           (u16)card->to_host_signals_w);
     UNIFI_SNPRINTF_RET(p, remaining, written);
     written = scnprintf(p, remaining,
-                          "fh buffer contains: %d signals, %ld bytes\n",
+                          "fh buffer contains: %d signals, %td bytes\n",
                           card->fh_buffer.count,
                           card->fh_buffer.ptr - card->fh_buffer.buf);
     UNIFI_SNPRINTF_RET(p, remaining, written);
