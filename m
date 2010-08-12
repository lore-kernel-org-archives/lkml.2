Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933072Ab0HLAIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:08:09 -0400
Received: from kroah.org ([198.145.64.141]:60479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933033Ab0HLAH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:07:59 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:13 2010
Message-Id: <20100812000613.768723944@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [12/67] staging: hv: Fix Kconfig dependency of hv_blkvsc
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Haiyang Zhang <haiyangz@microsoft.com>

commit 54d2379c20d814ced657cbc2c4ead8d1f8389fa2 upstream.

LBDAF is not available nor necessary on 64BIT kernel. This patch
fixed the dependency for hv_blkvsc module on 64BIT kernel.
Thanks vrataj2 [vrataj2@comcast.net] for reporting this problem.

Reported-by: vrataj2 <vrataj2@comcast.net>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/hv/Kconfig
+++ b/drivers/staging/hv/Kconfig
@@ -17,7 +17,7 @@ config HYPERV_STORAGE
 
 config HYPERV_BLOCK
 	tristate "Microsoft Hyper-V virtual block driver"
-	depends on BLOCK && SCSI && LBDAF
+	depends on BLOCK && SCSI && (LBDAF || 64BIT)
 	default HYPERV
 	help
 	  Select this option to enable the Hyper-V virtual block driver.


