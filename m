Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335Ab1EXNgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 09:36:06 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:48355 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932218Ab1EXNgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 09:36:03 -0400
X-Sasl-enc: 1xuV6ZPy1i9LYkDsdfwTZ2393xRqgeeEgnJaXnO2HLiA 1306244162
Message-ID: <4DDBB43F.1040606@imap.cc>
Date: Tue, 24 May 2011 15:35:59 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.38.7 kernel lockup after inserting bad CD-ROM, suspecting pata_marvell
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig390C8F74B2C18869200390CD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig390C8F74B2C18869200390CD
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

I have found a CD-ROM which reliably causes my work machine to
lock up hard when inserted in one of its optical drives.

The machine is an Intel Pentium D on a DQ965GF mainboard
(ICH8 chipset, Marvell PATA adapter) with SATA harddisks,
a Pioneer DVR-216D SATA DVD writer and a HL-DT-ST GDR8164B
PATA DVD-ROM drive, running a vanilla 2.6.38.7 x86_64 kernel
with openSUSE 11.2 userspace.

After inserting the "bad" CD-ROM in the PATA DVD-ROM drive, the
drive starts spinning up and down as if doing an endless series
of retries. After about two minutes of this, the keyboard and
mouse stop responding. Not even the numlock LED reacts anymore.
Meanwhile the drive continues spinning up and down, and the
drive door remains locked. The only way out is the reset button.
There are no log messages in /var/log/messages nor on tty10.

Inserting the same CD-ROM in the SATA DVD-RW drive produces
some disquieting noises and these error messages:

[11739.693684] ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x800100 actio=
n 0x6
[11739.693916] ata3.00: irq_stat 0x40000001
[11739.694075] ata3: SError: { UnrecovData LinkSeq }
[11739.694258] sr 2:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 a9 d0 00 00 0=
2 00
[11739.694414] ata3.00: cmd a0/01:00:00:00:10/00:00:00:00:00/a0 tag 0 dma=
 4096 in
[11739.694417]          res 51/34:03:00:00:00/00:00:00:00:00/a0 Emask 0x1=
0 (ATA bus error)
[11739.694421] ata3.00: status: { DRDY ERR }
[11739.694434] ata3: hard resetting link
[11739.999046] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[11740.012124] ata3.00: configured for UDMA/66
[11740.026918] ata3: EH complete
[11760.951766] sr 2:0:0:0: [sr0] Unhandled sense code
[11760.960587] sr 2:0:0:0: [sr0]  Result: hostbyte=3DDID_OK driverbyte=3D=
DRIVER_SENSE
[11760.969607] sr 2:0:0:0: [sr0]  Sense Key : Medium Error [current]=20
[11760.978565] Info fld=3D0x2a9d0
[11760.987515] sr 2:0:0:0: [sr0]  Add. Sense: CIRC unrecovered error
[11760.987521] sr 2:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 a9 d0 00 00 0=
2 00
[11760.987532] end_request: I/O error, dev sr0, sector 698176
[11760.987537] Buffer I/O error on device sr0, logical block 87272
[11761.253371] ata3.00: exception Emask 0x10 SAct 0x0 SErr 0x800100 actio=
n 0x6
[11761.263856] ata3.00: irq_stat 0x40000001
[11761.281421] ata3: SError: { UnrecovData LinkSeq }
[11761.281429] sr 2:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 a9 d0 00 00 0=
2 00
[11761.281444] ata3.00: cmd a0/01:00:00:00:10/00:00:00:00:00/a0 tag 0 dma=
 4096 in
[11761.281446]          res 51/34:03:00:00:00/00:00:00:00:00/a0 Emask 0x1=
0 (ATA bus error)
[11761.281450] ata3.00: status: { DRDY ERR }
[11761.281464] ata3: hard resetting link
[11761.586042] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[11761.601695] ata3.00: configured for UDMA/66
[11761.618814] ata3: EH complete
[11782.277933] sr 2:0:0:0: [sr0] Media Changed
[11782.288698] sr 2:0:0:0: [sr0]  Result: hostbyte=3DDID_OK driverbyte=3D=
DRIVER_SENSE
[11782.299639] sr 2:0:0:0: [sr0]  Sense Key : Unit Attention [current]=20
[11782.310105] sr 2:0:0:0: [sr0]  Add. Sense: Not ready to ready change, =
medium may have changed
[11782.327483] sr 2:0:0:0: [sr0] CDB: Read(10): 28 00 00 02 a9 d0 00 00 0=
2 00
[11782.338089] end_request: I/O error, dev sr0, sector 698176
[11782.349418] Buffer I/O error on device sr0, logical block 87272

The system remains usable, though, and the CD-ROM can actually be
read just fine. So it looks to me as if the pata_marvell driver
has a problem handling that particular kind of disk defect.

Any interest in investigating this further?
Any hint on how to do it?
(Without killing my machine more often than necessary, that is.)

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig390C8F74B2C18869200390CD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk3btD8ACgkQQ3+did9BuFuIlwCfczVANqKrjiLvRO5Pqqmy/WWT
yYoAnjOUmpxpl+AMWQysgD4mKZ79Bolr
=mGI+
-----END PGP SIGNATURE-----

--------------enig390C8F74B2C18869200390CD--
