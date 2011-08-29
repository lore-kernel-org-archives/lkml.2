Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273Ab1H2Eo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 00:44:56 -0400
Received: from trent.utfs.org ([194.246.123.103]:52682 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab1H2Eox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 00:44:53 -0400
Date: Sun, 28 Aug 2011 21:44:50 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Trond.Myklebust@netapp.com
Subject: undefined reference to `sys_nfsservctl'
Message-ID: <alpine.DEB.2.01.1108282138020.9183@trent.utfs.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When trying to compile 3.1-rc3 (git -c11a7e2), this happens after MODPOST:

  MODPOST vmlinux.o
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/powerpc/kernel/built-in.o: In function `sys_call_table':
(.text+0x5be0): undefined reference to `sys_nfsservctl'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

Full make.log and .config: http://nerdbynature.de/bits/3.1-rc3/nfs/

This message can be found in an older thread, around 2.5.7:

  http://lkml.indiana.edu/hypermail/linux/kernel/0203.2/1006.html

In my .config I have set (from "make oldconfig")

# CONFIG_NFS_FS is not set
CONFIG_NFSD=y
CONFIG_NFSD_V3=y
# CONFIG_NFSD_V3_ACL is not set
CONFIG_NFSD_V4=y
CONFIG_NFS_COMMON=y

Any ideas?

Christian.
-- 
BOFH excuse #332:

suboptimal routing experience
