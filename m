Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab2BHJLO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 04:11:14 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:44116 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2BHJLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 04:11:09 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Brian Norris <computersforpeace@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Norbert Preining <preining@logic.at>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jian Peng <jipeng2005@gmail.com>,
        Kevin Cernekee <cernekee@gmail.com>
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume, COMRESET failed
In-Reply-To: Your message of "Mon, 06 Feb 2012 11:20:45 PST."
             <CAN8TOE9SM1X_rQCScE8hCZYrWVY9K-B_TM+Vvzx3tZQ2LoGxXw@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20120203052452.GC24563@gamma.logic.tuwien.ac.at> <1328247269.15079.26.camel@minggr> <20120203054319.GA25510@gamma.logic.tuwien.ac.at> <1328257660.15079.30.camel@minggr> <20120206004608.GA9413@gamma.logic.tuwien.ac.at> <1328492218.15079.38.camel@minggr> <20120206024052.GI9413@gamma.logic.tuwien.ac.at> <1328496591.15079.40.camel@minggr> <20120206031528.GA16093@gamma.logic.tuwien.ac.at> <1328503376.15079.55.camel@minggr> <20120206161943.GA3926@google.com>
            <CAN8TOE9SM1X_rQCScE8hCZYrWVY9K-B_TM+Vvzx3tZQ2LoGxXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1328692235_3347P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Feb 2012 04:10:35 -0500
Message-ID: <29912.1328692235@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4F323C11.00B6,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1328692235_3347P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Feb 2012 11:20:45 PST, Brian Norris said:

> (3) Debug Norbert's hardware problems.

It's not just Norbert - my Dell Latitude E6500 trips over this as well (d=
idn't
we go through this same song-and-dance *before* with this same exact
patch?  Yes we did, back in May 2011:

http://lkml.indiana.edu/hypermail/linux/kernel/1105.1/02970.html

Somebody hand me a stake and mallet to pount through the heart of this
patch so it *stays* dead already.. Geez.. ;)

Norbert's box has this:
00:1f.2 SATA controller: Intel Corporation 82801IBM/IEM (ICH9M/ICH9M-E) 4=
 port SATA Controller =5BAHCI mode=5D (rev 03) (prog-if 01 =5BAH
CI 1.0=5D)

While mine apparentlyh has a different PCI ID:
lspci -nn -v -s 00:1f.2
00:1f.2 RAID bus controller =5B0104=5D: Intel Corporation Mobile 82801 SA=
TA RAID Controller =5B8086:282a=5D (rev 03)
        Subsystem: Dell Device =5B1028:024f=5D
        Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 45
        I/O ports at 6e70 =5Bsize=3D8=5D
        I/O ports at 6e78 =5Bsize=3D4=5D
        I/O ports at 6e80 =5Bsize=3D8=5D
        I/O ports at 6e88 =5Bsize=3D4=5D
        I/O ports at 6ea0 =5Bsize=3D32=5D
        Memory at fed1c800 (32-bit, non-prefetchable) =5Bsize=3D2K=5D
        Capabilities: =5B80=5D MSI: Enable+ Count=3D1/16 Maskable- 64bit-=

        Capabilities: =5B70=5D Power Management version 3
        Capabilities: =5Ba8=5D SATA HBA v1.0
        Capabilities: =5Bb0=5D PCI Advanced Features
        Kernel driver in use: ahci



from dmesg:
=5B    1.295050=5D ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)=

=5B    1.296037=5D ata1.00: ATA-8: WDC WD1600BJKT-75F4T0, 11.01A11, max U=
DMA/133
=5B    1.296041=5D ata1.00: 312581808 sectors, multi 0: LBA48 NCQ (depth =
31/32), AA
=5B    1.297051=5D ata1.00: configured for UDMA/133
=5B    1.297773=5D scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600BJK=
T-7 11.0 PQ: 0 ANSI: 5
=5B    1.298623=5D sd 0:0:0:0: =5Bsda=5D 312581808 512-byte logical block=
s: (160 GB/149 GiB)
=5B    1.298811=5D sd 0:0:0:0: =5Bsda=5D Write Protect is off
=5B    1.298816=5D sd 0:0:0:0: =5Bsda=5D Mode Sense: 00 3a 00 00
=5B    1.298891=5D sd 0:0:0:0: =5Bsda=5D Write cache: enabled, read cache=
: enabled, doesn't support DPO or FUA
=5B    1.329096=5D  sda: sda1 sda2
=5B    1.330321=5D sd 0:0:0:0: =5Bsda=5D Attached SCSI disk
=5B    6.652045=5D ata2: link is slow to respond, please be patient (read=
y=3D0)
=5B   11.344043=5D ata2: COMRESET failed (errno=3D-16)
=5B   11.649049=5D ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)=

=5B   11.650654=5D ata2.00: ATAPI: MATSHITA DVD+/-RW UJ892, 1.01, max UDM=
A/100
=5B   11.653036=5D ata2.00: configured for UDMA/100
=5B   11.656392=5D scsi 1:0:0:0: CD-ROM            MATSHITA DVD+-RW UJ892=
    1.01 PQ: 0 ANSI: 5
=5B   11.659202=5D sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/=
form2 cdda tray
=5B   11.659206=5D cdrom: Uniform CD-ROM driver Revision: 3.20
=5B   11.659794=5D sr 1:0:0:0: Attached scsi CD-ROM sr0
=5B   11.965047=5D ata5: SATA link down (SStatus 0 SControl 300)
=5B   12.270047=5D ata6: SATA link down (SStatus 0 SControl 300)




--==_Exmh_1328692235_3347P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBTzI8CwdmEQWDXROgAQLLkA//fbMpIXk6w+Into3XlloLN4AMP5I7Y9+H
OsbHC29bEXtWjZkwzIkslrS1B1BcoHDl5E/Ql0Dyyeh+zMgpHVEv3dZCnqABRgUa
OPezfSLMOT4RL31o6emoyoK77kRLuutYQprvprg812xMEQKVDL0y919Dv9ya0HeC
nvRJPerKv/APIZfmS7HWGipUGGv0DfLls3png/uoVNSp/7n20i/7/eoXf6lQSkN2
YIQNLvNukhsip8Bu1ApT/RGyl2d8npWzr3bkMjPPEkkiaGlTZJhSNXFvW0nSd3ki
EoZEHT5zuMj366ic/soLa8CN/tNMgejgP8OuaJtyLkQSz+vXXMcIXhxbDu0k/iYJ
P067ImOf+qtIW9UMCNb7YheWWOn2xJxU582Oj3dfq3qOdpGRZtzrMID/NzhH0zDj
YMzyzanVQgd3YUDK34wtSWjIpk/JsWsm8T06qLnxmn6HditAVzOWWwiEY1n53JpR
rSNviTr+IoIqKIg0TdhSAf3tJdIO5u73AtETkCWfORdcrmF1+/D+u0rhtP5UucCa
yCQ+VDEl42EAtNufmUNBNGk14JBOCWoQgxoo2bcW9JBmZFpksLjYYYOCysu26ZLJ
RqpUHT87bMe4wtG/Fz7KkgZ3iGyZ0lRbaBAJC5+ukvOlf2XroFUax6/HY5C3YQ+B
7D/kxc9SzeU=
=iH04
-----END PGP SIGNATURE-----

--==_Exmh_1328692235_3347P--

