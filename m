Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133Ab2FGIpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:45:33 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab2FGIp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:45:29 -0400
Message-ID: <4FD06A22.6040002@nod.at>
Date: Thu, 07 Jun 2012 10:45:22 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: user-mode-linux-devel@lists.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jslaby@suse.cz,
        alan@linux.intel.com
Subject: Re: [uml-devel] um: TTY fixes (?)
References: <1338841657-30358-1-git-send-email-richard@nod.at> <4FCF6748.6020005@panasas.com> <4FD059AC.8050808@panasas.com>
In-Reply-To: <4FD059AC.8050808@panasas.com>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig85F82DD115F8CB8977DFA1CF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig85F82DD115F8CB8977DFA1CF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 07.06.2012 09:35, schrieb Boaz Harrosh:
>=20
> OK I've run with these for a few days and they are doing
> the Job perfectly. Not a single problem.

Good to know.

> You may add tested-by: Boaz Harrosh <bharrosh@panasas.com>
> on all patches if you'd like.
>=20
> Please push them ASAP to Linus. They fix a real life breakage
> that's there since v3.3. At least now we are back to
> the problems that where there for a long time.
>=20
> Please also CC: Stable Tree <stable@kernel.org> for 3.4
> as clearly 3.4 is unusable at all right now.

We cannot push this patch to Linus or -stable.
The problem is that will break other things.
E.g. login on non-tty0 terminals will break if the distro uses
util-linux's login.

> I wish they would be sent to older stables as well, but
> they won't patch, so it's not worth the effort.
>=20
>>> 	mingetty is unable to start on anything else than tty0.
>>> 	It exits after a few seconds.
>=20
>=20
> I suspect this was always so since forever. I don't even know
> how to configure such a thing. I know that the console I run
> vmlinux from becomes tty0, until I halt (or crash). How do
> you open more tty(s) and attach them to console windows?
> I just use ssh for that.

con=3Dpts is very nice.
UML allocates a pts for each tty on the *host* side.
Then you can attach to this tty using screen.
See: http://user-mode-linux.sourceforge.net/old/input.html

> (The setup of tty(s) for UML on Fedora is always such a pain
>  and it changed 4 times since FC10, I always have to mount
>  the image, figure out how to make tty1 a tty0, and delete
>  all the other tty(s). perhaps I'm just clueless. Is there an
>  easier way? Is there a way to tell UML to make tty0 be a tty1?
>  Because in fedora tty0 is not defined.)

AFAIK no. But you can tell Fedora to use tty0.
Even with systemd this is possible. :-)

> But please do not delay these patches because of old problems.
> These can be solved later.

Breaking existing applications is a no-go, sorry.

Thanks,
//richard


--------------enig85F82DD115F8CB8977DFA1CF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJP0GoiAAoJEN9758yqZn9eOAEH/ibh7uGmaue2YgEqxgJyZgBE
tnXVERVfRGNgSEZDhszSEeLYyEASKUFlu7Re8BQBXi4UwXnT3SDOtixwr1cnP/QZ
wIyJHm/ROEy2gofKmIUiF3I/j3t8EkxlmvnrHTCaD4LfSxCvoLJGQ295ABSZufRH
rwZ/4Kz3xZPwrmj2Y8HFdeY2Qk0K2apozQgeTqHlUM7G/PqfINWIf7Eoq+WE6n5x
QszSyQHnOAtyiB0eZdd4D+Ax7PKho0RGAQIFwMV2yMXQemigvwafefnYakQ4x3yP
M1zSOjQgDnovo64Sx4gUXnIIgkKoEkhLfkdb6CgaV5ab+Xgdd8Bw48XX2SJPhuU=
=RM+Z
-----END PGP SIGNATURE-----

--------------enig85F82DD115F8CB8977DFA1CF--
