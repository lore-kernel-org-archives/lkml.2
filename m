Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932165Ab1ELXCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:02:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56171 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756900Ab1ELXCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:02:04 -0400
Date: Fri, 13 May 2011 09:01:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@lists.open80211s.org
Subject: Re: linux-next: build failure after merge of the final tree
 (wireless tree related)
Message-Id: <20110513090152.3dcef583.sfr@canb.auug.org.au>
In-Reply-To: <BANLkTiknar_vMtmr659yNCVFz-V0W9XvOQ@mail.gmail.com>
References: <20110512141019.72ccb7a7.sfr@canb.auug.org.au>
	<BANLkTik+=yh3eq6Snp9SfC0xn--Deccefw@mail.gmail.com>
	<20110512145633.69302dd4.sfr@canb.auug.org.au>
	<BANLkTiknar_vMtmr659yNCVFz-V0W9XvOQ@mail.gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__13_May_2011_09_01_52_+1000_6H28BxdFX319iH2o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_May_2011_09_01_52_+1000_6H28BxdFX319iH2o
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Javier,

On Thu, 12 May 2011 10:22:20 -0700 Javier Cardona <javier@cozybit.com> wrot=
e:
>
> On Wed, May 11, 2011 at 9:56 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> > On Wed, 11 May 2011 21:37:16 -0700 Javier Cardona <javier@cozybit.com> =
wrote:
> >>
> >> On Wed, May 11, 2011 at 9:10 PM, Stephen Rothwell <sfr@canb.auug.org.a=
u> wrote:
> >> >
> >> > After merging the final tree, today's linux-next build (i386 defconf=
ig)
> >> > failed like this:
> >> >
> >> > net/mac80211/cfg.c: In function 'sta_apply_parameters':
> >> > net/mac80211/cfg.c:746: error: 'struct sta_info' has no member named=
 'plink_state'
> >>
> >> Sorry, I just saw this. =C2=A0My apologies. =C2=A0The fixup is valid b=
ut I'm
> >> trying to understand why it is needed.
> >> ieee80211_vif_is_mesh(&sdata->vif) compiles to 'false' when
> >> CONFIG_MAC80211_MESH is not defined... wouldn't the compiler remove
> >> that dead code? (Obviously it did not...)
> >
> > The compiler will elide that code but only after compiling it, so the
> > code still has to be correct.
>=20
> Thanks for the explanation.
>=20
> >> Anyway, given that this is necessary, it's probably cleaner to extend
> >> the #ifdef block to the entire body of the outer if as follows:
> >
> > I think you have the #ifdef one line too low.
>=20
> My intent was to have the #endif one line above, but either way works.
>  That's the problem of preparing patches on pajamas.
> How can I help at this point?  Would resubmitting the patch help or
> just add noise?

Unless John has already fixed this, you need to send him a patch.  This
should be a fix patch as John doesn't normally rebase his tree (I think).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__13_May_2011_09_01_52_+1000_6H28BxdFX319iH2o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNzGbgAAoJEDMEi1NhKgbs0fsH/iy/R77vTVEUMCquc012c/9r
TAril8VgurbBotdOMcM3O4EfW6OT/VTVpCDzqGeBffZmFCgoFvUF2XNzEdCMYCqz
jCdHstDsZz1bxR/o41cYm0AGZPVUyHwInJHVZOL2TNqnxPwVI25c0EyBKvK92O8X
+QqPm2Gq0d1+7+qqLUmylJ0HlPnVE1zgfugAOOM3qmfqS9w0CWsUqzxdAYSLXZY+
yX9Qn4VcRhklzowIV2kriyTSM09Ywe0UUxmIdEFyGqvmQFbCm25Cuz4HDnNZobuf
FxrPH9KPX4un36FzMsCutmlPShou8t08+WELhIhwdoKWcz4b1wo+mye/DFFUsiQ=
=suIr
-----END PGP SIGNATURE-----

--Signature=_Fri__13_May_2011_09_01_52_+1000_6H28BxdFX319iH2o--
