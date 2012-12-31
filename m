Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab2LaPHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 10:07:34 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34996 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751287Ab2LaPHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 10:07:31 -0500
X-Sasl-enc: vM0Og1PTdzp+LB69euMcklxffOfxt6WojmIhSCcTG6od 1356966450
Message-ID: <50E1AA27.5000508@imap.cc>
Date: Mon, 31 Dec 2012 16:07:19 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Regression: Bacula jobs fail with kernel 3.8-rc1
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE67DC6FE85E55132DD0F4010"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE67DC6FE85E55132DD0F4010
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

With kernel 3.8-rc1, my nightly Bacula backup job reproducibly aborts
20 minutes into spooling with a "broken pipe" error on the network
socket connecting the file and storage daemons:

31-Dec 00:45 xenon-sd JobId 859: Spooling data ...
31-Dec 01:04 xenon-fd JobId 859: Error: bsock.c:429 Write error sending
65536 bytes to Storage daemon:xenon:9103: ERR=3DBroken pipe
31-Dec 01:04 xenon-fd JobId 859: Fatal error: backup.c:1200 Network send
error to SD. ERR=3DBroken pipe
31-Dec 01:04 xenon-dir JobId 859: Error: Director's comm line to SD dropp=
ed.

Returning to kernel 3.7.1 makes it work again. (Provided the crash
I reported in http://marc.info/?l=3Dlinux-kernel&m=3D135337052232021&w=3D=
2
doesn't hit, of course.)

Configuration:
Intel Pentium D, Intel DQ965GF mainboard, 6 GB RAM
onboard S-ATA controller driving two 500 GB S-ATA disks
and a Pioneer DVR-216D DVD-RW drive
Adaptec 29160B Ultra160 SCSI adapter driving a
Tandberg TS400 LTO-2 tape drive
openSUSE 11.4 userspace
Bacula 5.2.12, all daemons on the same machine, spooling to local disk

Regards,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigE67DC6FE85E55132DD0F4010
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlDhqjEACgkQQ3+did9BuFvwQgCfUBDiDy7epIUVulvX5G+XtUvU
F/8AnjsNzKbrAlfjU+f33DB08a4o7/2R
=wrwP
-----END PGP SIGNATURE-----

--------------enigE67DC6FE85E55132DD0F4010--
