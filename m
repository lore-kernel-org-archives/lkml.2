Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2KTAPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:15:11 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40107 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943Ab2KTAPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:15:10 -0500
X-Sasl-enc: nKKJBp2jZGEervt6mWHNyjnMPSlg6NTjOA4z4N+GCgsF 1353370509
Message-ID: <50AACB7E.8060601@imap.cc>
Date: Tue, 20 Nov 2012 01:14:54 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: possible regression in kernel 3.6: system hangs during nightly tape
 backup
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1D6E4DB681D736380794D687"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1D6E4DB681D736380794D687
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

For the 4th time now after switching to kernel 3.6, my system became
unresponsive during the nightly Bacula backup run. It looks as if
all disk accesses are suddenly blocked:
- Desktop apps stop responding one after another, starting with
  Firefox followed by other "heavy" apps, while Konsole windows
  continue being usable for a while.
- "top" shows the load average steadily increasing with no process
  actually consuming relevant quantities of CPU.
- I can do "dmesg > /root/dmesg.out" followed by "less /root/dmesg.out"
  in a Konsole window just fine, but after the inevitable hard reset
  the file /root/dmesg.out isn't there.
- The "sync" command hangs indefinitely.
- The "shutdown" command and ctrl/alt/Del emit "system going down"
  broadcast messages but never get anywhere.
- Killing processes manually works for some (bacula-sd even ejects
  the tape before exiting) but most remain in state D or Z.
- Eventually, all text consoles are blocked and a hardware reset is
  the only remaining option.
- After the reboot, a Bacula spool file is left behind in
  /var/spool/bacula, proof that the hang happened during the backup.

This does not happen during every backup run, but frequently enough
to be annoying. (About once per week.) It never happened with kernel
3.5. For comparison went back to kernel 3.5.7 for a week and it
never happened during that time. Last night I booted 3.6.7 and the
very next backup caused the hang again. The last kernel message that
made it to the syslog on disk was

Nov 19 23:05:04 xenon kernel: [73877.128546] st0: Block limits 256 -
524288 bytes.

triggered by the start of the backup. In dmesg the next message was

[74401.249091] INFO: task flush-253:2:1320 blocked for more than 120
seconds.

followed by a backtrace. I have photos of the remaining dmesg output
which I'll try to upload somewhere accessible tomorrow.

Hardware configuration:
Intel Pentium D, Intel DQ965GF mainboard, 6 GB RAM
onboard S-ATA controller driving two 500 GB S-ATA disks
and a Pioneer DVR-216D DVD-RW drive
Adaptec 29160B Ultra160 SCSI adapter driving a
Tandberg TS400 LTO-2 tape drive

Disk configuration: md RAID1, LVM, ext3 and ext4 volumes

Software: Opensuse 11.4 64 bit, vanilla kernel 3.5.7 and 3.6.7,
Bacula 5.2.12

HTH
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig1D6E4DB681D736380794D687
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iEYEARECAAYFAlCqy4wACgkQQ3+did9BuFv7NwCfQTN1HrT6TtX7b3A5YElwRLVH
u4oAn3NWyKlJFcjrTSHe8ZSidnUivZif
=bdu3
-----END PGP SIGNATURE-----

--------------enig1D6E4DB681D736380794D687--
