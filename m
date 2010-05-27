Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514Ab0E0JWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 05:22:33 -0400
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:44689 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756732Ab0E0JWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 05:22:31 -0400
Subject: [PATCH] gconfig: fix build failure on fedora 13
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 10:22:28 +0100
Message-ID: <1274952149.2210.12.camel@castor.rsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-2.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making gconfig fails on fedora 13 as the linker cannot resolve dlsym.
    
Adding libdl to the link command fixes this.
    
make shows this error :-
    /usr/bin/ld: scripts/kconfig/kconfig_load.o: undefined reference to symbol 'dlsym@@GLIBC_2.2.5'
    /usr/bin/ld: note: 'dlsym@@GLIBC_2.2.5' is defined in DSO /lib64/libdl.so.2 so try adding it to the linker command line
    /lib64/libdl.so.2: could not read symbols: Invalid operation

tested on x86_64 fedora 13.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
---
patch against 2.6.34, built & tested on x86_64. 

regards
Richard

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 186c466..9842611 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -208,7 +208,7 @@ HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 HOSTLOADLIBES_qconf	= $(KC_QT_LIBS) -ldl
 HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS) -D LKC_DIRECT_LINK
 
-HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`
+HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0` -ldl
 HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
                           -D LKC_DIRECT_LINK
 


