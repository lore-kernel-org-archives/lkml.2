Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab0GNX6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:58:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39638 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0GNX6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=YvhZ4mG2eYzWL/RdRN/x/I9UzBaYBbzyZdG6x/FF5hVynDOQPmmDwIB1LXd6jirKfD
         dNm7QIWAdyRWNFigshb071bIkQ/H3iZRt7eEX2+G2mg/a9CUSQZOvjtdYhOevW2WFS/I
         pYFLdBBQ1lQB5Ufcgap4MCT2vBqUL41/q+46Q=
Message-ID: <4C3E4F2F.3090404@lwfinger.net>
Date: Wed, 14 Jul 2010 18:58:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: Bugzilla # 16395: Regression in 2.6.35-rc4 since commit 0b28bac5aef7bd1ab213723df031e61db9ff151a
 on HP Mini 110 Netbook
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the commit in the title, a kernel built on an HP Mini 110 Netbook no
longer has keyboard input. The main difference is that CONFIG_SERIO_I8042 is no 
longer defined. When this equal yes, the keyboard works. The faulty commit was 
located by bisection and has been verified by reverting the patch.

Further investigation shows that the faulty hunk is

diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 3bfe8fa..256b9e9 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -22,7 +22,7 @@ config SERIO_I8042
         tristate "i8042 PC Keyboard controller" if EMBEDDED || !X86
         default y
         depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
-                  (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN
+                  (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !X86_MRST
         help
           i8042 is the chip over which the standard AT keyboard and PS/2
           mouse are connected to the computer. If you use these devices,

Reverting this one hunk alone results in a working system. Obviously, this
Netbook does not have X86_MRST set.
