Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2CKLCE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 07:02:04 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab2CKLCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 07:02:00 -0400
Message-ID: <4F5C861F.2000507@nod.at>
Date: Sun, 11 Mar 2012 12:01:51 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
References: <4F5BD51B.7030907@nod.at> <4F5BDB09.3020407@suse.cz> <4F5BE1E6.9000201@nod.at>
In-Reply-To: <4F5BE1E6.9000201@nod.at>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig11959E9072910D4D260E0A8F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig11959E9072910D4D260E0A8F
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 11.03.2012 00:21, schrieb Richard Weinberger:
> Am 10.03.2012 23:51, schrieb Jiri Slaby:
>> On 03/10/2012 11:26 PM, Richard Weinberger wrote:
>>> Hi!
>>
>>> While moving UML's console driver to tty_port some strange things
>>> happened. So, I have a few questions. :-)
>>
>>> The original driver did not implement tty_operations->hangup(). If
>>> I implement it and call tty_port_hangup(), as Alan suggested, the
>>> login fails on all TTYs except tty0. It fails because the opened
>>> TTY returns EIO upon read()/write() after /bin/login called
>>> vhangup().
>>
>>> The call chain is: vhangup() -> tty_vhangup_self() -> tty_vhangup()
>>> -> __tty_hangup()
>>
>>> Within __tty_hangup() something happens that I don't fully
>>> understand:
>>
>>> if (cons_filp) { if (tty->ops->close) for (n =3D 0; n < closecount;
>>> n++) tty->ops->close(tty, cons_filp); } else if (tty->ops->hangup)=20
>>> (tty->ops->hangup)(tty);
>>
>>> Login on tty0 works because cons_filp is not NULL and
>>> tty->ops->close() is called. On the other hand login fails on every
>>> other TTY because cons_filp remains NULL and the TTY hangs up.
>>
>>> Is there something missing in my hangup function?
>>
>>> If I omit tty_operations->hangup() and leave it, like the old
>>> driver, NULL non-tty0 TTYs cannot be opened. (getty terminates
>>> immediately because it cannot open any TTY.) open() retuns -EIO
>>> because the TTY_CLOSING is set in tty->flags.
>>
>>> How can this be?
>>
>> Hmm, it looks like some process is sitting on a TTY which was hung.
>> And the system offers this hung TTY to others on further opens. Could
>> you check that there is no process with open TTY after the vhangup?
>>
>=20
> "lsof | grep tty" does not show anything else than tty0. :-\
>=20

BTW: When I start the kernel with /bin/sh as init, opening and writing to=
 any TTY works fine.
It looks like Fedora 16's userspace does something that makes the TTYs un=
happy.

Thanks,
//richard


--------------enig11959E9072910D4D260E0A8F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPXIYjAAoJEN9758yqZn9eA0AIAIUDJDFS9g5btNZI0Si0vrq3
830vnVrsAhn1aty7DCsEWUX5xz7LxMH79lST/2mqDugVHODCpFpM+gJWul1AaGfp
a4cmPehEfbWpSAdq7KMb8udRwYoMOp8L9aAieh6XA0yi7DYXLZO6vFQreg7Quf87
UTerSH08fIYudiO3gstCPGCng506ozcaODeUVQLBXq+7j/49cNqGi1Hobsd2mCHC
X49PafYj2jj5cukwPJWai5HMZvpxs5P1rOcoirfy9FnH9Dy3M+P95066QsK4k9Mb
6FWlg9qnquBVoLe+W4u/9n5bOIA34O5p8ZQqkz3KwmVb3yD56nOGQUVZqyUtgkw=
=aZie
-----END PGP SIGNATURE-----

--------------enig11959E9072910D4D260E0A8F--
