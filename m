Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2EAFGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 01:06:08 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:56179 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881Ab2EAFGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 01:06:05 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Date: Tue, 1 May 2012 01:06:36 -0400
User-Agent: KMail/1.13.7 (Linux/3.3.4; KDE/4.6.5; x86_64; ; )
Cc: Chen Liqin <liqin.chen@sunplusct.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
References: <20120426231942.GJ6871@ZenIV.linux.org.uk> <20120429180535.GZ6871@ZenIV.linux.org.uk> <20120501043129.GF6871@ZenIV.linux.org.uk>
In-Reply-To: <20120501043129.GF6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1839395.1EfDY8gLil";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201205010106.38495.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1839395.1EfDY8gLil
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Tuesday 01 May 2012 00:31:29 Al Viro wrote:
> blackfin: no loop (=3D=3D multiple signals handling is fucked); no check =
either
>         ret_from_fork doesn't handle signals, etc., userland or not.
>         kernel_execve doesn't handle signals, etc., success or no success
>         conclusion: check is probably not needed, multiple pending signals
> are screwed

to be honest, i haven't been following this thread as Blackfin wasn't menti=
oned=20
in the initial summary.  now it seems we have ;).  i tried going back throu=
gh=20
this TIF_NOTIFY_RESUME thread but haven't quite got a bead on what needs to=
 be=20
done.

seems like you're only referring to ret_from_fork here and not the normal=20
syscall return path ?  in the Blackfin case, we don't have a fork(), so we =
only=20
have to handle the supervisor mode case (spawning kthreads), so i don't thi=
nk=20
we're quite as fucked as you might think :).

what is it you're suggesting we add ?  in the past, i found documentation o=
n=20
the arch TIF_*/notify requirements to be pretty much non-existent.  so some=
=20
parts of the Blackfin paths are what i found from my eyes bleeding x86 asm=
=20
paths, and from single testing some random tests (like strace or gdb).  thi=
ngs=20
seem to run & be debugable, and no one has complained thus far, so we ship =
it!
=2Dmike

--nextPart1839395.1EfDY8gLil
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPn29eAAoJEEFjO5/oN/WBIuQP/3MgORCglH6V6U8MiDn7LOaY
3X0M6QFTu0Sl+p1b7H2IHqZgGdohGr7QaotebkxCNrACkUY4axKeUxJcWE+aQs5C
LP478XspH/a+XdCunvSlmezL8dY4eLlmi1dyHCAzOoKZ2e0YECGm+NkRwENHPI8N
SAZo9rljjEYkvKjOO1+25jjkkAsmad3YiynXshDPco0km4winwdjrt0Vk1wlkgJz
EFRNPvKmIAVDb9d2GvkhnNuX5A2pP5DJIlLT7afJ/JCexdfAS72U1+HhLczgl1ZY
cx7vw/IgpRjLeTR0JA6L3yFxcNkiv111MJmJuITWMwBKO3B0X/FqHo0IRf9gy+fv
p4SuQslugavmtMK8z+jO0E2f3+fLwxrnCneCu3FhqU2vYzIdTMJsDCT6S0fBrrp4
jFaFSCgDDZ2bEMAHbXjBh+RkVfq+ECkIoMV12odPDHNdC0lTX76FJBzLTNIxYrlu
Ieh5SSnyL5QtceEwtJR0IxGyq88uId6cFGVj0vQkDo7xxfK/nUnXAo1UPly+Ocd8
yr4QryS0SWtEzGt9kDJ07Su2CBmKiHZMS9JUjfo2KBczkv2RMODYPnOFS9j2rczB
A6KJcThKxO3Y9N/wK9ZT+ISIFiNOgq4hOM7Jcx5w4SgnmobhtZEtDYN5YhB1cr8V
6tLw10yi/PBYnTBX1XZf
=5XkO
-----END PGP SIGNATURE-----

--nextPart1839395.1EfDY8gLil--
