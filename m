Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2EWXN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:13:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55755 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2EWXNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:13:25 -0400
Date: Thu, 24 May 2012 09:13:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Richard Weinberger <richard@nod.at>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for May 23 (uml)
Message-Id: <20120524091306.e6f6b17d7240b29a124b44c3@canb.auug.org.au>
In-Reply-To: <20120523193707.GO11775@ZenIV.linux.org.uk>
References: <20120523170740.ae058d8d5468d471eb948c39@canb.auug.org.au>
	<4FBD090E.5020901@xenotime.net>
	<20120523181917.GN11775@ZenIV.linux.org.uk>
	<20120523193707.GO11775@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_May_2012_09_13_06_+1000_ndfER3QhT=Zd29XE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_May_2012_09_13_06_+1000_ndfER3QhT=Zd29XE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Wed, 23 May 2012 20:37:07 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> On Wed, May 23, 2012 at 07:19:17PM +0100, Al Viro wrote:
>=20
> > Grr...  That's a conflict between uml gaining TIF_NOTIFY_RESUME (needed
> > prereq to task_work_add() series) and patch in said series doing away
> > with explicit calls of key_replace_session_keyring().  Fixup is to remo=
ve
> > those two lines in arch/um/process.c, same as done on other architectur=
es
> > by "keys: kill the dummy key_replace_session_keyring()" (commit c1cb001=
).
> >=20
> > Not an issue for mainline merge, since task_work_add patchset goes late=
r,
> > but I think I'll have to cherry-pick that series into signal.git.  And
> > probably reorder it a bit, moving the calls into tracehook_notify_resum=
e()
> > first, with "kill the dummy..." commit removing just that single call.
>=20
> Hmm...  Two solutions, take your pick:
>=20
> 1)
> 	I think the minimal solution is this: I add the "move
> key_replace_session_keyring() into tracehook_notify_resume()" into signal=
.git
> for-next, which yields one conflict with next/akpm.  With conflict resolu=
tion
> being "take tracehook_notify_resume() from next/akpm".  I've put that
> into for-next-variant1
>=20
> 2)
> 	Cherry-picked these guys into signal.git, along with the rest
> of signal prereqs for them.  Merge with next/akpm-base yields a couple
> of trivial conflicts in kernel/fork.c (with
> 	sched, mm: Rework sched_{fork,exec} node assignment
> removing INIT_LIST_HEAD right next to the place where we add one; conflict
> resolution being just keep the one Oleg adds and remove the one Peter rem=
oves)
> and in kernel/irq/manage.c (with
> 	genirq: Be more informative on irq type mismatch
> changing a couple of printks in there; conflict resolution: just remove
> exit_irq_thread() in merged variant).  That's for-next-variant2.  With th=
at
> variant we get 5 more duplicates with next/akpm, obviously.
>=20
> Stephen, which way would you prefer it handled?

So variant2 sits on top of variant1 and you are intending to push the
work in variant2 in this merge window anyway?   In that case variant2
makes sense.  The number of small conflicts don't matter to much (up to a
point anyway :-)).  Also, these cherry-picks are out of Andrew's tree,
right (so they are already in linuc-next)?  In which case I would
probably go with variant2.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__24_May_2012_09_13_06_+1000_ndfER3QhT=Zd29XE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPvW8CAAoJEECxmPOUX5FEgy4P/3isNazl8ZGNZng2y3ao2qXT
RWe7tjNyOQVY62naA93sKWkHs0DZZ2bokaCyxE6lkC5sZ6lZSvQrP9n4XFwUQsZn
6AGrextDlAgkHdTb/839hljmswTwRrZLSAt3aqFrk24l3LbFtOxMhXKG8GPLM1Vi
6AiKnt3o8CFbBKs2d1ugM07eW/gf1/oSC51VKBl4tumqKRCjynj4eLbPE2JfDp2p
VlDF+7DJqewbAj67lny4o7IAyErX0mr6NlF4BpzyBlk1bsf2IZSw/yXfU5yTrsF5
e/nseJlcMulo6z75aCmutyUVLxvsTT2Txboa81RGlzjqwufsQoMNvfpzqe5EbGd/
Kkqi2/pPWkSD5GyzHeNgcyuiy4mde9Kz9upNpoIoxcmm8ExWg3Ssidoa2OHPmj1z
3gMMjfvsdpNPsrPnpK7/RZZ0kmkBYyuETtESPGCXd76g8tHMM8adVi4Y2MXh/lxE
j9J8os+D5qihBQrYjSUiRAnMNBRbaWjGTUt0QcPLMLb0P775MR/4H5yQNzjG5zz1
54VnsfVPcbR7KcTDE53M7cYqdV5J1hAib2zQ00XznQBrrxgDZ7sgX7JyxGLxONat
za9FBiFF8bd6sELn/BAmbolwMGQ5VJ+vgSbnBeBkrk7OVBbYd4+utjA1WksyLQvH
NHEzaS3pQYLioMSiZWSP
=QDMK
-----END PGP SIGNATURE-----

--Signature=_Thu__24_May_2012_09_13_06_+1000_ndfER3QhT=Zd29XE--
