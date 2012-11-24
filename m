Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2KXTSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 14:18:04 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46046 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752173Ab2KXTSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 14:18:02 -0500
X-Sasl-enc: 3KogAsxsYo5VnAoJO+Aiu4c5Je9FoUovsn+j5E5qaBgR 1353784680
Message-ID: <50B11D5C.2000802@imap.cc>
Date: Sat, 24 Nov 2012 20:17:48 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: possible regression in kernel 3.6: system hangs during nightly
 tape backup
References: <50AACB7E.8060601@imap.cc>
In-Reply-To: <50AACB7E.8060601@imap.cc>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA3D7281D7207FDA9F1649708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA3D7281D7207FDA9F1649708
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Any ideas on that? I'm currently avoiding the 3.6 series because
of that problem but would be willing to reproduce the hang if I'd
know what to do once it happens, ie. what kind of information to
collect in order to identify the cause of the problem.
I may also try 3.7-rc if there's any interest.

Am 20.11.2012 01:14, schrieb Tilman Schmidt:
> For the 4th time now after switching to kernel 3.6, my system became
> unresponsive during the nightly Bacula backup run. It looks as if
> all disk accesses are suddenly blocked:
> - Desktop apps stop responding one after another, starting with
>   Firefox followed by other "heavy" apps, while Konsole windows
>   continue being usable for a while.
> - "top" shows the load average steadily increasing with no process
>   actually consuming relevant quantities of CPU.
> - I can do "dmesg > /root/dmesg.out" followed by "less /root/dmesg.out"=

>   in a Konsole window just fine, but after the inevitable hard reset
>   the file /root/dmesg.out isn't there.
> - The "sync" command hangs indefinitely.
> - The "shutdown" command and ctrl/alt/Del emit "system going down"
>   broadcast messages but never get anywhere.
> - Killing processes manually works for some (bacula-sd even ejects
>   the tape before exiting) but most remain in state D or Z.
> - Eventually, all text consoles are blocked and a hardware reset is
>   the only remaining option.
> - After the reboot, a Bacula spool file is left behind in
>   /var/spool/bacula, proof that the hang happened during the backup.
>=20
> This does not happen during every backup run, but frequently enough
> to be annoying. (About once per week.) It never happened with kernel
> 3.5. For comparison went back to kernel 3.5.7 for a week and it
> never happened during that time. Last night I booted 3.6.7 and the
> very next backup caused the hang again. The last kernel message that
> made it to the syslog on disk was
>=20
> Nov 19 23:05:04 xenon kernel: [73877.128546] st0: Block limits 256 -
> 524288 bytes.
>=20
> triggered by the start of the backup. In dmesg the next message was
>=20
> [74401.249091] INFO: task flush-253:2:1320 blocked for more than 120
> seconds.
>=20
> followed by a backtrace. I have photos of the remaining dmesg output
> which I'll try to upload somewhere accessible tomorrow.
>=20
> Hardware configuration:
> Intel Pentium D, Intel DQ965GF mainboard, 6 GB RAM
> onboard S-ATA controller driving two 500 GB S-ATA disks
> and a Pioneer DVR-216D DVD-RW drive
> Adaptec 29160B Ultra160 SCSI adapter driving a
> Tandberg TS400 LTO-2 tape drive
>=20
> Disk configuration: md RAID1, LVM, ext3 and ext4 volumes
>=20
> Software: Opensuse 11.4 64 bit, vanilla kernel 3.5.7 and 3.6.7,
> Bacula 5.2.12
>=20
> HTH
> T.
>=20


--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)



--------------enigA3D7281D7207FDA9F1649708
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlCxHWgACgkQMdB4Whm86/kORgCaA6NyoHFP2YVirQVdGDVhV70+
jiEAnRfCRWIBnY49KVFR+SvXHlwC0sk9
=wcMI
-----END PGP SIGNATURE-----

--------------enigA3D7281D7207FDA9F1649708--
