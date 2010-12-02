Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647Ab0LBQcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:32:13 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45612 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab0LBQcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:32:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OaHzwiimzUEhjWjp+sx4OiLqek84WGtxjFiaOx9pRCYJQs05MlpCXNylNOHsqA4MVC
         +SGsXQIRVzgvkFjq7i/3dUKpPpTxM1MgXwf/fUZB5SZItooQwxdm4VBZ7FFdig24SC90
         +N7L3aT78yuEQPrCUR57ad5tGgIJHOI/v6g3A=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, mmarek@suse.cz,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 0/4] V2 Add ability to link device blob(s) into vmlinux
Date: Thu,  2 Dec 2010 08:31:42 -0800
Message-Id: <cover.1291231792.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1289943240.git.dirk.brandewie@gmail.com>
References: <cover.1289943240.git.dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Resending using the correct To: address sorry for the spam on the CC: lists

This patch set adds the ability to link device tree blobs into
vmlinux. 

Patch 1 implements the changes to include/asm-generic/vmlinux.lds.h and
adds a generic rule for generating DTB objects to be linked vmlinux.

Patch 2 implements linking a DTB into an x86 image.

Patch 3-4 move {powerpc,microblaze}/boot/Makefile to use the dtc rule
in patch 1.

This patch set has been tested on x86.

Powerpc and Microblaze have been compile tested with and without patch
3 and 4 applied.

Changes from V1:

Documentation added for dtc command in Makefile.lib to
Documentation/kbuild/makefiles.txt
Separate DTB_ALIGNMENT define removed.
FORCE removed from dtc rule.
Removed hardcoded path to dts files from dtc command.  
Moved %.dtb: %.dts rule to arch specific makefiles. 
 
Patch for adding kernel command line option to pass in dtb_compat
string dropped from this set will be submitted seperately.

Dirk Brandewie (4):
  of: Add support for linking device tree blobs into vmlinux
  x86/of: Add building device tree blob(s) into image.
  of/powerpc: Use generic rule to build dtb's
  microblaze/of: Use generic rule to build dtb's

 Documentation/kbuild/makefiles.txt |   15 +++++++++++++++
 arch/microblaze/boot/Makefile      |   10 ++--------
 arch/powerpc/boot/Makefile         |    8 +++-----
 arch/x86/platform/ce4100/Makefile  |   10 ++++++++++
 include/asm-generic/vmlinux.lds.h  |   15 ++++++++++++---
 scripts/Makefile.lib               |   21 ++++++++++++++++++++-
 6 files changed, 62 insertions(+), 17 deletions(-)

-- 
1.7.2.3

