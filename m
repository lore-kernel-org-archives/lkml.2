Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751328Ab1I0PFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 11:05:01 -0400
Received: from mailout.selfhost.de ([82.98.82.25]:34782 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751138Ab1I0PFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 11:05:00 -0400
Message-ID: <4E81E618.7030400@afaics.de>
Date: Tue, 27 Sep 2011 17:04:56 +0200
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 3.0.4, xhci: "short transfer" and "Stalled endpoint" warnings
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

I've got a Fantec Sata to USB3 Adapter. Problem: If I insert a
disk (WD20EARS) and switch it on, then I get

[ 4382.279961] usb 3-2: new SuperSpeed USB device number 2 using xhci_hcd
[ 4382.290848] xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
[ 4382.290939] xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
[ 4382.291061] xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
[ 4382.291151] xhci_hcd 0000:04:00.0: WARN: short transfer on control ep
[ 4382.291199] usb 3-2: New USB device found, idVendor=174c, idProduct=55aa
[ 4382.291202] usb 3-2: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[ 4382.291205] usb 3-2: Product: 012345678901234567890123456789012345678901234567
[ 4382.291208] usb 3-2: Manufacturer: 01234567890123456789012345678901234567890123
[ 4382.291210] usb 3-2: SerialNumber: 0123456789ABCDEF0124
[ 4382.292407] scsi7 : usb-storage 3-2:1.0
[ 4397.044179] scsi 7:0:0:0: Direct-Access     WDC WD20 EARS-00J2GB0     80.0 PQ: 0 ANSI: 5
[ 4397.044434] sd 7:0:0:0: Attached scsi generic sg7 type 0
[ 4397.045257] sd 7:0:0:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[ 4397.045423] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[ 4397.045675] sd 7:0:0:0: [sdg] Write Protect is off
[ 4397.045681] sd 7:0:0:0: [sdg] Mode Sense: 23 00 00 00
[ 4397.045814] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[ 4397.046049] sd 7:0:0:0: [sdg] No Caching mode page present
[ 4397.046052] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[ 4397.046503] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[ 4397.046864] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[ 4397.047102] sd 7:0:0:0: [sdg] No Caching mode page present
[ 4397.047107] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[ 4397.125154]  sdg: sdg1
[ 4397.125723] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[ 4397.126093] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[ 4397.126345] sd 7:0:0:0: [sdg] No Caching mode page present
[ 4397.126349] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[ 4397.126352] sd 7:0:0:0: [sdg] Attached SCSI disk
[ 4397.133557] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[ 4397.133790] sd 7:0:0:0: [sdg]  Sense Key : Recovered Error [current] [descriptor]
[ 4397.133796] Descriptor sense data with sense descriptors (in hex):
[ 4397.133798]         72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 e8 00
[ 4397.133807]         00 00 00 00 00 50
[ 4397.133812] sd 7:0:0:0: [sdg]  ASC=0x4 ASCQ=0x1d
[ 4397.136338] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[ 4397.136727] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[ 4397.211584] xhci_hcd 0000:04:00.0: WARN: Stalled endpoint
[ 4397.211818] sd 7:0:0:0: [sdg]  Sense Key : Recovered Error [current] [descriptor]
[ 4397.211823] Descriptor sense data with sense descriptors (in hex):
[ 4397.211825]         72 01 04 1d 00 00 00 0e 09 0c 00 00 00 00 00 00
[ 4397.211845]         00 00 00 00 00 50
[ 4397.211852] sd 7:0:0:0: [sdg]  ASC=0x4 ASCQ=0x1d


This seems to be reproducible. Is this something to worry about?

Later when reading the disk there are no problems, but I didn't
dare to mount the disk read/write yet.


Any helpful comment would be highly appreciated.

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk6B5gsACgkQUTlbRTxpHjegggCdHSEaqZkLQLaA1xtOHSFBCeq/
044AniA7l9uQD5f9I22Azj7rSpL27SJg
=q42h
-----END PGP SIGNATURE-----
