Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab0DTRJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 13:09:22 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:55028 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab0DTRJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 13:09:20 -0400
Message-ID: <4BCDDFBB.40805@web.de>
Date: Tue, 20 Apr 2010 19:09:15 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Amerigo Wang <xiyou.wangcong@gmail.com>, trivial@kernel.org,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/5] uml: Fix warning due to missing task_struct	declaration
References: <cover.1271713955.git.jan.kiszka@web.de> <1d97cd7761a1eae73923b1adda4c6915a0647bb3.1271713955.git.jan.kiszka@web.de> <20100420100949.GB5317@cr0.nay.redhat.com> <20100420143016.GB30011@c-98-229-117-200.hsd1.ma.comcast.net>
In-Reply-To: <20100420143016.GB30011@c-98-229-117-200.hsd1.ma.comcast.net>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig76671BA5C986E9BC10A891BD"
X-Provags-ID: V01U2FsdGVkX1/CJgxCacXKxnnxzLZCUQAko2uCqrvHNXb3EAcc
	vX6tAbEgfcN+8MngbtRCuppawtm/tgoTpI7P/7WxpOCwlqbf1c
	zuwsi4N5M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig76671BA5C986E9BC10A891BD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Jeff Dike wrote:
> On Tue, Apr 20, 2010 at 06:09:49PM +0800, Amerigo Wang wrote:
>> On Mon, Apr 19, 2010 at 11:53:06PM +0200, Jan Kiszka wrote:
>>> We can't pull in linux/sched.h, so just declare the struct.
>>>
>> Did you meet any build error? If yes, please include it.
>=20
> What does this patch fix, aside from being a bit cleaner?

  CC      arch/um/sys-i386/elfcore.o
In file included from /data/linux-2.6/include/linux/elf.h:8,
                 from /data/linux-2.6/arch/um/sys-i386/elfcore.c:2:
/data/linux-2.6/arch/um/sys-i386/asm/elf.h:78: warning: =E2=80=98struct t=
ask_struct=E2=80=99 declared inside parameter list
/data/linux-2.6/arch/um/sys-i386/asm/elf.h:78: warning: its scope is only=
 this definition or declaration, which is probably not what you want

I guess not many people build against i386 hosts anymore, so this
remained widely unnoticed.

>=20
> If it built before, without having a task_struct declaration, I think
> that means that the elf_core_copy_fpregs was never used.  The
> task_struct * in the declaration would become a private task_struct,
> known only to the declaration.  If the implementation or callers have
> the regular task_struct, it will be a different one, and the
> prototypes will conflict due to the different types of the first
> parameter.

This is just a forward declaration (that many arch elf header include),
so no such problem exists.

BTW, to answer the other question in this thread: We have a circular
dependency that prevents including sched.h.

I can add all these information to some v2 of this patch if it is
required to get this merged. Please let me know.

Jan



--------------enig76671BA5C986E9BC10A891BD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkvN378ACgkQitSsb3rl5xR6ogCgpedc9coMXt/vzGWlVLaILyL5
NBcAnRYpRZKpsbX+nFF+CKUpfCuUga5k
=JxWB
-----END PGP SIGNATURE-----

--------------enig76671BA5C986E9BC10A891BD--
