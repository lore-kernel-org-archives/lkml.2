Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab0LHWMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 17:12:09 -0500
Received: from nm12.bullet.mail.ukl.yahoo.com ([217.146.183.186]:36024 "HELO
	nm12.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751676Ab0LHWMI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 17:12:08 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 886964.48551.bm@omp1032.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=gGJuQTyFsZFmJHNhzklfTMR+XCa80MZP3VY2pUZwavok1k0s0SSNk+bsz6BZsEWgsGkql9ob+IV6dFXH/kh0EWfImHjaCdNskAkCEGyEmHt7l1tB0fVDWLZmTThl0I1ow+z79klW/TNouW4uxtw2PMbpeqQibchgXVgwgSqAlgM=;
Message-ID: <739226.14408.qm@web26002.mail.ukl.yahoo.com>
X-YMail-OSG: ALGDGF0VM1l0eLK3KNv3SJwJxxGRNOhjJwAtnc.SUhMz4sQ
 Fb.xNS5lJ1.OYk3wSjqI0qmPb66FZvR20plpdPjdUJrMlgOwbFoQFqLllezV
 W3yMX0QTeBNd5ho7H_9XHAePZLGZx4sHT5Q4jGWhAbutHHaVSgjUePp13k0N
 ZcnJ0MIwIebFqRja_0bBMV.jGB1Cmnv4B2Ebh55.D4df6NNpq2M1SJ5tiLpq
 t54iL_TMPLnp5jZ42cukHktnXcOcn3xPNFPAmdOqcnWn.T3Xaa.FYkV6andI
 clIvyh8clg340IxdrfTLk1m_xEuWpnHYyxmgvnr76_XCrhNcz6CtRQ.17iLw
 EtiDQKH03F2pqVLI1DqUXel8n
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Wed, 8 Dec 2010 22:12:05 +0000 (GMT)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: [announce] Gujin GPL bootloader version 2.8.3
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a new version v2.8.3 of the Gujin bootloader at
http://gujin.org (and sourceforge) with bug fixes and improvements, and
Debian/Ubuntu/Fedora packages for easy installation on i386/amd64 PC.

In its standard form, Gujin is a graphic bootloader (with mouse support)
which try to autodetect everything from its environment, and have
near zero configuration.
It can be installed on hard disks, CDROMs or USB thumb drives for
easy testing, the fact that BIOS disk number usually change when
the PC is booted from different devices is not a problem for Gujin;
however Gujin arrived in memory has no effect on what it will boot.

The major technical improvement is in the removal of the hard coded
sector size (512 for HD, 2048 for CDROM); Gujin can be installed
on devices with 512/1024/2048/4096 bytes per sectors, it can boot from
such devices (when the BIOS support it), and it can chain-boot such
devices by simulating a BIOS disk with those sector sizes, from a
disk content stored on standard hard disk or CDROM.
See the Makefile target "boothdimg" to test yourself.

There is also improvements and bug fixed for the El-Torito simulator,
i.e. booting a CDROM image file stored on a hard drive, as if it was
a real CDROM: more DVD boot now, and a new option has been added to
detect the underlying file once booted (/sbin/gujin --report-signature).
Basically, the gujin bootloader simulate the El-Torito BIOS disk
leaving an extended "$INT13SF" signature containing the BIOS EDD
disk identification (PCI address...), which is compared at run time to
/dev/disk/by-path and /dev/disk/by-id to give the partition to mount
and the file to loop-mount instead of the CDROM.

Some work has also been done to simplify the use of the tiny bootloader,
for people having a simple configuration - like having a single Linux
distribution on ext4fs on a PC (or a virtual PC): they can install like
/sbin/gujin -t tinyext4.bin /boot/minigujin.ebios
and the bootloader will automatically load the newest (by date)
vmlinuz/initrd pair without displaying any menu, without probing any
other disk than the booted one. In case of major problem, one can type
Control-Break while loading to get an older vmlinuz/initrd pair.
The command line can be given by the --cmdline="" parameter or stored
in /boot/gujin.cmd.
Use "/sbin/gujin --remove /boot/minigujin.ebios" to reinstall the
previous bootloader (previous MBR saved inside /boot/minigujin.ebios).

The tiny configuration can also be used as an El-Torito bootloader,
see Makefile target "CDtiny", and on USB thumb drives by using
respectively tinycdrom.bin and tinyusb.bin metafile (metafiles are
stored inside the installer itself).

Also, there has been a project-wide rename of file "boot.exe" to
"gujin.exe", "tiny.exe" to "mingujin.exe" and "boot.bcd" to "gujin.bcd";
file "gujin" or "gujin64" are the Linux executable installer, and all the
target bootloaders have "gujin" in their name.

The file "changelog.wri" in the source archive describes many other
modifications, fixing quite a few bugs.

Downloads at:
http://sourceforge.net/projects/gujin/files/

Have fun,
Etienne.



      
