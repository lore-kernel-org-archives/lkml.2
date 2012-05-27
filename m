Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932885Ab2E0BtY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:49:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42774 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546Ab2E0BtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:49:17 -0400
Message-ID: <1338083358.2658.402.camel@shawn-ssd>
Subject: Re: git-unnoticed merge conflicts breaking arm cross-building
From: shawn <shawnlandden@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 26 May 2012 18:49:18 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  HOSTCC  scripts/mod/mk_elfconfig
cc1: error: unrecognized command line option ‘-mlittle-endian’
cc1: error: unrecognized command line option ‘-mno-thumb-interwork’
scripts/mod/empty.c:1:0: error: unknown ABI (aapcs-linux) for -mabi= switch
scripts/mod/empty.c:1:0: error: bad value (armv4t) for -march= switch
scripts/mod/empty.c:1:0: error: bad value (xscale) for -mtune= switch

-----
I checked out git master and tried to cross compile an arm kernel for my
sheevaplug

It fails with linker errors:

/usr/bin/ld.bfd.real: scripts/mod/file2alias.o: Relocations in generic
ELF (EM: 40)
/usr/bin/ld.bfd.real: scripts/mod/file2alias.o: Relocations in generic
ELF (EM: 40)
/usr/bin/ld.bfd.real: scripts/mod/file2alias.o: Relocations in generic
ELF (EM: 40)
/usr/bin/ld.bfd.real: scripts/mod/file2alias.o: Relocations in generic
ELF (EM: 40)
scripts/mod/file2alias.o: could not read symbols: File in wrong format
collect2: ld returned 1 exit status

where it appears that it isn't calling the cross-toolchain
(/usr/bin/arm-linux-gnueabi-ld)

I have 
CONFIG_CROSS_COMPILE="arm-linux-gnueabi-"


I did a full git bisect and

good: 
commit f08b9c2f8af0d61faa1170aeae4fbca1eff6a504
Merge: d79ee93 0ab711a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 22 18:38:11 2012 -0700

    Merge branch 'x86-apic-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

good: 
commit 99ce58ddc4eadec8c35d9a1d64ff57703fdcfacc
Merge: 56ccd18 44d27f7 4e52b53 ed13794
Author: Jiri Kosina <jkosina@suse.cz>
Date:   Tue May 22 11:33:42 2012 +0200

    Merge branches 'upstream-fixes', 'wacom' and 'waltop' into for-linus

first bad:
commit 3c2c4b73aa79e4a1b601710b59e092441175f4bb
Merge: f08b9c2 99ce58d
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue May 22 19:21:48 2012 -0700

    Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid


-- 
-Shawn Landden


