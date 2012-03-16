Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032256Ab2CPOSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:18:44 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:33346 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758857Ab2CPOSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:18:42 -0400
From: Matt Fleming <matt@console-pimps.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garret <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 0/3] x86, efi: EFI boot stub documentation
Date: Fri, 16 Mar 2012 14:18:34 +0000
Message-Id: <1331907517-3985-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Some people trying out the EFI stub have been confused about the
syntax for the initrd= option, so this series adds some information to
Documentation/x86. It also adds some helpful error messages, as
previously if the user specified an incorrect initrd filename the
machine just appeared to hang. Now at least it will print a message
saying that it couldn't open the file.

The first patch is actually a bug fix for an issue where the wrong
loop counter was used when trying to close initrd files in the error
path, which caused the machine to hang because a garbage pointer was
dereferenced.

Ideally I'd like to squeeze at least the last two patches in before
v3.3 is released.

Matt Fleming (3):
  x86, efi: Only close open files in error path
  x86, efi; Add EFI boot stub console support
  x86, efi: Add EFI boot stub documentation

 Documentation/x86/efi-stub.txt   |   65 ++++++++++++++++++++++++++++
 arch/x86/Kconfig                 |    2 +
 arch/x86/boot/compressed/eboot.c |   88 ++++++++++++++++++++++++++++++-------
 arch/x86/boot/compressed/eboot.h |    6 +++
 4 files changed, 144 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/x86/efi-stub.txt

-- 
1.7.4.4

