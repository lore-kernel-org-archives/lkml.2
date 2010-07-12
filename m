Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0GLMO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 08:14:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52956 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab0GLMOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 08:14:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type;
        b=Jdm07bcoDN5+DlmKp10tGK9n95LePkrw4phcYueKbfYeJNmTqfhjWqXLF1payN66AM
         cHnGMuxH08HTn3/NQygMNKW9ayToGGC3W9S5lgFrVAZLLUmyqEJUZ/Y/cJ+cP6TNhqZ4
         7bbvRAlLrg6R6/c4n+DNWyD55RKNvMePFKp/Y=
Message-ID: <4C3B071D.10505@gmail.com>
Date: Mon, 12 Jul 2010 13:14:21 +0100
From: Lee Jones <ljkenny@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.10) Gecko/20100527 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, akpm@linuxfoundation.org
Subject: [Upstream] Stop ARM boards crashing with CUPS is loaded
X-Enigmail-Version: 1.0.1
Content-Type: multipart/mixed;
 boundary="------------030109070704010001010209"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030109070704010001010209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Please find attached a patch which rectifies the following bug.

When CUPS loads, it tries to load several drivers that it may need.
When one of these drivers, specifically parport_pc is loaded on ARM
based systems, it causes a segmentation fault as the address is not
writable on non-PC based architectures. This code prevents this
driver from being compiled on said architectures.

Kind regards,
Lee

--------------030109070704010001010209
Content-Type: text/x-patch;
 name="0001-UBUNTU-Upstream-Stop-ARM-boards-crashing-with-CUPS-i.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-UBUNTU-Upstream-Stop-ARM-boards-crashing-with-CUPS-i.pa";
 filename*1="tch"

>From e7552c2cfbceb22af2765b7bea91e0ea830010b7 Mon Sep 17 00:00:00 2001
From: Lee Jones <lee.jones@canonical.com>
Date: Mon, 12 Jul 2010 12:41:54 +0100
Subject: [PATCH] UBUNTU: [Upstream] Stop ARM boards crashing with CUPS is loaded

BugLink: http://bugs.launchpad.net/bugs/601226

When CUPS loads, it tries to load several drivers that it may need.
When one of these drivers, specifically parport_pc is loaded on ARM
based systems, it causes a segmentation fault as the address is not
writable on non-PC based architectures. This code prevents this
driver from being compiled on said architectures.

Signed-off-by: Lee Jones <lee.jones@canonical.com>
---
 drivers/parport/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/parport/Kconfig b/drivers/parport/Kconfig
index 855f389..ef1c666 100644
--- a/drivers/parport/Kconfig
+++ b/drivers/parport/Kconfig
@@ -36,7 +36,7 @@ if PARPORT
 config PARPORT_PC
 	tristate "PC-style hardware"
 	depends on (!SPARC64 || PCI) && !SPARC32 && !M32R && !FRV && \
-		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN
+		(!M68K || ISA) && !MN10300 && !AVR32 && !BLACKFIN && !ARM
 	---help---
 	  You should say Y here if you have a PC-style parallel port. All
 	  IBM PC compatible computers and some Alphas have PC-style
-- 
1.7.0.4


--------------030109070704010001010209--
