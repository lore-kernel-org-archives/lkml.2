Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988Ab0G1ESM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 00:18:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45015 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0G1ESJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 00:18:09 -0400
Date: Wed, 28 Jul 2010 14:18:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the xen tree
Message-Id: <20100728141801.fbdccf2a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Jul_2010_14_18_01_+1000_w3mdv00/fZYv7xp0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Jul_2010_14_18_01_+1000_w3mdv00/fZYv7xp0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the xen tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

arch/x86/xen/enlighten.c:71: error: __pcpu_scope_xen_vcpu causes a section =
type conflict
arch/x86/xen/enlighten.c:72: error: __pcpu_scope_xen_vcpu_info causes a sec=
tion type conflict
arch/x86/xen/enlighten.c:71: error: __pcpu_unique_xen_vcpu causes a section=
 type conflict
arch/x86/xen/enlighten.c:72: error: __pcpu_unique_xen_vcpu_info causes a se=
ction type conflict
arch/x86/xen/enlighten.c:565: error: __pcpu_unique_idt_desc causes a sectio=
n type conflict
arch/x86/xen/enlighten.c:767: error: __pcpu_unique_xen_cr0_value causes a s=
ection type conflict

Presumably because commit "support multiple .discard.* sections to avoid
section type conflicts" was dropped from the xen tree today.

I have used the xen tree from next-20100727 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Jul_2010_14_18_01_+1000_w3mdv00/fZYv7xp0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMT695AAoJEDMEi1NhKgbsSGQH/1yNRMKXMOVUDj4n33ZQIGCZ
TJS7+2htBw1DBE8xtE0ZuLTFnAG8bY8VwbqZ/xKT1VAXiCE8a4kE9hb8Zj06gC7F
icIIc89YiEn2Fr7SDLAPRWfEm/mwGBiA7tle6ydZjdx4MF6FP5AIqaxJQL6pzr7G
6Y0/hrQfGo6HJDZXDN6l1R6J1IRjPMcQq2yzoqJBht8/Gs+lDbcuzqYdhk2Qn7mc
5lWhVGQQgHFioPFk9iFMxXgdo02y/xrAedsearQ6sovpRL9TsGtmzN/b73I8Q3Wb
c+nFeQirZl8sX59RbcniT5ZKt+eRHHnNYjPW9eVr/3p7ub7aWuHYRlyiOGFYTHQ=
=mIay
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Jul_2010_14_18_01_+1000_w3mdv00/fZYv7xp0--
