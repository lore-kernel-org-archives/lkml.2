Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1FXIwP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 04:52:15 -0400
Received: from mail.southpole.se ([193.12.106.18]:56227 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab1FXIwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 04:52:08 -0400
Subject: Re: [PATCH 14/19] OpenRISC: Module support
From: Jonas Bonn <jonas@southpole.se>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <201106221626.12023.arnd@arndb.de>
References: <1308483825-6023-1-git-send-email-jonas@southpole.se>
	 <1308483825-6023-15-git-send-email-jonas@southpole.se>
	 <31626.1308686616@turing-police.cc.vt.edu>
	 <201106221626.12023.arnd@arndb.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tYR13ReIKy8XYceQKK8i"
Organization: South Pole Consulting AB
Date: Fri, 24 Jun 2011 10:52:05 +0200
Message-ID: <1308905525.6699.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-Assp-Client-SSL: yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-tYR13ReIKy8XYceQKK8i
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-06-22 at 16:26 +0200, Arnd Bergmann wrote:
> I think that an easy way to do that would be to add to kernel/module.c
> code like:
>=20
> #ifndef module_alloc
> void *module_alloc(unsigned long size)
> {
> 	return vmalloc(size);
> }
> #endif
>=20

I noticed that kernel/module.c already has this:

unsigned int __weak arch_mod_section_prepend(struct module *mod,
                                             unsigned int section)


Is using a __weak attribute on the default (generic) implementations a
better approach?

> Then each architecture that needs a special version can do
> #define module_alloc(size) module_alloc(size)
> in their respective asm/module.h

With the __weak variant this wouldn't be necessary...

/Jonas

--=-tYR13ReIKy8XYceQKK8i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk4EUDMACgkQ70gcjN2673PFLQCfSF4nv2BBwE2wyyBgMXVrV+Gb
N6cAoKEEbFTKSjRyCDrvXHejJaKEcFqv
=pAlF
-----END PGP SIGNATURE-----

--=-tYR13ReIKy8XYceQKK8i--

