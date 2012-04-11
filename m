Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622Ab2DKXgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:36:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45547 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965591Ab2DKX2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:28:17 -0400
Message-Id: <20120411231309.665578998@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:13:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [ 14/42] m68k/mac: Add missing platform check before registering platform devices
In-Reply-To: <20120411231443.GA808@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 6cfeba53911d6d2f17ebbd1246893557d5ff5aeb upstream.

On multi-platform kernels, the Mac platform devices should be registered
when running on Mac only. Else it may crash later.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/m68k/mac/config.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -950,6 +950,9 @@ int __init mac_platform_init(void)
 {
 	u8 *swim_base;
 
+	if (!MACH_IS_MAC)
+		return -ENODEV;
+
 	/*
 	 * Serial devices
 	 */


