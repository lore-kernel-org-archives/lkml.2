Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030550Ab2CITri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:47:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030657Ab2CITrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:33 -0500
Message-Id: <20120309190205.399674335@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:40 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Timur Tabi <timur@freescale.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [ 38/95] tty/powerpc: early udbg consoles cant be modules
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Rothwell <sfr@canb.auug.org.au>

commit f21c6d4a49179f91fd70a41382382f08c780d425 upstream.

Fixes these build errors:

ERROR: ".udbg_printf" [drivers/tty/ehv_bytechan.ko] undefined!
ERROR: ".register_early_udbg_console" [drivers/tty/ehv_bytechan.ko] undefined!
ERROR: "udbg_putc" [drivers/tty/ehv_bytechan.ko] undefined!

Cc: Timur Tabi <timur@freescale.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/Kconfig
+++ b/drivers/tty/Kconfig
@@ -365,7 +365,7 @@ config PPC_EPAPR_HV_BYTECHAN
 
 config PPC_EARLY_DEBUG_EHV_BC
 	bool "Early console (udbg) support for ePAPR hypervisors"
-	depends on PPC_EPAPR_HV_BYTECHAN
+	depends on PPC_EPAPR_HV_BYTECHAN=y
 	help
 	  Select this option to enable early console (a.k.a. "udbg") support
 	  via an ePAPR byte channel.  You also need to choose the byte channel


