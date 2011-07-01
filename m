Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1GAKhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 06:37:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46894 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754990Ab1GAKhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 06:37:13 -0400
Date: Fri, 1 Jul 2011 20:37:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20110701203702.a15ecf19.sfr@canb.auug.org.au>
In-Reply-To: <4E0D9D16.7020508@redhat.com>
References: <20110701151931.4c2d78b5.sfr@canb.auug.org.au>
	<4E0D5BD4.6080403@redhat.com>
	<20110701170843.bd60e326.sfr@canb.auug.org.au>
	<4E0D9D16.7020508@redhat.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Jul_2011_20_37_02_+1000_IFetH8P6U3o9XYmD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jul_2011_20_37_02_+1000_IFetH8P6U3o9XYmD
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 01 Jul 2011 18:10:30 +0800 Cong Wang <amwang@redhat.com> wrote:
>
> =E4=BA=8E 2011=E5=B9=B407=E6=9C=8801=E6=97=A5 15:08, Stephen Rothwell =E5=
=86=99=E9=81=93:
> >
> > On Fri, 01 Jul 2011 13:32:04 +0800 Cong Wang<amwang@redhat.com>  wrote:
> >>
> >> =E4=BA=8E 2011=E5=B9=B407=E6=9C=8801=E6=97=A5 13:19, Stephen Rothwell =
=E5=86=99=E9=81=93:
> >>>
> >>> After merging the akpm tree, today's linux-next build (powerpc
> >>> ppc64_defconfig) failed like this:
> >>>
> >>> arch/powerpc/kernel/rtas.c: In function 'rtas_restart':
> >>> arch/powerpc/kernel/rtas.c:655:24: error: 'SYS_RESTART' undeclared (f=
irst use in this function)
> >>> arch/powerpc/kernel/rtas.c: In function 'rtas_power_off':
> >>> arch/powerpc/kernel/rtas.c:664:24: error: 'SYS_POWER_OFF' undeclared =
(first use in this function)
> >>> arch/powerpc/kernel/rtas.c: In function 'rtas_halt':
> >>> arch/powerpc/kernel/rtas.c:674:24: error: 'SYS_HALT' undeclared (firs=
t use in this function)
> >>>
> >>> Caused by commit ac050ff2a176 ("It is not necessary to share the same
> >>> notifier.h").
> >>
> >> I think the following patch will fix this.
> >
> > Please find all the other files that need that include as well (there is
> > at least one more).
> >
>=20
> Ok, I will do a cross-compilation.

Well, really any file that references any of those defines should be
including linux/reboot.h, now - whether a compilation gets errors or
not.  A change in CONFIG options or different platforms/architectures can
change what file get implictly included.

See Rule 1 in Documentation/SubmitChecklist.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_Jul_2011_20_37_02_+1000_IFetH8P6U3o9XYmD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJODaNOAAoJEDMEi1NhKgbsdNcH/i6e9j7urRyKrZScgB0ZMqw0
YuaxDZySQcSY6QjuhnPGsVwtbq5siB3rBVrIGYWBCmO/7W2fSPR+ivQeZNvnK4Cj
imgVzzyQ4y/TRTVBULvOGJIvlvvOxbAuLeSZjn9jIgZMCR7SsxM3CuMTITR9CvZP
pWNgvsWQPgieVNU5F1/g4PpTVbD8za1ViNsDZIPrHM5HDF89zVxK3zK4ppoHFrry
nms22zQZtVf7VSIUQGhOjOyAgHDGDIi6zeTDEAEUf6JXqlgZxhgF+dK4A8XKTVPx
eL7yY1eWsj+W17+zn0Jk4deg/eYJmL52aISSqFBkJHQhXIrej/FZ1W/S5ooAeME=
=pq1M
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jul_2011_20_37_02_+1000_IFetH8P6U3o9XYmD--
