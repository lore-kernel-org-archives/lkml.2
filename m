Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab0LHPBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:01:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51921 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0LHPBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:01:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=l1MTMuXF0KFLwWkpchcO+V8G0pJuqE8mG+k2tloVymnm21s66UYyOwVQ5eDIxRFlwC
         +0Z/C0VZaVLR2ecwK5i+halFVub0DtqFwilEcr7lNQ3OW4GHZ1EWex4DeCihrgYhkx9a
         uBNnIKlv09k2g/7P+JsF7VRTRS7Q3RamvX8vc=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, sodaville@linutronix.de,
        linuxppc-dev@lists.ozlabs.org, microblaze-uclinux@itee.uq.edu.au,
        linux-arch@vger.kernel.org, mmarek@suse.cz,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 0/4] V3 Add ability to link device blob(s) into vmlinux
Date: Wed,  8 Dec 2010 07:01:12 -0800
Message-Id: <cover.1291820033.git.dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

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

Changes from V2:

Rule to create assembly wrapper for blob changed to use Sam Ravnborgs
suggested implementation.

Rules in architecture specific Makefiles changed to use the cmd
function instead of the if_changed function.

Dirk Brandewie (4):
  of: Add support for linking device tree blobs into vmlinux
  x86/of: Add building device tree blob(s) into image.
  of/powerpc: Use generic rule to build dtb's
  microblaze/of: Use generic rule to build dtb's

 Documentation/kbuild/makefiles.txt |   15 +++++++++++++++
 arch/microblaze/boot/Makefile      |   12 +++---------
 arch/powerpc/boot/Makefile         |    8 +++-----
 arch/x86/platform/ce4100/Makefile  |   10 ++++++++++
 include/asm-generic/vmlinux.lds.h  |   13 +++++++++++--
 scripts/Makefile.lib               |   23 +++++++++++++++++++++++
 6 files changed, 65 insertions(+), 16 deletions(-)

-- 
1.7.2.3

