Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1JXOUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:20:19 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:42845 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab1JXOUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:20:17 -0400
Date: Tue, 25 Oct 2011 01:20:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Security subsystem updates for 3.2
Message-Id: <20111025012003.43d3847ec1284f68e79f9948@canb.auug.org.au>
In-Reply-To: <CA+55aFxbh9eHYe8cPH2TaTW1t5C6C+z-Bcy+kGhR0Gt=MgMvcQ@mail.gmail.com>
References: <alpine.LRH.2.00.1110242108540.19271@tundra.namei.org>
	<CA+55aFxbh9eHYe8cPH2TaTW1t5C6C+z-Bcy+kGhR0Gt=MgMvcQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Oct_2011_01_20_03_+1100_v=Zt=xs_ArtZLhIW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Oct_2011_01_20_03_+1100_v=Zt=xs_ArtZLhIW
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 24 Oct 2011 15:52:56 +0200 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> >
> > Jarkko Sakkinen (6):
> > =C2=A0 =C2=A0 =C2=A0Smack: domain transition protections (v3)
>=20
> So this is reverted in linux-next. I don't know why, but it's a bad
> sign. Doesn't compile?

Yeah, this:

security/smack/smack_lsm.c: In function 'smack_bprm_set_creds':
security/smack/smack_lsm.c:473:21: error: 'PER_CLEAR_ON_SETID' undeclared (=
first use in this function)

Caused by commit 84088ba23929 ("Smack: domain transition protections
(v3)"). PER_CLEAR_ON_SETID is defined in linux/personality.h which is not
directly included by the above file.

It appears to have been fixed in the current version of the tree by this:

	Smack: compilation fix
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Oct_2011_01_20_03_+1100_v=Zt=xs_ArtZLhIW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOpXQTAAoJEECxmPOUX5FESuwQAItTOeRhjf/e0ofpaac1dBNO
BjpbH0Au2cYccX+ygXbO9cRUSWawBbStQXVrF13CyEQHTmPlQjlDt+xHcuaqHPZb
IdGAn7dJOTxtad4Xv0ZYWgee78gloRaYfiDrbIe6DHOnOHGErtGAMIj5cB46M9Fw
oJq010qWmVGCCyd0uVF12w2/TFkx3v7wGe5O9vsS/dCsGYYPdA7B9/irynRU0N6R
9Pw2rlIADxf+Rxm0BI82LxyKElEdEJaBXVL9wT/cNplYjKzlsqrnGoc6PHNKCMnk
jfASnANRnfRdMebc8PtDSSLqtN3oGXrV2FxevR0Eo4+NzUfxA1oJ3HqSw6LX9Bfq
6mKugIoVdFJLTHHWSQddLTnGBgbSxGf1x92keU8r0p7J2eiyAXpRe3zeTcj+7TSK
4MGSz4RP5fzskg1MVRsxTqckc42wLJiHG2ldXN/aIlRpARugNN8NOViGhXko+ZB+
YAIqcEuflIzk06Wv15CoqdpAdVRtSTtasPFEdYimO6k9qvW7cL+kSkakUKSzrxPJ
A2i8n0WoIyJ0Nnl6F/Y9bZ+a9jx8OpgojkCv8+3xyAcTIXyaUvmlvyImSVcb77hD
chK5HcUv72RZQjgIu6ZQFD5N60yuqGE7wfz3Si3U/NW5KYfVPMaar2+0t4xYPzb6
hIKk4sHz3MDPfKIj6Yo2
=T6iA
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Oct_2011_01_20_03_+1100_v=Zt=xs_ArtZLhIW--
