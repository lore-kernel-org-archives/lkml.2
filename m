Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1EBUEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 16:04:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45050 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233Ab1EBUEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 16:04:48 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: James Bottomley <James.Bottomley@suse.de>,
        David Rientjes <rientjes@google.com>,
        Michael Schmitz <schmitzmic@googlemail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Pekka Enberg <penberg@kernel.org>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
In-Reply-To: <20110429185656.051229285@clark.kroah.org>
References: <20110429185656.051229285@clark.kroah.org>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-0/EE9Z2FXrrGHfftPN0U"
Date: Mon, 02 May 2011 21:04:37 +0100
Message-ID: <1304366677.2833.170.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [36/55] [PARISC] slub: fix panic with
 DISCONTIGMEM
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.i.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0/EE9Z2FXrrGHfftPN0U
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-04-29 at 11:55 -0700, Greg KH wrote:
> 2.6.38-stable review patch.  If anyone has any objections, please let us =
know.
>=20
> ------------------
>=20
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
>=20
> commit 4a5fa3590f09999f6db41bc386bce40848fa9f63 upstream.
>=20
> Slub makes assumptions about page_to_nid() which are violated by
> DISCONTIGMEM and !NUMA.  This violation results in a panic because
> page_to_nid() can be non-zero for pages in the discontiguous ranges and
> this leads to a null return by get_node().  The assertion by the
> maintainer is that DISCONTIGMEM should only be allowed when NUMA is also
> defined.  However, at least six architectures: alpha, ia64, m32r, m68k,
> mips, parisc violate this.  The panic is a regression against slab, so
> just mark slub broken in the problem configuration to prevent users
> reporting these panics.

This stable series also included the patches:

commit 6a682f634ba9615d3498d1e20a23e9d4fcb39f16
Author: David Rientjes <rientjes@google.com>
Date:   Wed Apr 20 19:27:13 2011 -0700

    set memory ranges in N_NORMAL_MEMORY when onlined
   =20
    commit d9b41e0b54fd7e164daf1e9c539c1070398aa02e upstream.

commit 8858587af25efc06d5cce42676786b3d7a9160f2
Author: Michael Schmitz <schmitzmic@googlemail.com>
Date:   Tue Apr 26 14:51:53 2011 +1200

    m68k/mm: Set all online nodes in N_NORMAL_MEMORY
   =20
    commit 4aac0b4815ba592052758f4b468f253d383dc9d6 upstream.

which look like they're supposed to make slub work on these two
architectures (parisc and m68k).  Do they?  If not, do they fix a
different problem?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-0/EE9Z2FXrrGHfftPN0U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATb8OTue/yOyVhhEJAQrFuBAAwcY3axnTVtzPF0zruTpTrkkLZuMR/bDy
HScIB2KCsQ4UdzC05RrMV8qHFK1pToCx06yhFMDjOmD8Pn2Q30cbuLJp0SnG2B9c
o3uuE7mirb5hSjXQBDIueTUY+QikkzboVXuI3YZ8LdttqklsTBXOjUAehfb/XmLV
lEACgWuNPow3JmCbhxOUPowzCYJ41A0lFrSe7KE6rwNPNPFwmrXBIuomBce5kCts
UFUtJNNt5UbLdzQNKywz03PVgN8nMo2fAsrNN6yCLaSVTytLOlGYetZ3wL0qqG9z
Nz5O2+4axeRvBMR+AMqeJ6A9mEjGYEpbwd3WxC1vSsq/7YojuRWx9KnsJc5JQV3b
3qOUFE4HZcLJTyIB5CEfW0vmdREcILBYuq8G7cafLKWD8g5IG0i09tSAzURmfcmz
ioTJ32W1hyHEAInX+s4iQa+zU1vrYOpVv23VJjlzpTXCixq16Akt0ORaw6RG4wvB
fMaHXN4KgVwmqltbDWcJqpHhIVDg+2UQ/bQacizT2Zx8/HTXxygOSDGTOj6OvwtW
pMf1fPSrKG2kbScKamSN1wkMaebLIJZDmv1x/hbx6mmJEuS0OEtqbB+NZR8jTnsu
4aYZX9C2T1EvSpAEW/cpqTUd8IhTS/L7kaoqx+tWIkgLaxS9R1h+ZGuflRhsXTO8
ScfUSaYh5Zg=
=F7Yj
-----END PGP SIGNATURE-----

--=-0/EE9Z2FXrrGHfftPN0U--
