Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129Ab0KAPhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:37:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34425 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756748Ab0KAPhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:37:04 -0400
Date: Tue, 2 Nov 2010 02:36:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Rupjyoti Sarmah <rsarmah@apm.com>, Tom Herbert <therbert@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org
Subject: Re: All Applied micro boards are failing with current mainline
 kernel
Message-Id: <20101102023650.bc553e74.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTikQuUcAMZKqZ3Rz5HVzOs+63-Y4VYUo5-3EM30H@mail.gmail.com>
References: <6631e123845856ac20423c25e07844c8@mail.gmail.com>
	<AANLkTikWWGpAM8+_z9fnngYuYSpT3NWgM7xeGkOzZ3jg@mail.gmail.com>
	<AANLkTikQuUcAMZKqZ3Rz5HVzOs+63-Y4VYUo5-3EM30H@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Nov_2010_02_36_50_+1100_cUqEyzYYxkUuuGjl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Nov_2010_02_36_50_+1100_cUqEyzYYxkUuuGjl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Mon, 1 Nov 2010 11:05:53 -0400 Josh Boyer <jwboyer@gmail.com> wrote:
>
> A few hints would be appreciated.

Remove the call to netif_stop_queue() from emac_probe().  Apparently,
calling this before register_netdev() is now wrong (maybe always was).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Nov_2010_02_36_50_+1100_cUqEyzYYxkUuuGjl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMzt6SAAoJEDMEi1NhKgbsj2EIAI8Yt9zCze2B0cT+qNFd+nci
YME4qQPBWLAeUVCe+KQMOBEbJjgKyUXgf42h44AAHepm2IwP6U+6tVdMsi3L6S5B
Ak4w2o6J+tM4iuy48pI0nyVEFrOUO3ZwFl0hYXz94zoNaKaxU2nzPRwYnGpYBhIb
2a3v7S9QV/4rbBX4/8WA3rZ8R4l/ZE8KaR/pa1cYh4WUfONDO3xT0pPSj5BrZDT1
cx4sKgdNtr6fpkm9sclBbuCT3BOW2ilv6i2+r7yo/2DRJVrXbGDu7AGHBokvvHhx
NiyYvlSKRqPSTTFQWDfvGDVv8OyaBWgBF8kSPB18P980dUKS+G9l+RWtvz0QeK4=
=lYu3
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Nov_2010_02_36_50_+1100_cUqEyzYYxkUuuGjl--
