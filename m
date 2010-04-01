Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0DAVdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:33:07 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:51567 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754022Ab0DAVdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:33:01 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-kernel@vger.kernel.org
Subject: 2.6.31 regression: programs crashing after a couple of days of uptime with hibernation
Date: Thu, 1 Apr 2010 23:32:47 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004012332.49454.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
with kernel 2.6.30, I can have uptime of more than a month on my desktop PC
(with hibernation). It's impossible with 2.6.31. After 1 to 3 days, processes
that were running during hibernation (e.g. konsole, kwin, kicker, xorg) start
to crash randomly in very weird ways. The kernel itself does not seem to
crash. When I run the crashed program again, it seems to work. Looks like
some memory corruption.

This bug is also present in 2.6.32 and 2.6.33.

This is very hard to debug as the test case takes 3 days. I've been trying to
bisect it anyway. And after long time, I failed. Got this, which is obviously
wrong:
187f81b3d8d315c35c73ac0d05b15a04a0ac3ce7 is first bad commit

git bisect log
git-bisect start
# good: [07a2039b8eb0af4ff464efd3dfd95de5c02648c6] Linux 2.6.30
git-bisect good 07a2039b8eb0af4ff464efd3dfd95de5c02648c6
# bad: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
git-bisect bad 74fca6a42863ffacaf7ba6f1936a9f228950f657
# good: [925d74ae717c9a12d3618eb4b36b9fb632e2cef3] V4L/DVB (11736): videobuf: modify return value of VIDIOC_REQBUFS ioctl
git-bisect good 925d74ae717c9a12d3618eb4b36b9fb632e2cef3
# bad: [a380137900fca5c79e6daa9500bdb6ea5649188e] ixgbe: Fix device capabilities of 82599 single speed fiber NICs.
git-bisect bad a380137900fca5c79e6daa9500bdb6ea5649188e
# good: [1dbb5765acc7a6fe4bc1957c001037cc9d02ae03] Staging: android: lowmemorykiller: fix up remaining checkpatch warnings
git-bisect good 1dbb5765acc7a6fe4bc1957c001037cc9d02ae03
# good: [df36b439c5fedefe013d4449cb6a50d15e2f4d70] Merge branch 'for-2.6.31' of git://git.linux-nfs.org/projects/trondmy/nfs-2.6
git-bisect good df36b439c5fedefe013d4449cb6a50d15e2f4d70
# bad: [a800faec1b21d7133b5f0c8c6dac593b7c4e118d] Merge branch 'for-linus' of git://www.jni.nu/cris
git-bisect bad a800faec1b21d7133b5f0c8c6dac593b7c4e118d
# bad: [ac1b7c378ef26fba6694d5f118fe7fc16fee2fe2] Merge git://git.infradead.org/mtd-2.6
git-bisect bad ac1b7c378ef26fba6694d5f118fe7fc16fee2fe2
# bad: [9e268beb92ee3a853b3946e84b10358207e2085f] Merge branch 'devel' of master.kernel.org:/home/rmk/linux-2.6-arm
git-bisect bad 9e268beb92ee3a853b3946e84b10358207e2085f
# good: [ab52ae6db035fa425f90146327ab7d2c5d3e5654] nfsd41: Backchannel: minorversion support for the back channel
git-bisect good ab52ae6db035fa425f90146327ab7d2c5d3e5654
# bad: [c2860d43f5dfab599fc1308ab61b1d3e30801ceb] [ARM] 5540/1: 32-bit Thumb-2 {ld,st}{m,rd} alignment fault fixup support
git-bisect bad c2860d43f5dfab599fc1308ab61b1d3e30801ceb
# bad: [187f81b3d8d315c35c73ac0d05b15a04a0ac3ce7] Merge branch 'for-rmk' of git://git.kernel.org/pub/scm/linux/kernel/git/ycmiao/pxa-linux-2.6 into devel
git-bisect bad 187f81b3d8d315c35c73ac0d05b15a04a0ac3ce7
# good: [6ea0414fc748ab5b1d83a414c7ee3a60190363aa] [ARM] pxa/hx4700: add Maxim 1587A voltage regulator
git-bisect good 6ea0414fc748ab5b1d83a414c7ee3a60190363aa
# good: [8776b268c6b0b671c2c744b06fee021b6da3e45f] [ARM] pxa: register wm8731 explicitly for corgi and poodle
git-bisect good 8776b268c6b0b671c2c744b06fee021b6da3e45f
# good: [cafc22658e85f65df72bee31c31b1fb337e7e606] MAINTAINERS: Update entry with file and SCM for EZX
git-bisect good cafc22658e85f65df72bee31c31b1fb337e7e606
# good: [d78ff0a50aac6a1bfe445969dd963e6486e49f56] MAINTAINERS: add entry for Mitac Mio A701 board
git-bisect good d78ff0a50aac6a1bfe445969dd963e6486e49f56


-- 
Ondrej Zary
