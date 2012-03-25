Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756308Ab2CYPOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 11:14:43 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271Ab2CYPOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 11:14:41 -0400
Message-ID: <4F6F365D.5060703@nod.at>
Date: Sun, 25 Mar 2012 17:14:37 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
References: <4F5BD51B.7030907@nod.at> <4F5BDB09.3020407@suse.cz> <4F5BE1E6.9000201@nod.at> <4F5C861F.2000507@nod.at> <4F5DCF39.8080308@nod.at> <20120312105312.665d2362@pyramind.ukuu.org.uk> <4F5DDAD4.4060504@nod.at> <20120312114832.784bb6fe@pyramind.ukuu.org.uk> <20120324232001.GK6589@ZenIV.linux.org.uk> <20120325155143.7ca7cb13@ultron>
In-Reply-To: <20120325155143.7ca7cb13@ultron>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB7F49D0399D0A6549AB2BD4A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB7F49D0399D0A6549AB2BD4A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 25.03.2012 16:51, schrieb Alan Cox:
> On Sat, 24 Mar 2012 23:20:01 +0000
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
>=20
>> On Mon, Mar 12, 2012 at 11:48:32AM +0000, Alan Cox wrote:
>>
>>>>> It will be. In order to fix the tty locking mess we need to shove a=
 lot
>>>>> of stuff whose lifetime is the lifetime of the physical port somewh=
ere
>>>>> else - the tty_port is that structure.
>>>>>
>>>>
>>>> "It will be" in terms of "not now"? ;-)
>>>
>>> As in, it's the very next step on.
>>
>> FWIW, uml console in default config is basically "start xterm for each=
 VC".
>> What do you suggest to do on vhangup() on one of those?
>=20
> What posix says must happen. Which is that the running processes get a
> hangup. So a vhangup() would ensure there were no old apps on the UML
> guess talking to the xterm (eg stealing login credentials, or abusing
> TIOCSTI etc).

Looks like Debian's /bin/login is violating POSIX. AFACT it does not
call vhangup() at all.

> The fact it's an xterm isn't really relevant. That's just the physical
> interface and vhangup is about breaking the logical link. The xterm wou=
ld
> continue, no reason for it to do otherwise I can see ?
>=20

As I wrote in my very first mail, if I implement tty_operations->hangup()=

a vhangup() closes the current TTY and the shiny new login shell dies bec=
ause
read/write() returns EIO.

So, the question is whether tty_port is not suitable for consoles or my d=
river
(see first mail in thread) is broken.

Thanks,
//richard



--------------enigB7F49D0399D0A6549AB2BD4A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPbzZdAAoJEN9758yqZn9exrMH/jzpeAwZnm335rzlt4fdSamH
w1mPzYh2BSDvdMZV0XN4Milcg+MsXn2fUpixtwNImyIXyn4WbKd6KgcxDflTK6dT
uUVqDiMNrBCuaAuAM7kRlWacVoYSt2VfEfcwFsUolDQ2o+IjOOARYBDD62easgmd
9cM+qgMbBzDR5+FDzmmZ5tXHTaVlZpw0rW5yTxKfXla0M/UXcL+b/ahJv8o82Y0F
8WITMUHS+r4XGlnI+1jg9OTO5QKprbbiwp3eJkhLUZLlQdyojE9yd6vzMI9MV2pO
Dqw8V2kS7lRrMAYbpdUUiwYMMp+mOlx7F0EMRFwywRKXQ98NORW7asohh+oe6UE=
=g68D
-----END PGP SIGNATURE-----

--------------enigB7F49D0399D0A6549AB2BD4A--
