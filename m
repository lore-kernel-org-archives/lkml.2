Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab2DWUJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:09:44 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:53458 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab2DWUJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:09:43 -0400
Date: Mon, 23 Apr 2012 22:09:37 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: linux-kernel@vger.kernel.org
Cc: rob.herring@calxeda.com, tcminyard@gmail.com,
        Nikola Ciprich <nik@nik-comp.lan>
Subject: Re: [BISECTED] ipmi_si not loading since 2.6.39
Message-ID: <20120423200937.GA4983@nik-comp.lan>
References: <20120420223833.GA7855@nik-comp.lan>
 <20120421072056.GA2033@nik-comp.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20120421072056.GA2033@nik-comp.lan>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 7501835 records (last update: 20120423)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

any idea anyone? Simply reverting this patch is not possible due to further
modifications so I haven't tried this yet..

Any hint on what could I try? (specifying some module parameters, etc..)

Thanks!

nik



On Sat, Apr 21, 2012 at 09:20:56AM +0200, Nikola Ciprich wrote:
> Hi,
>=20
> here's further information Rob and Corey requested:
>=20
> on working system:
>=20
> [root@vbox4 ~]# cat /proc/ipmi/0/params
> kcs,i/o,0xca2,rsp=3D1,rsi=3D1,rsh=3D0,irq=3D0,ipmb=3D0
>=20
> dmesg snippet:
>=20
> [   41.759319] ipmi message handler version 39.2
> [   41.760690] ipmi device interface
> [   42.765334] IPMI System Interface driver.
> [   42.765336] ipmi_si: probing via hardcoded address
> [   42.765337] ipmi_si: Adding hardcoded-specified kcs state machine
> [   42.765340] ipmi_si: Trying hardcoded-specified kcs state machine at i=
/o address 0xca8, slave address 0x0, irq 0
> [   42.765344] ipmi_si: Interface detection failed
> [   42.770823] ipmi_si: probing via SMBIOS
> [   42.770834] ipmi_si: SMBIOS: io 0xca2 regsize 1 spacing 1 irq 0
> [   42.770836] ipmi_si: Adding SMBIOS-specified kcs state machine
> [   42.770838] ipmi_si: probing via SPMI
> [   42.770840] ipmi_si: SPMI: io 0xe4 regsize 1 spacing 1 irq 0
> [   42.770841] ipmi_si: Adding SPMI-specified kcs state machine
> [   42.770843] ipmi_si: Trying SMBIOS-specified kcs state machine at i/o =
address 0xca2, slave address 0x0, irq 0
> [   42.798137] ipmi_si ipmi_si.0: Error clearing flags: cc
> [   42.801011] ipmi_si ipmi_si.0: Found new BMC (man_id: 0x002a7c, prod_i=
d: 0x0624, dev_id: 0x20)
> [   42.801068] ipmi_si ipmi_si.0: IPMI kcs interface initialized
>=20
>=20
> dmidecode:
>=20
> IPMI Device Information
>         Interface Type: KCS (Keyboard Control Style)
>         Specification Version: 2.0
>         I2C Slave Address: 0x00
>         NV Storage Device: Not Present
>         Base Address: 0x0000000000000CA2 (I/O)
>         Register Spacing: Successive Byte Boundaries
>=20
> Base Board Information
>         Manufacturer: Supermicro
>         Product Name: X9SCL/X9SCM
>=20
> (but we're experiencing this on various supermicro bords, ie X8DTL)
>=20
> Tried setting parameters by hand didn't help:
>=20
> modprobe ipmi_si type=3Dkcs addrs=3D0xca8 regspacings=3D1 regsizes=3D1 re=
gshifts=3D0 irqs=3D0 slave_addrs=3D0x0
>=20
> (not sure whether I got them correct though, and values mostly seem to me=
 to be defaults anyways..)
>=20
> nik
>=20
>=20
> On Sat, Apr 21, 2012 at 12:38:33AM +0200, Nikola Ciprich wrote:
> > Hello,
> >=20
> > I was trying to find out why IPMI stopped working on new kernels. Since=
 2.6.39
> > module loading ends with following message:
> >=20
> >  ipmi_si: Interface detection failed
> >=20
> > Then ipmitool is unable to control IPMI device.=20
> >=20
> > Works for 2.6.38, doesn't work for 2.6.39, 3.0.28, 3.4-rc1.
> >=20
> > I got this bisected to following commit:
> >=20
> > commit a1e9c9dd3383e6a1a762464ad604b1081774dbda
> > Author: Rob Herring <rob.herring@calxeda.com>
> > Date:   Wed Feb 23 15:37:59 2011 -0600
> >=20
> >     ipmi: convert OF driver to platform driver
> >    =20
> >     of_bus is deprecated in favor of the plain platform bus. This patch
> >     merges the ipmi OF driver with the existing platform driver.
> >    =20
> >     CONFIG_PPC_OF occurrances are removed or replaced with CONFIG_OF.
> >    =20
> >     Compile tested with and without CONFIG_OF. Tested OF probe and
> >     default probe cases.
> >    =20
> >     Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> >     Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> >=20
> > I wonder whether this is a bug, or I'm doing something wrong?
> >=20
> > Thanks in advance!
> >=20
> > with best regards
> >=20
> > nik
> >=20
> >=20
> > --=20
> > -------------------------------------
> > Ing. Nikola CIPRICH
> > LinuxBox.cz, s.r.o.
> > 28. rijna 168, 709 01 Ostrava
> >=20
> > tel.:   +420 596 603 142
> > fax:    +420 596 621 273
> > mobil:  +420 777 093 799
> >=20
> > www.linuxbox.cz
> >=20
> > mobil servis: +420 737 238 656
> > email servis: servis@linuxbox.cz
> > -------------------------------------
>=20
>=20
>=20
> --=20
> -------------------------------------
> Ing. Nikola CIPRICH
> LinuxBox.cz, s.r.o.
> 28. rijna 168, 709 01 Ostrava
>=20
> tel.:   +420 596 603 142
> fax:    +420 596 621 273
> mobil:  +420 777 093 799
>=20
> www.linuxbox.cz
>=20
> mobil servis: +420 737 238 656
> email servis: servis@linuxbox.cz
> -------------------------------------



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

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+VtwEACgkQ3xdJJrLygV7fhwCfYJqgaWEhPBHSrGqsIl5jKOAd
ccoAoJZ1bRg8irsgWGK6C3DiU2Bs9mcG
=0N7r
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
