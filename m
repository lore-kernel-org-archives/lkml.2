Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab2B1Nhd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:37:33 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:56876 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545Ab2B1Nh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:37:29 -0500
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [RFC][PATCH 0/6] Add endian functions to tools/include
Date: Tue, 28 Feb 2012 13:37:19 +0000
Message-Id: <1330436245-24875-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

There's a few host tools in the kernel that are rolling their own
versions of the {get,put}_unaligned_le*() functions. This series
copies the include/linux/unaligned/*_byteshift.h headers to
tools/include for their use.

I don't think it really makes sense for these to be exported to
userspace (i.e. installed by make headers_install) because they're
only used by hostprogs within the kernel, but this series is RFC for a
reason - because I'm not sure where they belong.

Matt Fleming (6):
  tools/include: Add byteshift headers for endian access
  x86, relocs: Don't open code put_unaligned_le32()
  x86, mkpiggy: Don't open code put_unaligned_le32()
  x86, boot: Restrict CFLAGS for hostprogs
  x86, efi: Fix endian issues and unaligned accesses
  USB: ffs-test: Don't duplicate {get,put}_unaligned*() functions

 arch/x86/boot/Makefile             |    5 ++-
 arch/x86/boot/compressed/Makefile  |    1 +
 arch/x86/boot/compressed/mkpiggy.c |   11 +-----
 arch/x86/boot/compressed/relocs.c  |    6 +--
 arch/x86/boot/tools/build.c        |   31 ++++++++--------
 tools/include/tools/be_byteshift.h |   70 ++++++++++++++++++++++++++++++++++++
 tools/include/tools/le_byteshift.h |   70 ++++++++++++++++++++++++++++++++++++
 tools/usb/Makefile                 |    2 +-
 tools/usb/ffs-test.c               |   29 +--------------
 9 files changed, 165 insertions(+), 60 deletions(-)
 create mode 100644 tools/include/tools/be_byteshift.h
 create mode 100644 tools/include/tools/le_byteshift.h

-- 
1.7.4.4

