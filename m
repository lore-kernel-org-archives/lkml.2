Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0LVVhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 16:37:00 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:55907 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab0LVVg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 16:36:59 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Ingo Molnar <mingo@elte.hu>
Cc: mat <castet.matthieu@free.fr>, Kees Cook <kees.cook@canonical.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        James Morris <jmorris@namei.org>,
        Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 3/3 V13] RO/NX protection for loadable kernel
In-Reply-To: Your message of "Wed, 22 Dec 2010 13:40:19 +0100."
             <20101222124019.GG10809@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <4CE2F914.9070106@free.fr> <24422.1290656467@localhost> <20101126182355.62615dff@mat-laptop> <20101208221951.GO5750@outflux.net> <20101211001857.4c5e0794@mat-laptop>
            <20101222124019.GG10809@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1293053719_7139P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Dec 2010 16:35:19 -0500
Message-ID: <34428.1293053719@localhost>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020208.4D126F1B.0087,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1293053719_7139P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Dec 2010 13:40:19 +0100, Ingo Molnar said:
>=20
> * mat <castet.matthieu=40free.fr> wrote:
>=20
> > Le Wed, 8 Dec 2010 14:19:51 -0800,
> > Kees Cook <kees.cook=40canonical.com> a =E9crit :
> >=20
> > > On Fri, Nov 26, 2010 at 06:23:55PM +0100, mat wrote:
> > > > could you try the attached patch ?
> > > >=20
> > > > on module load, we sort the __jump_table section. So we should ma=
ke
> > > > it writable.
> > > >=20
> > > >=20
> > > > Matthieu
> > >=20
> > > > diff --git a/arch/x86/include/asm/jump_label.h
> > > > b/arch/x86/include/asm/jump_label.h index f52d42e..574dbc2 100644=

> > > > --- a/arch/x86/include/asm/jump_label.h
> > > > +++ b/arch/x86/include/asm/jump_label.h
> > > > =40=40 -14,7 +14,7 =40=40
> > > >  	do
> > > > =7B							=5C asm
> > > > goto(=221:=22					=5C
> > > > JUMP_LABEL_INITIAL_NOP			=5C
> > > > -			=22.pushsection __jump_table,  =5C=22a=5C=22 =5Cn=5Ct=22=5C
> > > > +			=22.pushsection __jump_table,  =5C=22aw=5C=22 =5Cn=5Ct=22=5C
> > > >  			_ASM_PTR =221b, %l=5B=22 =23label =22=5D, %c0 =5Cn=5Ct=22 =5C=

> > > >  			=22.popsection =5Cn=5Ct=22			=5C
> > > >  			: :  =22i=22 (key) :  : label);
> > > > =5C
> > >=20
> > > Acked-by: Kees Cook <kees.cook=40canonical.com>
> > >=20
> > > Can this please get committed to tip?
> > I think it is not need anymore with  Steven Rostedt patch =5B1=5D
> >=20
> > Matthieu
> >=20
> > =5B1=5D
> > > > Here we set the text read only before we call the notifiers. The
> > > > function tracer changes the calls to mcount into nops via a notif=
ier
> > > > call so this must be done after the module notifiers.
>=20
> What's the status of this bug?
>=20
> If we still need the patch then please submit it standalone with a prop=
er subject=20
> line, with acks/signoffs added, etc.

Steve Rostedt's patch that moves the setting of the page permissions seem=
s to
make this patch no longer necessary.  I tripped over this same issue, but=
 the
version in the latest -mmotm does not need it, as it includes Steve's fix=
.

--==_Exmh_1293053719_7139P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFNEm8XcC3lWbTT17ARAot9AJ9VxWZf0IuIN33JLqBmPcNPcviizwCcCVYj
nFW2vul/vvM1LSMl8mYqU5Y=
=O2LX
-----END PGP SIGNATURE-----

--==_Exmh_1293053719_7139P--

