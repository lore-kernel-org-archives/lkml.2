Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0DWB6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 21:58:12 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39209 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab0DWB6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 21:58:10 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-04-22-16-38 uploaded
In-Reply-To: Your message of "Thu, 22 Apr 2010 16:38:55 PDT."
             <201004230006.o3N06DNO019315@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <201004230006.o3N06DNO019315@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1271987879_5018P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 22 Apr 2010 21:57:59 -0400
Message-ID: <31157.1271987879@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020203.4BD0FEA7.00EE,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1271987879_5018P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Apr 2010 16:38:55 PDT, akpm=40linux-foundation.org said:
> The mm-of-the-moment snapshot 2010-04-22-16-38 has been uploaded to
>=20
>    http://userweb.kernel.org/=7Eakpm/mmotm/

Found this in numa-introduce-numa_mem_id-effective-local-memory-node-id.p=
atch:

+=23ifndef cpu_to_mem
+=23define cpu_to_mem(cpu)                (void)(cpu),0)
+=23endif

The resulting paren mismatch causes an error cascade in 2 other patches:

numa-in-kernel-profiling-use-cpu_to_mem-for-per-cpu-allocations.patch

causes build errors:

  CC      kernel/profile.o
kernel/profile.c: In function =E2=80=98profile_cpu_callback=E2=80=99:
kernel/profile.c:366: error: void value not ignored as it ought to be
kernel/profile.c:366: warning: left-hand operand of comma expression has =
no effect
kernel/profile.c:366: warning: statement with no effect
kernel/profile.c:366: error: expected =E2=80=98;=E2=80=99 before =E2=80=
=98)=E2=80=99 token
kernel/profile.c:366: error: expected statement before =E2=80=98)=E2=80=
=99 token
kernel/profile.c: In function =E2=80=98create_hash_tables=E2=80=99:
kernel/profile.c:568: error: void value not ignored as it ought to be
kernel/profile.c:568: error: expected identifier or =E2=80=98(=E2=80=99 b=
efore numeric constant
make=5B1=5D: *** =5Bkernel/profile.o=5D Error 1
make: *** =5Bkernel=5D Error 2

numa-slab-use-numa_mem_id-for-slab-local-memory-node.patch causes a whole=

raft of issues:

  CC      mm/slab.o
mm/slab.c: In function =E2=80=98cpuup_canceled=E2=80=99:
mm/slab.c:1156: error: void value not ignored as it ought to be
mm/slab.c:1156: error: expected identifier or =E2=80=98(=E2=80=99 before =
numeric constant
mm/slab.c: In function =E2=80=98cpuup_prepare=E2=80=99:
mm/slab.c:1221: error: void value not ignored as it ought to be
mm/slab.c:1221: error: expected identifier or =E2=80=98(=E2=80=99 before =
numeric constant
mm/slab.c: In function =E2=80=98kmem_cache_init=E2=80=99:
mm/slab.c:1506: error: =E2=80=98numa_node=E2=80=99 undeclared (first use =
in this function)
mm/slab.c:1506: error: (Each undeclared identifier is reported only once
mm/slab.c:1506: error: for each function it appears in.)
mm/slab.c:1506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pscr_ret__=E2=80=99
mm/slab.c:1506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98type name=E2=80=99
mm/slab.c:1506: warning: cast from pointer to integer of different size
mm/slab.c:1506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:1506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:1506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:1506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c: In function =E2=80=98setup_cpu_cache=E2=80=99:
mm/slab.c:2148: error: =E2=80=98numa_node=E2=80=99 undeclared (first use =
in this function)
mm/slab.c:2148: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pscr_ret__=E2=80=99
mm/slab.c:2148: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98type name=E2=80=99

mm/slab.c:2148: warning: cast from pointer to integer of different size
mm/slab.c:2148: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:2148: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:2148: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:2148: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c: In function =E2=80=98do_drain=E2=80=99:
mm/slab.c:2506: error: =E2=80=98numa_node=E2=80=99 undeclared (first use =
in this function)
mm/slab.c:2506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pscr_ret__=E2=80=99
mm/slab.c:2506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98type name=E2=80=99
mm/slab.c:2506: warning: cast from pointer to integer of different size
mm/slab.c:2506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:2506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:2506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:2506: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c: In function =E2=80=98cache_alloc_refill=E2=80=99:
mm/slab.c:3039: error: =E2=80=98numa_node=E2=80=99 undeclared (first use =
in this function)
mm/slab.c:3039: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pscr_ret__=E2=80=99
mm/slab.c:3039: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98type name=E2=80=99
mm/slab.c:3039: warning: cast from pointer to integer of different size
mm/slab.c:3039: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:3039: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:3039: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:3039: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c: In function =E2=80=98cache_flusharray=E2=80=99:
mm/slab.c:3575: error: =E2=80=98numa_node=E2=80=99 undeclared (first use =
in this function)
mm/slab.c:3575: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pscr_ret__=E2=80=99
mm/slab.c:3575: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98type name=E2=80=99
mm/slab.c:3575: warning: cast from pointer to integer of different size
mm/slab.c:3575: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:3575: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:3575: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:3575: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c: In function =E2=80=98do_tune_cpucache=E2=80=99:
mm/slab.c:4009: error: invalid use of void expression
mm/slab.c:4009: error: too few arguments to function =E2=80=98alloc_array=
cache=E2=80=99
mm/slab.c:4009: warning: left-hand operand of comma expression has no eff=
ect
mm/slab.c:4010: warning: left-hand operand of comma expression has no eff=
ect
mm/slab.c:4010: warning: left-hand operand of comma expression has no eff=
ect
mm/slab.c:4010: warning: statement with no effect
mm/slab.c:4010: error: expected =E2=80=98;=E2=80=99 before =E2=80=98)=E2=
=80=99 token
mm/slab.c:4010: error: expected statement before =E2=80=98)=E2=80=99 toke=
n
mm/slab.c:4031: error: expected =E2=80=98=5D=E2=80=99 before =E2=80=98)=
=E2=80=99 token
mm/slab.c:4031: warning: passing argument 1 of =E2=80=98spin_lock_irq=E2=
=80=99 from incompatible pointer type
include/linux/spinlock.h:307: note: expected =E2=80=98struct spinlock_t *=
=E2=80=99 but argument is of type =E2=80=98struct kmem_list3 **=E2=80=99
mm/slab.c:4031: error: expected =E2=80=98;=E2=80=99 before =E2=80=98=5D=
=E2=80=99 token
mm/slab.c:4031: error: expected statement before =E2=80=98=5D=E2=80=99 to=
ken
mm/slab.c:4031: error: expected expression before =E2=80=98->=E2=80=99 to=
ken
mm/slab.c:4031: error: expected statement before =E2=80=98)=E2=80=99 toke=
n
mm/slab.c:4032: error: invalid use of void expression
mm/slab.c:4032: error: too many arguments to function =E2=80=98free_block=
=E2=80=99
mm/slab.c:4032: error: expected =E2=80=98;=E2=80=99 before =E2=80=98)=E2=
=80=99 token
mm/slab.c:4032: error: expected statement before =E2=80=98)=E2=80=99 toke=
n
mm/slab.c:4033: error: expected =E2=80=98=5D=E2=80=99 before =E2=80=98)=
=E2=80=99 token
mm/slab.c:4033: warning: passing argument 1 of =E2=80=98spin_unlock_irq=
=E2=80=99 from incompatible pointer type
include/linux/spinlock.h:332: note: expected =E2=80=98struct spinlock_t *=
=E2=80=99 but argument is of type =E2=80=98struct kmem_list3 **=E2=80=99
mm/slab.c:4033: error: expected =E2=80=98;=E2=80=99 before =E2=80=98=5D=
=E2=80=99 token
mm/slab.c:4033: error: expected statement before =E2=80=98=5D=E2=80=99 to=
ken
mm/slab.c:4033: error: expected expression before =E2=80=98->=E2=80=99 to=
ken
mm/slab.c:4033: error: expected statement before =E2=80=98)=E2=80=99 toke=
n
mm/slab.c: In function =E2=80=98cache_reap=E2=80=99:
mm/slab.c:4139: error: =E2=80=98numa_node=E2=80=99 undeclared (first use =
in this function)
mm/slab.c:4139: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pscr_ret__=E2=80=99
mm/slab.c:4139: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98type name=E2=80=99
mm/slab.c:4139: warning: cast from pointer to integer of different size
mm/slab.c:4139: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:4139: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:4139: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
mm/slab.c:4139: warning: type defaults to =E2=80=98int=E2=80=99 in declar=
ation of =E2=80=98pfo_ret__=E2=80=99
make=5B1=5D: *** =5Bmm/slab.o=5D Error 1
make: *** =5Bmm=5D Error 2



--==_Exmh_1271987879_5018P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL0P6mcC3lWbTT17ARAofYAKCRwXe33gMLxLzr9+5B8grIVIljJgCfbmpG
Ni88aKf+xyMe/rxgamyuAYM=
=SbnD
-----END PGP SIGNATURE-----

--==_Exmh_1271987879_5018P--

