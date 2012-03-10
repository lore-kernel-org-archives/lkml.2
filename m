Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2CJXVP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 18:21:15 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707Ab2CJXVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 18:21:14 -0500
Message-ID: <4F5BE1E6.9000201@nod.at>
Date: Sun, 11 Mar 2012 00:21:10 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
References: <4F5BD51B.7030907@nod.at> <4F5BDB09.3020407@suse.cz>
In-Reply-To: <4F5BDB09.3020407@suse.cz>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1932245AF2447E3855D7E6F7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1932245AF2447E3855D7E6F7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 10.03.2012 23:51, schrieb Jiri Slaby:
> On 03/10/2012 11:26 PM, Richard Weinberger wrote:
>> Hi!
>=20
>> While moving UML's console driver to tty_port some strange things
>> happened. So, I have a few questions. :-)
>=20
>> The original driver did not implement tty_operations->hangup(). If
>> I implement it and call tty_port_hangup(), as Alan suggested, the
>> login fails on all TTYs except tty0. It fails because the opened
>> TTY returns EIO upon read()/write() after /bin/login called
>> vhangup().
>=20
>> The call chain is: vhangup() -> tty_vhangup_self() -> tty_vhangup()
>> -> __tty_hangup()
>=20
>> Within __tty_hangup() something happens that I don't fully
>> understand:
>=20
>> if (cons_filp) { if (tty->ops->close) for (n =3D 0; n < closecount;
>> n++) tty->ops->close(tty, cons_filp); } else if (tty->ops->hangup)=20
>> (tty->ops->hangup)(tty);
>=20
>> Login on tty0 works because cons_filp is not NULL and
>> tty->ops->close() is called. On the other hand login fails on every
>> other TTY because cons_filp remains NULL and the TTY hangs up.
>=20
>> Is there something missing in my hangup function?
>=20
>> If I omit tty_operations->hangup() and leave it, like the old
>> driver, NULL non-tty0 TTYs cannot be opened. (getty terminates
>> immediately because it cannot open any TTY.) open() retuns -EIO
>> because the TTY_CLOSING is set in tty->flags.
>=20
>> How can this be?
>=20
> Hmm, it looks like some process is sitting on a TTY which was hung.
> And the system offers this hung TTY to others on further opens. Could
> you check that there is no process with open TTY after the vhangup?
>=20

"lsof | grep tty" does not show anything else than tty0. :-\

Thanks,
//richard


--------------enig1932245AF2447E3855D7E6F7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPW+HmAAoJEN9758yqZn9eg6EH/1803EbG1VOncIy5pvya4EkB
bGf16JSOr2OHIC/zT8Qp5jHlKKmdqhZlKn01A1rHxn525EOkeaQsVRiwg77IVWg+
DGbqNunBID9BojIA8T8Sq+ac6epjvnqt0zXC0l/YZvNy9r6DLxRL45V0yB4ZLyqz
g1HM28gWdCCqTDrdRnoxJC/9J9xNwPdqcsb3c0IBos9rusbcIBu9YKZ1vdn/Ucst
lLMEZeK8aJbQ+giSqwRJzVLGnu3BOiZiD9isOiwifw9Ykk+eas94+MBZgI1tj3X3
gbA+yh7U/jM+3pcnaGww0Pw4t2+HYUJPRRoQ9yfczd7KAYn0I83/HGkfUlpp4Z8=
=uAsR
-----END PGP SIGNATURE-----

--------------enig1932245AF2447E3855D7E6F7--
