Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab0KYEJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 23:09:41 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:36141 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0KYEJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 23:09:40 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jesper Juhl <jj@chaosbits.net>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] x86, dumpstack: Fix unused variable warning.
In-Reply-To: Your message of "Wed, 24 Nov 2010 10:57:10 +0100."
             <alpine.LNX.2.00.1011241051370.23994@swampdragon.chaosbits.net>
From: Valdis.Kletnieks@vt.edu
References: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
            <alpine.LNX.2.00.1011241051370.23994@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1290658067_4815P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Nov 2010 23:07:47 -0500
Message-ID: <25439.1290658067@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4CEDE114.003F,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1290658067_4815P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Nov 2010 10:57:10 +0100, Jesper Juhl said:

> On Wed, 24 Nov 2010, Rakib Mullick wrote:

> > diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.=
c
> > index 8474c99..fc5a253 100644
> > --- a/arch/x86/kernel/dumpstack.c
> > +++ b/arch/x86/kernel/dumpstack.c
> > =40=40 -197,10 +197,10 =40=40 void show_stack(struct task_struct *tas=
k,
> > unsigned long *sp)
> >   */
> >  void dump_stack(void)
> >  =7B
> > -	unsigned long bp =3D 0;
> >  	unsigned long stack;
> >=20
> >  =23ifdef CONFIG_FRAME_POINTER
> > +	unsigned long bp =3D 0;
> >  	if (=21bp)
> >  		get_bp(bp);
> >  =23endif
>=20
> So, now the bp variable does not exist at all if CONFIG_FRAME_POINTER i=
s=20
> not defined.
> That's going to make this line :
>=20
>           show_trace(NULL, NULL, &stack, bp);
>=20
> found further down in the dump_stack() function, quite unhappy.

OK, I'll bite.  Why does the original say 'unsigned long bp =3D 0;' and t=
hen turns
around and has an 'if (=21bp)' check?  Why is the conditional there?

--==_Exmh_1290658067_4815P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFM7eETcC3lWbTT17ARAkdeAJ4+pa3roMit5tfrPIXg0cPIFlkP/gCgwZKT
D1UZoxmv37zcbEInGi+tLy8=
=NbM3
-----END PGP SIGNATURE-----

--==_Exmh_1290658067_4815P--

