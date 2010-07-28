Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969Ab0G1EGK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 00:06:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42594 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806Ab0G1EGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 00:06:08 -0400
Date: Wed, 28 Jul 2010 14:05:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: linux-next: build failure after merge of the final tree (kgdb tree
 related)
Message-Id: <20100728140556.2bdacbf3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Jul_2010_14_05_56_+1000_on4IKzyjfasCl7OX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Jul_2010_14_05_56_+1000_on4IKzyjfasCl7OX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, next-20100726 build (i386 allmodconfig)
failed like this:

In file included from arch/x86/include/asm/uaccess.h:571,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:6,
                 from include/linux/pagemap.h:10,
                 from kernel/trace/trace.c:24:
arch/x86/include/asm/uaccess_32.h: In function 'copy_from_user':
arch/x86/include/asm/uaccess_32.h:212: error: call to 'copy_from_user_overf=
low' declared with attribute error: copy_from_user() buffer size is not pro=
vably correct

Probably caused by commit e5738a3d75254c6d135ccad925e513ddb860967e
("ftrace,kdb: Extend kdb to be able to dump the ftrace buffer") from the
kgdb tree which turned off optimization (and therefore probably inlining)
for kernel/trace/trace.c ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Jul_2010_14_05_56_+1000_on4IKzyjfasCl7OX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMT6ykAAoJEDMEi1NhKgbsPvoH/Ao4rMkHLo2MrtteHKv/w+oZ
WdWQit9/i2de8Eyk0dg0YMdfxbV5kLwg8zyQQsDk5OCKweGOF1h3685ncny6ufqp
In+yLLCiIsIh0jptEYfpP9hlbebbv9zD6Q0qyqY0mQDTVwHEL4l5oUkCyGHhMRZn
pv7Af+xQ4WrNDZn/5Fb7bWqJeIGBIqLIOjY7VO265yETVOoSSiYPVyaiSCf+V2eO
FNiClxtUrPmmxMu36YH78+3jREEPI7ArU/pHWkGvestY+xyT4Iw+D6U1zCh1sM4w
gity/1ROBfK0FFoRDdik1uNn2HX0upxlWv4fglBDtgS2H/WgDDxdr7bQ0ZsIJnA=
=EUQh
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Jul_2010_14_05_56_+1000_on4IKzyjfasCl7OX--
