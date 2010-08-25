Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0HYBWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 21:22:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36126 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab0HYBWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 21:22:42 -0400
Date: Wed, 25 Aug 2010 11:22:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: linux-next: manual merge of the drivers-x86 tree with Linus' tree
Message-Id: <20100825112236.6ec0390e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

Today's linux-next merge of the drivers-x86 tree got a conflict in
drivers/platform/x86/Kconfig between commit
c76a3e1d6c52c5cc1371f1abc7381c5715ebdf7f ("ACPI_TOSHIBA needs LEDS
support") from Lunus' tree and commit
35989e9d7e19deb4b395aee7d120b1536337b4af ("toshiba-acpi - switch to using
sparse keymap") from the drivers-x86 tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/platform/x86/Kconfig
index cff7cc2,8498389..0000000
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@@ -486,12 -490,10 +490,12 @@@ config TOPSTAR_LAPTO
  config ACPI_TOSHIBA
  	tristate "Toshiba Laptop Extras"
  	depends on ACPI
 +	depends on LEDS_CLASS
 +	depends on NEW_LEDS
 +	depends on BACKLIGHT_CLASS_DEVICE
  	depends on INPUT
  	depends on RFKILL || RFKILL = n
- 	select INPUT_POLLDEV
+ 	select INPUT_SPARSEKMAP
 -	select BACKLIGHT_CLASS_DEVICE
  	---help---
  	  This driver adds support for access to certain system settings
  	  on "legacy free" Toshiba laptops.  These laptops can be recognized by
