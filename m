Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2KTOW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:22:57 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:51089 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab2KTOW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:22:56 -0500
X-Nat-Received: from [202.181.97.72]:60757 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1353421338.22984
To: dhowells@redhat.com, sam@ravnborg.org
Cc: arnd@arndb.de, tglx@linutronix.de, paulmck@linux.vnet.ibm.com,
        davej@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [3.7-rc6] Build failure with scripts/Makefile.headersinst
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201211192202.IBE48444.VHFLtOSOQFOMJF@I-love.SAKURA.ne.jp>
	<201211172227.BHB30739.OVOMFtFLHOFSQJ@I-love.SAKURA.ne.jp>
	<24020.1353323415@warthog.procyon.org.uk>
	<26846.1353334165@warthog.procyon.org.uk>
In-Reply-To: <26846.1353334165@warthog.procyon.org.uk>
Message-Id: <201211202322.AED21884.FJtLHOFSOOQVMF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 20 Nov 2012 23:22:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 20112012 #8466525, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Does $(info ...) not work at all in version 3.80?  If it does, can you get it
> to display the values $(destination-y), $(dst) and $(obj) at the top of
> Makefile.headersinst?  If $(info ...) doesn't exist, does $(warning ...)?

$(info ...) does not work, but $(warning ...) works.

Debug print shows that command line variable "dst=" passed to
  make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst
line is wrong.

---------- debug print ----------
--- a/scripts/Makefile.headersinst
+++ b/scripts/Makefile.headersinst
@@ -7,6 +7,10 @@
 #
 # ==========================================================================
 
+$(warning DDDDD "$(destination-y)")
+$(warning EEEEE "$(dst)")
+$(warning FFFFF "$(obj)")
+
 # called may set destination dir (when installing to asm/)
 _dst := $(or $(destination-y),$(dst),$(obj))
---------- make 3.81 ----------
make -f scripts/Makefile.build obj=scripts build_unifdef
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi
/usr/src/all/linux/scripts/Makefile.headersinst:10: DDDDD ""
/usr/src/all/linux/scripts/Makefile.headersinst:11: EEEEE ""
/usr/src/all/linux/scripts/Makefile.headersinst:12: FFFFF "include/uapi"
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi/asm-generic dst=include/uapi/asm-generic
/usr/src/all/linux/scripts/Makefile.headersinst:10: DDDDD ""
/usr/src/all/linux/scripts/Makefile.headersinst:11: EEEEE "include/uapi/asm-generic"
/usr/src/all/linux/scripts/Makefile.headersinst:12: FFFFF "include/uapi/asm-generic"
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi/drm dst=include/uapi/drm
/usr/src/all/linux/scripts/Makefile.headersinst:10: DDDDD ""
/usr/src/all/linux/scripts/Makefile.headersinst:11: EEEEE "include/uapi/drm"
/usr/src/all/linux/scripts/Makefile.headersinst:12: FFFFF "include/uapi/drm"
---------- make 3.80 ----------
make -f scripts/Makefile.build obj=scripts build_unifdef
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi
/usr/src/all/linux/scripts/Makefile.headersinst:10: DDDDD ""
/usr/src/all/linux/scripts/Makefile.headersinst:11: EEEEE ""
/usr/src/all/linux/scripts/Makefile.headersinst:12: FFFFF "include/uapi"
make -rR -f /usr/src/all/linux/scripts/Makefile.headersinst obj=include/uapi/asm-generic dst=/asm-generic
/usr/src/all/linux/scripts/Makefile.headersinst:10: DDDDD ""
/usr/src/all/linux/scripts/Makefile.headersinst:11: EEEEE "/asm-generic"
/usr/src/all/linux/scripts/Makefile.headersinst:12: FFFFF "include/uapi/asm-generic"
/usr/src/all/linux/scripts/Makefile.headersinst:54: *** Missing UAPI file /usr/src/all/linux/include/uapi/asm-generic/auxvec.h.  Stop.
