Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab2DWUU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:20:28 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:56136 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab2DWUU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:20:27 -0400
Date: Mon, 23 Apr 2012 22:20:20 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, tcminyard@gmail.com,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: [BISECTED] ipmi_si not loading since 2.6.39
Message-ID: <20120423202020.GE2048@nik-comp.lan>
References: <20120420223833.GA7855@nik-comp.lan> <20120421072056.GA2033@nik-comp.lan> <4F95B6F3.3010303@calxeda.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PPYy/fEw/8QCHSq3"
Content-Disposition: inline
In-Reply-To: <4F95B6F3.3010303@calxeda.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7501835 records (last update: 20120423)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PPYy/fEw/8QCHSq3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> It is working for me on a SuperMicro system with ubuntu oneiric (3.0
> based).

hmm, strange.. I'll try with 3.0.0 on my system.. Could You post Your confi=
g please?
thanks!
n.


>=20
> [597160.259728] ipmi_si: probing via SMBIOS
> [597160.259730] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
> [597160.259731] ipmi_si: Adding SMBIOS-specified kcs state machine
> [597160.259734] ipmi_si: probing via SPMI
> [597160.259735] ipmi_si: SPMI: io 0xe4 regsize 1 spacing 1 irq 0
> [597160.259737] ipmi_si: Adding SPMI-specified kcs state machine
> [597160.259739] ipmi_si: Trying SMBIOS-specified kcs state machine at
> i/o address 0xca2, slave address 0x0, irq 0
> [597160.378757] ipmi_si: Invalid return from get global enables command,
> cannot enable the event buffer.
> [597160.382032] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x00b980,
> prod_id: 0x0624, dev_id: 0x20)
> [597160.382040] ipmi_si ipmi_si.0: IPMI kcs interface initialized
> [597179.973960] ipmi device interface
> localadm@sandy1:~$ ipmitool bmc info
> Could not open device at /dev/ipmi0 or /dev/ipmi/0 or /dev/ipmidev/0: No
> such file or directory
> Get Device ID command failed
> localadm@sandy1:~$ sudo ipmitool bmc info
> Device ID                 : 32
> Device Revision           : 1
> Firmware Revision         : 1.1
> IPMI Version              : 2.0
> Manufacturer ID           : 47488
> Manufacturer Name         : Unknown (0xB980)
> Product ID                : 1572 (0x0624)
> Product Name              : Unknown (0x624)
> Device Available          : yes
> Provides Device SDRs      : no
> Additional Device Support :
>     Sensor Device
>     SDR Repository Device
>     SEL Device
>     FRU Inventory Device
>     IPMB Event Receiver
>     IPMB Event Generator
>     Chassis Device
> Aux Firmware Rev Info     :
>     0x06
>     0x00
>     0x00
>     0x00
> localadm@sandy1:~$ uname -a
> Linux sandy1 3.0.0-16-generic #28-Ubuntu SMP Fri Jan 27 17:44:39 UTC
> 2012 x86_64 x86_64 x86_64 GNU/Linux
>=20
> Rob
>=20
> > nik
> >=20
> >=20
> > On Sat, Apr 21, 2012 at 12:38:33AM +0200, Nikola Ciprich wrote:
> >> Hello,
> >>
> >> I was trying to find out why IPMI stopped working on new kernels. Sinc=
e 2.6.39
> >> module loading ends with following message:
> >>
> >>  ipmi_si: Interface detection failed
> >>
> >> Then ipmitool is unable to control IPMI device.=20
> >>
> >> Works for 2.6.38, doesn't work for 2.6.39, 3.0.28, 3.4-rc1.
> >>
> >> I got this bisected to following commit:
> >>
> >> commit a1e9c9dd3383e6a1a762464ad604b1081774dbda
> >> Author: Rob Herring <rob.herring@calxeda.com>
> >> Date:   Wed Feb 23 15:37:59 2011 -0600
> >>
> >>     ipmi: convert OF driver to platform driver
> >>    =20
> >>     of_bus is deprecated in favor of the plain platform bus. This patch
> >>     merges the ipmi OF driver with the existing platform driver.
> >>    =20
> >>     CONFIG_PPC_OF occurrances are removed or replaced with CONFIG_OF.
> >>    =20
> >>     Compile tested with and without CONFIG_OF. Tested OF probe and
> >>     default probe cases.
> >>    =20
> >>     Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> >>     Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> >>
> >> I wonder whether this is a bug, or I'm doing something wrong?
> >>
> >> Thanks in advance!
> >>
> >> with best regards
> >>
> >> nik
> >>
> >>
> >> --=20
> >> -------------------------------------
> >> Ing. Nikola CIPRICH
> >> LinuxBox.cz, s.r.o.
> >> 28. rijna 168, 709 01 Ostrava
> >>
> >> tel.:   +420 596 603 142
> >> fax:    +420 596 621 273
> >> mobil:  +420 777 093 799
> >>
> >> www.linuxbox.cz
> >>
> >> mobil servis: +420 737 238 656
> >> email servis: servis@linuxbox.cz
> >> -------------------------------------
> >=20
> >=20
> >=20
>=20

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

--PPYy/fEw/8QCHSq3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+VuYQACgkQ3xdJJrLygV754QCgoQe6PnrzsQrAUCo6CaqPeDrJ
lGgAoOC81wKDRkBF+RoXICIDHCeK73hH
=rJM/
-----END PGP SIGNATURE-----

--PPYy/fEw/8QCHSq3--
