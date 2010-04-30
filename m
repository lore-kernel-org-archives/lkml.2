Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab0D3StA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 14:49:00 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35328 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933971Ab0D3Ssd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 14:48:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-04-28-16-53 uploaded
In-Reply-To: Your message of "Fri, 30 Apr 2010 14:02:27 EDT."
             <1272650547.10027.97.camel@useless.americas.hpqcorp.net>
From: Valdis.Kletnieks@vt.edu
References: <201004290021.o3T0L04Y028017@imap1.linux-foundation.org> <18962.1272576730@localhost>
            <1272650547.10027.97.camel@useless.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1272653269_4026P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 30 Apr 2010 14:47:49 -0400
Message-ID: <21637.1272653269@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020205.4BDB25D5.023B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1272653269_4026P
Content-Type: text/plain; charset=us-ascii

On Fri, 30 Apr 2010 14:02:27 EDT, Lee Schermerhorn said:

> Would you have time to try a few patches?  I've been doing some rework
> of the generic percpu numa_node/numa_mem patches.  This rework should
> solve the build problem you encountered.

Not sure if I bollixed up adding the patches to the series file, that
section now looks like:

% grep -n ^numa series
1465:numa-add-generic-percpu-var-numa_node_id-implementation.patch
1466:numa-add-generic-percpu-var-numa_node_id-implementation-fix1.patch
1467:numa-add-generic-percpu-var-numa_node_id-implementation-fix2.patch
1468:numa-x86_64-use-generic-percpu-var-numa_node_id-implementation.patch
1469:numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix1.patch
1470:numa-x86_64-use-generic-percpu-var-numa_node_id-implementation-fix2.patch
1471:numa-ia64-use-generic-percpu-var-numa_node_id-implementation.patch
1473:numa-introduce-numa_mem_id-effective-local-memory-node-id.patch
1474:numa-introduce-numa_mem_id-effective-local-memory-node-id-fix.patch
1475:numa-introduce-numa_mem_id-effective-local-memory-node-id-fix2.patch
1476:numa-introduce-numa_mem_id-effective-local-memory-node-id-fix3.patch
1477:numa-ia64-support-numa_mem_id-for-memoryless-nodes.patch
1478:numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch
1479:numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch
1480:numa-update-documentation-vm-numa-add-memoryless-node-info.patch
1481:numa-update-documentation-vm-numa-add-memoryless-node-info-fix1.patch

and it dies with:

 LANG=C make
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      arch/x86/kernel/asm-offsets.s
In file included from include/linux/gfp.h:7,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/topology.h:246: error: redefinition of 'numa_node_id'
/usr/src/linux-2.6.34-rc5-mmotm0428/arch/x86/include/asm/topology.h:163: note: previous definition of 'numa_node_id' was here
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

X86_64 build, CONFIG_NUMA=n - looks like include/linux/topology.h doesn't
play nice in the !CONFIG_USE_PERCPU_NUMA_NODE_ID case...


--==_Exmh_1272653269_4026P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL2yXVcC3lWbTT17ARAlLhAKDuNfRj6bwGJNUkZwHrJmXyxOgbSwCgp7hu
U9lN7RIQzlpv5XHAVFXPX5U=
=ZAyx
-----END PGP SIGNATURE-----

--==_Exmh_1272653269_4026P--

