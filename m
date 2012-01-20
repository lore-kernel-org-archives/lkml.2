Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab2ATA40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 19:56:26 -0500
Received: from host86-180-251-195.range86-180.btcentralplus.com ([86.180.251.195]:46899
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2ATA4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 19:56:25 -0500
X-Greylist: delayed 672 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jan 2012 19:56:25 EST
Message-ID: <4F18B911.2060601@oak.selfip.net>
Date: Fri, 20 Jan 2012 00:45:05 +0000
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0) Gecko/20120111 Thunderbird/10.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: PROBLEM: Postgres fails to start due to kernel issue?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   I noticed after upgrading to 3.2.0-08812-gc2bc3a3 that Postgres-9.1 server fails to start with error:

FATAL:  could not create shared memory segment: Function not implemented
DETAIL:  Failed system call was shmget(key=5432001, size=30523392, 03600).

   After some googling, I thought it was a SYSV shared memory sizing issue but manually changing kernel.shmmax and kernel.shmall had no effect.

   The problem has been introduced between 3.2.0-08694-g53999bf and 3.2.0-08812-gc2bc3a3.

   Let me know if you need any more information.  Bisecting is *very* slow on this machine!

Broken version (latest):

$ sudo sh scripts/ver_linux

Linux s1 3.2.0-09429-g90a4c0f #133 SMP Thu Jan 19 15:17:03 GMT 2012 i686 Pentium III (Coppermine) GenuineIntel GNU/Linux

Gnu C                  4.6.2
Gnu make               3.82
binutils               2.21.1
util-linux             2.19.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.41.14
Linux C Library        2.14.1
Dynamic linker (ldd)   2.14.1
Procps                 3.2.8
Net-tools              1.60_p20110409135728
Kbd                    1.15.3wip
Sh-utils               8.7

$ sudo sysctl -a | grep shm
kernel.shmmax = 33554432
kernel.shmall = 2097152
kernel.shmmni = 4096
kernel.shm_rmid_forced = 0
vm.hugetlb_shm_group = 0

Working version (last good backup):

$ sudo sh scripts/ver_linux

Linux s1 3.2.0 #124 SMP Thu Jan 5 08:06:00 GMT 2012 i686 Pentium III (Coppermine) GenuineIntel GNU/Linux

Gnu C                  4.6.2
Gnu make               3.82
binutils               2.21.1
util-linux             2.19.1
mount                  support
module-init-tools      3.16
e2fsprogs              1.41.14
Linux C Library        2.14.1
Dynamic linker (ldd)   2.14.1
Procps                 3.2.8
Net-tools              1.60_p20110409135728
Kbd                    1.15.3wip
Sh-utils               8.7

$ sudo sysctl -a | grep shm
kernel.shmmax = 33554432
kernel.shmall = 2097152
kernel.shmmni = 4096
kernel.shm_rmid_forced = 0
vm.hugetlb_shm_group = 0

Dave.


