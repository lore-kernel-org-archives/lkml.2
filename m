Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab2CGD4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:56:18 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:57022 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757050Ab2CGD4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:56:14 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/3] Kbuild: centralize MKIMAGE and cmd_uimage definitions
Date: Tue, 6 Mar 2012 22:56:07 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        nico@fluxnic.net, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "Hans-Christian Egtvedt" <egtvedt@samfundet.no>,
        Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1729674.9qEmhknEMN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201203062256.16105.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1729674.9qEmhknEMN
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 06 March 2012 19:30:36 Stephen Warren wrote:
> --- a/arch/blackfin/boot/Makefile
> +++ b/arch/blackfin/boot/Makefile
>=20
> +ifeq ($(CONFIG_RAMKERNEL),y)
> +UIMAGE_LOADADDR =3D $(CONFIG_BOOT_LOAD)
> +else # CONFIG_ROMKERNEL must be set
> +UIMAGE_LOADADDR =3D $(CONFIG_BOOT_LOAD)
> +endif

this part is wrong :).  the else branch should be $(CONFIG_ROM_BASE).

> +UIMAGE_ENTRYADDR =3D $(shell $(NM) vmlinux | awk '$$NF =3D=3D "__start" =
{print
> $$1}')

i feel like if we tried harder, we could automate the -e arg for all arches=
=2E =20
i understand if you don't want to undertake that though.
=2Dmike

--nextPart1729674.9qEmhknEMN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPVtxeAAoJEEFjO5/oN/WBSgMP/0NYD9By3hPOuA64150Lzqmz
hrC87rAQ7WlAXE1SkOrCd8fDvM6Nej/YMVjAN0KuPM+vnRi00hQjMhvt89OPSzdL
YSsO+DPovsxIBuHMtbMiu6USflqKhRcWQyY5dMtFuBgVH40WYsF6GgseF3TQjr2a
++VE5TrSN/OJUjJNc4fBcrmEqOjTUqiujAordEx06Fcs4VnYgGGqVpw3wFSq8VbW
EN316/HfWmhSKi+sNgChAS+g/0xGknhLDo387u8XNajFGKlZmm1wriSRRq75zXep
Ck+b2K8FUZ3rwABBg2+IHWW89yketoTNY3KujV5GQ6gvFit5HiYzzWFkcRLz26t/
gpLkU5FoO4SGRvQlXk191pgonzjdq4HEYp6A9BUdvVoCeAJ1lB3v8wufmFJwOGZe
M78c0DtoeSZLWzcLAXsxKogFQIrueHHXh2qTqUdO25XfB1+V/EHt/fomRvpR6tje
tnxaGRA/vSJHgR5b1BTwhdbttH6gdisJd3EKzyt+40+51JVlCZQxUVcTvnx9/8aL
ehCxBbgEAeJ0N9nb78ALpdOo/21mxDL9SABcOLrROMmYJ5cG4Pxdvqleo88YY7EA
DgOl+klbKDSL4MCxs2+bK0AnDQzdKKGRSqqWO4fZLyLE7sJ68g3V8SwIyouLZF1v
M6s+4vX5Av0q9kZ+ZCVH
=Nc9J
-----END PGP SIGNATURE-----

--nextPart1729674.9qEmhknEMN--
