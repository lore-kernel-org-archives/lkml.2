Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab0GASN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:13:27 -0400
Received: from kroah.org ([198.145.64.141]:60061 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176Ab0GASKw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:10:52 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:28:57 2010
Message-Id: <20100701172857.463337479@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:27:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Richard Kennedy <richard@rsk.demon.co.uk>,
       Michal Marek <mmarek@suse.cz>
Subject: [12/23] gconfig: fix build failure on fedora 13
In-Reply-To: <20100701175134.GA2098@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Richard Kennedy <richard@rsk.demon.co.uk>

commit cbab05f041a4cff6ca15856bdd35238b282b64eb upstream.

Making gconfig fails on fedora 13 as the linker cannot resolve dlsym.

Adding libdl to the link command fixes this.

make shows this error :-
    /usr/bin/ld: scripts/kconfig/kconfig_load.o: undefined reference to symbol 'dlsym@@GLIBC_2.2.5'
    /usr/bin/ld: note: 'dlsym@@GLIBC_2.2.5' is defined in DSO /lib64/libdl.so.2 so try adding it to the linker command line
    /lib64/libdl.so.2: could not read symbols: Invalid operation

tested on x86_64 fedora 13.

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/kconfig/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -161,7 +161,7 @@ HOSTCFLAGS_zconf.tab.o	:= -I$(src)
 HOSTLOADLIBES_qconf	= $(KC_QT_LIBS) -ldl
 HOSTCXXFLAGS_qconf.o	= $(KC_QT_CFLAGS) -D LKC_DIRECT_LINK
 
-HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0`
+HOSTLOADLIBES_gconf	= `pkg-config --libs gtk+-2.0 gmodule-2.0 libglade-2.0` -ldl
 HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
                           -D LKC_DIRECT_LINK
 


