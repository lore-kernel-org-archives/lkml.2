Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab1LNOyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 09:54:12 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:39919 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab1LNOyK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 09:54:10 -0500
Date: Wed, 14 Dec 2011 09:54:07 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20111214145407.GA4075@mgebm.net>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <4EDF7B0D.4060001@redhat.com>
 <20111214121622.GB18317@amt.cnet>
 <4EE8B53C.6070502@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <4EE8B53C.6070502@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011, Avi Kivity wrote:

> On 12/14/2011 02:16 PM, Marcelo Tosatti wrote:
> > > Having this controlled from userspace means it doesn't work for SIGST=
OP
> > > or for long scheduling delays.  What about doing this automatically
> > > based on preempt notifiers?
> >
> > Long scheduling delays should be considered hangups from the guest
> > perspective.
>=20
> Why?  To the guest it looks like slow hardware, but it will interpret it
> as a softlockup.
>=20
> > About SIGSTOP, that is a corner case. Unsure if its even properly suppo=
rted=20
> > by QEMU.
>=20
> It works from my experience.
>=20
> --=20
> error compiling committee.c: too many arguments to function
>=20

And if the soft lockup warning is a concern here, we can have a SIGCONT han=
dler
set the flag the same way qemu stop/cont does.

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO6LiPAAoJEKhG9nGc1bpJnqMP/3RQ6LT1oRyUGhYNom1tcocN
HxCTwIE2cMcbNliVCnMIotG8ZWBLrMBwmuq+4bdlSn4EG0e9mg3FxWgqJndysux7
2Xy+NS3+/Q/TgZ2gwtduUk0MJxIci4MmBIqGdUjwy7BaiwEjJ0pLLy0q3Zlizjcj
WuSQwJmtXQ9SwPvXDv/llGPhfc/aDjaaeEYmy81t6lSZnizkF3210Vn0u5ALDFbx
VTXxsiis/KwgOpM3A81T9VO4XeO4LrZ0OV/vDLyXIkXCN3O+p512DeWq4nTl5KGU
q0rhXxnH+NeczSqNI6J/sRTwvw4odnAN1fYyjjie3ZGPNx8/fLE4oGm40UStaRbN
w+TuYjse+ChNuT7gZErb6eUrBotMxpxUqUwCxGDfY2o1uRdQcYoivOnrtux9Wsls
j9pzBD0a5DXBofuKgjwLLvVLkEmWd/K6WRdjtvDdbCl4KJKGl7wZn8Zn6qoX/Kgr
PR+VK3N4z11Coh1s0Oe1YrMhvHzwiarNhluZzmsI2bgZxyZXzMNBDsvpJmr1XDpe
hOodUd24ONC9Poxj8LndAO63KfXHSrgs1STF+LjBOb4f5Ao1JqChpUBnqXwsWJz+
M6QVDhSAGjt9GgmATwucyiWIhVC4SjI49UkG4AMEeFnbR2eMIJULfC9B9NlHnB1c
9yees0YjkRmfxZFKeuJX
=OZOd
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
