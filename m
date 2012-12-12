Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab2LLVjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:39:08 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59640 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab2LLVjE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:39:04 -0500
MIME-Version: 1.0
Date: Wed, 12 Dec 2012 22:39:02 +0100
X-Google-Sender-Auth: bm2Ww629q7e45fOI2Pzen95VrUA
Message-ID: <CACPM=kU74+Yfjn-ju0PurqDj8QszR5ZP03UE0hH4cxKGc6Ub1A@mail.gmail.com>
Subject: Commit 607ca46e97a1b6594b29647d98a32d545c24bdff breaks building tools/hv/hv_kvp_daemon.c
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

It seems like this commit breaks building hv_kvp_daemon.

Here is the bisect log:

# good: [a0d271cbfed1dd50278c6b06bead3d00ba0a88f9] Linux 3.6
git bisect good a0d271cbfed1dd50278c6b06bead3d00ba0a88f9
# bad: [29594404d7fe73cd80eaa4ee8c43dcc53970c60e] Linux 3.7
git bisect bad 29594404d7fe73cd80eaa4ee8c43dcc53970c60e
# good: [d66e6737d454553e1e62109d8298ede5351178a4] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect good d66e6737d454553e1e62109d8298ede5351178a4
# good: [e1b28147f684af67bfac989756c27c19859d3d4e] Merge branch
'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux
git bisect good e1b28147f684af67bfac989756c27c19859d3d4e
# bad: [37820108f395032e850e400139d956561a043c26] Merge tag
'fixes-for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect bad 37820108f395032e850e400139d956561a043c26
# good: [4f1cd91497774488ed16119ec3f54b3daf1561de] Merge branch
'v4l_for_linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect good 4f1cd91497774488ed16119ec3f54b3daf1561de
# good: [9db908806b85c1430150fbafe269a7b21b07d15d] Merge tag 'md-3.7'
of git://neil.brown.name/md
git bisect good 9db908806b85c1430150fbafe269a7b21b07d15d
# bad: [43c422eda99b894f18d1cca17bcd2401efaf7bd0] apparmor: fix
apparmor OOPS in audit_log_untrustedstring+0x1c/0x40
git bisect bad 43c422eda99b894f18d1cca17bcd2401efaf7bd0
# bad: [2384d6aa079de7c16c7877220d3cd4c6f4f50767] bnx2x: fix handling
mf storage modes
git bisect bad 2384d6aa079de7c16c7877220d3cd4c6f4f50767
# good: [dbadc17683e6c673a69b236c0f041b931cc55c42] X.509: Fix
indefinite length element skip error handling
git bisect good dbadc17683e6c673a69b236c0f041b931cc55c42
# good: [35bafbee4b4732a2820bbd0ef141c8192ff29731] Merge tag
'disintegrate-mips-20121009' of
git://git.infradead.org/users/dhowells/linux-headers into
mips-for-linux-next
git bisect good 35bafbee4b4732a2820bbd0ef141c8192ff29731
# bad: [0b381a286e5d748b1fd80095d3dd52326819742f] Merge tag
'disintegrate-main-20121013' of
git://git.infradead.org/users/dhowells/linux-headers
git bisect bad 0b381a286e5d748b1fd80095d3dd52326819742f
# good: [7c5a47346989e43ba34a9c94a55cc0aef7ed6b3b] Merge tag
'openrisc-uapi' of git://openrisc.net/jonas/linux
git bisect good 7c5a47346989e43ba34a9c94a55cc0aef7ed6b3b
# bad: [607ca46e97a1b6594b29647d98a32d545c24bdff] UAPI: (Scripted)
Disintegrate include/linux
git bisect bad 607ca46e97a1b6594b29647d98a32d545c24bdff
# good: [08cce05c5a91f5017f4edc9866cf026908c73f9f] UAPI: Unexport
linux/blk_types.h
git bisect good 08cce05c5a91f5017f4edc9866cf026908c73f9f

Here is the build output from 3.7.0:

hv # gcc hv_kvp_daemon.c -I/usr/src/linux/include -o hv_kvp_daemon
In file included from hv_kvp_daemon.c:29:0:
/usr/src/linux/include/linux/types.h:14:26: error: conflicting types
for ‘fd_set’
/usr/include/sys/select.h:75:5: note: previous declaration of ‘fd_set’ was here
/usr/src/linux/include/linux/types.h:15:25: error: conflicting types for ‘dev_t’
/usr/include/sys/types.h:60:17: note: previous declaration of ‘dev_t’ was here
/usr/src/linux/include/linux/types.h:17:26: error: conflicting types
for ‘mode_t’
/usr/include/sys/types.h:70:18: note: previous declaration of ‘mode_t’ was here
/usr/src/linux/include/linux/types.h:25:26: error: conflicting types
for ‘timer_t’
/usr/include/time.h:103:19: note: previous declaration of ‘timer_t’ was here
/usr/src/linux/include/linux/types.h:134:23: error: conflicting types
for ‘blkcnt_t’
/usr/include/sys/types.h:235:20: note: previous declaration of
‘blkcnt_t’ was here
In file included from /usr/lib/gcc/i586-pc-linux-gnu/4.6.3/include/stdint.h:3:0,
                 from /usr/include/netinet/in.h:23,
                 from /usr/include/arpa/inet.h:22,
                 from hv_kvp_daemon.c:36:
/usr/include/stdint.h:128:23: error: conflicting types for ‘uintptr_t’
/usr/src/linux/include/linux/types.h:36:24: note: previous declaration
of ‘uintptr_t’ was here
In file included from /usr/src/linux/include/linux/connector.h:25:0,
                 from hv_kvp_daemon.c:37:
/usr/src/linux/include/linux/atomic.h:4:24: fatal error: asm/atomic.h:
No such file or directory
compilation terminated.

Is there an easy fix for this, my server is complaining about I need
to upgrade hv_kvp_daemon for my 3.7.0 kernel.

Best regards,
Bjarke
