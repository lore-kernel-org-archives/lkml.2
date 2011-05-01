Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316Ab1EASLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 14:11:19 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:44312 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab1EASLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 14:11:17 -0400
Date: Sun, 1 May 2011 20:10:30 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Cc: nikola.ciprich@linuxbox.cz, stable@kernel.org,
        hirofuchi@users.sourceforge.net, arjan.mels@gmx.net, rjw@sisk.pl,
        greg@kroah.com, stern@rowland.harvard.edu,
        Stanislav SCHATTKE <schattke@linuxbox.cz>
Subject: [regression?] d199c96d41d80a567493e12b8e96ea056a1350c1 breaks usbip
Message-ID: <20110501181030.GA9106@nik-comp.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 5068869 records (last update: 20110501)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
we've hit regression introduced by d199c96d41d80a567493e12b8e96ea056a1350c1:

Author: Alan Stern <stern@rowland.harvard.edu>
Date:   Mon Jan 31 10:56:37 2011 -0500

    USB: prevent buggy hubs from crashing the USB stack
   =20
    If anyone comes across a high-speed hub that (by mistake or by design)
    claims to have no Transaction Translators, plugging a full- or
    low-speed device into it will cause the USB stack to crash.  This
    patch (as1446) prevents the problem by ignoring such devices, since
    the kernel has no way to communicate with them.
   =20
    Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
    Tested-by: Perry Neben <neben@vmware.com>
    CC: <stable@kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

since this commit, trying to use staging/usbip spits message about missing =
TT:

[  388.893134] usbip_common_mod: module is from the staging directory, the =
quality is unknown, you have been warned.
[  388.898154] usbip_common_mod: usbip common driver1.0
[  388.905360] vhci_hcd: module is from the staging directory, the quality =
is unknown, you have been warned.
[  388.909991] vhci_hcd: vhci_hcd, 1.0
[  388.912370] usbip: proving...
[  388.912379] vhci_hcd vhci_hcd: USB/IP Virtual Host Contoroller
[  388.913052] vhci_hcd vhci_hcd: new USB bus registered, assigned bus numb=
er 2
[  388.932339] usb usb2: New USB device found, idVendor=3D1d6b, idProduct=
=3D0002
[  388.932344] usb usb2: New USB device strings: Mfr=3D3, Product=3D2, Seri=
alNumber=3D1
[  388.932348] usb usb2: Product: USB/IP Virtual Host Contoroller
[  388.932351] usb usb2: Manufacturer: Linux 2.6.32lb.38 vhci_hcd
[  388.932354] usb usb2: SerialNumber: vhci_hcd
[  388.932531] usb usb2: configuration #1 chosen from 1 choice
[  388.932578] hub 2-0:1.0: USB hub found
[  388.932587] hub 2-0:1.0: 8 ports detected
[  478.379036] usbip: rhport(0) sockfd(3) devid(131075) speed(2)
[  478.379214] usbip: changed 1
[  478.500048] usbip: changed 0
[  478.608075] usb 2-1: new full speed USB device using vhci_hcd and addres=
s 2
[  478.608079] usb 2-1: parent hub has no TT
[  478.720074] usb 2-1: new full speed USB device using vhci_hcd and addres=
s 3
[  478.720078] usb 2-1: parent hub has no TT
[  478.832086] usb 2-1: new full speed USB device using vhci_hcd and addres=
s 4
[  478.832091] usb 2-1: parent hub has no TT
[  478.944076] usb 2-1: new full speed USB device using vhci_hcd and addres=
s 5
[  478.944080] usb 2-1: parent hub has no TT
[  478.944087] hub 2-0:1.0: unable to enumerate USB device on port 1

I'm not sure whether this is bug in d199c96d41d80a567493e12b8e96ea056a1350c=
1, I guess it might be usbip problem.
Since d199c96d41d80a567493e12b8e96ea056a1350c1 already got into -stable, us=
bip stopped working in 2.6.32.x (and I guess also stable and longterm kerne=
ls).

I also tried 2.6.39-rc5-git4 but usbip seems to be even more broken there. =
Here's dmesg trying to initialize usbip (with debugging enabled).
http://nelide.cz/nik/2.6.39-rc5-git4-usbip-dmesg.txt
(it's long, so I've uploaded it to web).

Could somebody please have a look at this? Should more information or testi=
ng be needed, I'll be glad to assist.

Cheers!

nik


--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk29ohYACgkQ3xdJJrLygV77sQCfYTpgCtRjuJhuIKKpiIJkSarZ
xrsAnj6hcnPx+sDcKlAx2kV34cDm5PFX
=hDCi
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
