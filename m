Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab1FSO7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 10:59:13 -0400
Received: from home.keithp.com ([63.227.221.253]:41955 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab1FSO7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 10:59:11 -0400
From: Keith Packard <keithp@keithp.com>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Waldemar.Rymarkiewicz@tieto.com, padovan@profusion.mobi,
        marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regression caused by "Bluetooth: Map sec_level to link key requirements"
In-Reply-To: <BANLkTim4F8ZvWPMHSXpcBj9Eb2uFThcz4w@mail.gmail.com>
References: <yunboy7a2so.fsf@aiko.keithp.com> <99B09243E1A5DA4898CDD8B700111448175AA2DB2A@EXMB04.eu.tieto.com> <20110609083345.GA2894@dell.ccr.corp.intel.com> <yuny61b3pnm.fsf@aiko.keithp.com> <99B09243E1A5DA4898CDD8B700111448175AA2DE98@EXMB04.eu.tieto.com> <20110610055558.GA1832@dell> <BANLkTim4F8ZvWPMHSXpcBj9Eb2uFThcz4w@mail.gmail.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 19 Jun 2011 13:11:17 +0200
Message-ID: <yun8vsynkiy.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Jun 2011 14:58:50 +0900, Luiz Augusto von Dentz <luiz.dentz@gmai=
l.com> wrote:

> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> index 2f5ae53..b309f84 100644
> --- a/net/bluetooth/hci_conn.c
> +++ b/net/bluetooth/hci_conn.c
> @@ -673,8 +673,8 @@ auth:
>         if (test_and_set_bit(HCI_CONN_ENCRYPT_PEND, &conn->pend))
>                 return 0;
>=20
> -       hci_conn_auth(conn, sec_level, auth_type);
> -       return 0;
> +       if (!(hci_conn_auth(conn, sec_level, auth_type)))
> +               return 0;
>=20
>  encrypt:
>         if (conn->link_mode & HCI_LM_ENCRYPT)

That makes the first connection afer boot succeed, but subsequent
connections fail in the same way.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN/dlVQp8BWwlsTdMRAi8RAKDGQGMMW6LSFzz24zRSK15LGq4b1wCfZaPB
X3v7geL/ClYDgt1xh76tG+8=
=5E4L
-----END PGP SIGNATURE-----
--=-=-=--
