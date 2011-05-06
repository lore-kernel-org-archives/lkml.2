Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab1EFAiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:38:23 -0400
Received: from kroah.org ([198.145.64.141]:37366 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932514Ab1EFA0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:18 2011
Message-Id: <20110506002218.343471781@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [133/143] powerpc/boot/dts: Install dts from the right directory
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 4d9ef89dee13e964ea8b064d82ff55cf36209237 upstream.

The dts-installed variable is initialised using a wildcard path that
will be expanded relative to the build directory.  Use the existing
variable dtstree to generate an absolute wildcard path that will work
when building in a separate directory.

Reported-by: Gerhard Pircher <gerhard_pircher@gmx.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Tested-by: Gerhard Pircher <gerhard_pircher@gmx.net> [against 2.6.32]
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/boot/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -364,7 +364,7 @@ INSTALL := install
 extra-installed		:= $(patsubst $(obj)/%, $(DESTDIR)$(WRAPPER_OBJDIR)/%, $(extra-y))
 hostprogs-installed	:= $(patsubst %, $(DESTDIR)$(WRAPPER_BINDIR)/%, $(hostprogs-y))
 wrapper-installed	:= $(DESTDIR)$(WRAPPER_BINDIR)/wrapper
-dts-installed		:= $(patsubst $(obj)/dts/%, $(DESTDIR)$(WRAPPER_DTSDIR)/%, $(wildcard $(obj)/dts/*.dts))
+dts-installed		:= $(patsubst $(dtstree)/%, $(DESTDIR)$(WRAPPER_DTSDIR)/%, $(wildcard $(dtstree)/*.dts))
 
 all-installed		:= $(extra-installed) $(hostprogs-installed) $(wrapper-installed) $(dts-installed)
 


