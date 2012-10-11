Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab2JKCEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 22:04:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44807 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263Ab2JKCEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 22:04:32 -0400
X-Sasl-enc: syrQLgUqkAyrSclaxu/pMxnbmSkbKgIDxmxHVq0kEP6p 1349921071
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Tony Breeds <tony@bakeyournoodle.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 01/84] mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it
Date: Thu, 11 Oct 2012 11:02:45 +0900
Message-Id: <20121011015417.297003217@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011015417.017144658@linuxfoundation.org>
References: <20121011015417.017144658@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 9957423f035c2071f6d1c5d2f095cdafbeb25ad7 upstream.

It seems the current (gcc 4.6.3) no longer provides this so make it
conditional.

As reported by Tony before, the mn10300 architecture cross-compiles with
gcc-4.6.3 if -mmem-funcs is not added to KBUILD_CFLAGS.

Reported-by: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mn10300/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mn10300/Makefile
+++ b/arch/mn10300/Makefile
@@ -26,7 +26,7 @@ CHECKFLAGS	+=
 PROCESSOR	:= unset
 UNIT		:= unset
 
-KBUILD_CFLAGS	+= -mam33 -mmem-funcs -DCPU=AM33
+KBUILD_CFLAGS	+= -mam33 -DCPU=AM33 $(call cc-option,-mmem-funcs,)
 KBUILD_AFLAGS	+= -mam33 -DCPU=AM33
 
 ifeq ($(CONFIG_MN10300_CURRENT_IN_E2),y)


