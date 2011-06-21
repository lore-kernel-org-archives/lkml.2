Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab1FUUuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:50:14 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:53178 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757527Ab1FUUuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:50:12 -0400
Date: Tue, 21 Jun 2011 17:50:05 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Carlos Alberto Lopez Perez <clopez@igalia.com>
Cc: Daniel Oliveira Nascimento <don@syst.com.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/platform: classmate-laptop: Add cmpc_keys
 support for new classmate laptops
Message-ID: <20110621205004.GD2724@nautilus.holoscopio.com>
References: <1308685201-15541-1-git-send-email-clopez@igalia.com>
 <20110621195038.GC2724@nautilus.holoscopio.com>
 <4E00FE19.9000606@igalia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VUDLurXRWRKrGuMn"
Content-Disposition: inline
In-Reply-To: <4E00FE19.9000606@igalia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VUDLurXRWRKrGuMn
Content-Type: multipart/mixed; boundary="GpGaEY17fSl8rd50"
Content-Disposition: inline


--GpGaEY17fSl8rd50
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 21, 2011 at 10:24:57PM +0200, Carlos Alberto Lopez Perez wrote:
> On 06/21/2011 09:50 PM, Thadeu Lima de Souza Cascardo wrote:
> > On Tue, Jun 21, 2011 at 09:40:01PM +0200, Carlos Alberto Lopez Perez wr=
ote:
> >> The cmpc_keys ACPI driver from the classmate-laptop module fails to
> >> recognize the device on the 4th generation of classmate laptops (Atom =
N450)
> >> because the device ID is named "FNBT0000" (uppercase N) on this laptop=
s.
> >>
> >> MODALIAS=3Dacpi:FNBT0000:
> >>
> >> This patch makes the driver cmpc_keys recognize it:
> >>
> >> input: cmpc_keys as /devices/LNXSYSTM:00/device:00/FNBT0000:00/input/i=
nput18
> >>
> >> Signed-off-by: Carlos Alberto Lopez Perez <clopez@igalia.com>
> >> ---
> >>  drivers/platform/x86/classmate-laptop.c |    3 +++
> >>  1 files changed, 3 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platfor=
m/x86/classmate-laptop.c
> >> index 94f93b6..03896cd 100644
> >> --- a/drivers/platform/x86/classmate-laptop.c
> >> +++ b/drivers/platform/x86/classmate-laptop.c
> >> @@ -40,6 +40,7 @@ struct cmpc_accel {
> >>  #define CMPC_TABLET_HID		"TBLT0000"
> >>  #define CMPC_IPML_HID	"IPML200"
> >>  #define CMPC_KEYS_HID		"FnBT0000"
> >> +#define CMPC_KEYS_4GEN_HID	"FNBT0000"
> >> =20
> >>  /*
> >>   * Generic input device code.
> >> @@ -683,6 +684,7 @@ static int cmpc_keys_remove(struct acpi_device *ac=
pi, int type)
> >> =20
> >>  static const struct acpi_device_id cmpc_keys_device_ids[] =3D {
> >>  	{CMPC_KEYS_HID, 0},
> >> +	{CMPC_KEYS_4GEN_HID, 0},
> >>  	{"", 0}
> >>  };
> >> =20
> >> @@ -754,6 +756,7 @@ static const struct acpi_device_id cmpc_device_ids=
[] =3D {
> >>  	{CMPC_TABLET_HID, 0},
> >>  	{CMPC_IPML_HID, 0},
> >>  	{CMPC_KEYS_HID, 0},
> >> +	{CMPC_KEYS_4GEN_HID, 0},
> >>  	{"", 0}
> >>  };
> >> =20
> >> --=20
> >> 1.7.5.3
> >>
> >=20
> > Not-Acked-By: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> >=20
> > Recent Linux versions have "upper-cased" the device names, because ACPI
> > spec says devices must have upper-case letters. This is probably related
> > to this change, not because the device name has changed in recent
> > versions of the device. So the correct fix would be to either revert
> > this change in Linux or use only a single uppercase name for the device.
> >=20
> > Thanks anyway for this report. I have received one report in private a
> > while back, but was too lazy to discuss this on the list. Any pointers
> > on that? Easist way to go is to simply replace FnBT for FNBT.
> >=20
> > Regards,
> > Cascardo.
>=20
> The ACPI specification [1] says the following:
>=20
> """
> A valid PNP ID must be of the form =E2=80=9CAAA####=E2=80=9D where A is a=
n uppercase letter
> and # is a hex digit.
> A valid ACPI ID must be of the form =E2=80=9CACPI####=E2=80=9D where # is=
 a hex digit.
> """
>=20
> It don't says that the ACPI ID must be uppercase.
>=20
> I don't have an older generation of the classmate laptop to test if the
> ACPI ID is FnBT or FNBT, but I guess that if it was working until now, is
> because the older generations have FnBT instead of FNBT.
>=20
> However I just found a previous discussion about this issue on LKML [2] a=
nd
> seems that the patch is included (commit: 72638f5).
>=20
> So... this means that the cmpc_keys module was not working for any
> classmate laptop since ~2.6.29 ?
>=20
> If that is the case then replacing FnBT with FNBT will be fine.
>=20
> Thanks!
>=20
> Best regards!
>=20

Commit 77b23f712bc40a65160e7d02b045f1562bb43ff1 has changed this
behaviour between 2.6.36 and 2.6.37. Could you try using 2.6.36 and see
if the device appears as FnBT? Also, you could try using acpidump and
look at the decompiled DSDT so we can confirm whether it is FnBT or
FNBT. Attached is a patch that, when comparing device and driver names
for ACPI, will do it case-insensitivily.

So, we have three options here. Revert an ACPICA commit, apply a
different matching code for ACPI bus in Linux or tell all drivers they
must use an uppper-case name instead of the device name as it appears in
the ACPI tables.

Regards,
Cascardo.

> -------
> [1] http://www.acpi.info/DOWNLOADS/ACPIspec40a.pdf
> [2] https://lkml.org/lkml/2009/1/21/238
>=20



--GpGaEY17fSl8rd50
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="match_acpi_devices_case_insensitive.patch"
Content-Transfer-Encoding: quoted-printable

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 29ef505..ca95d90 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -265,7 +265,7 @@ int acpi_match_device_ids(struct acpi_device *device,
=20
 	for (id =3D ids; id->id[0]; id++)
 		list_for_each_entry(hwid, &device->pnp.ids, list)
-			if (!strcmp((char *) id->id, hwid->id))
+			if (!strcasecmp((char *) id->id, hwid->id))
 				return 0;
=20
 	return -ENOENT;

--GpGaEY17fSl8rd50--

--VUDLurXRWRKrGuMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOAQP7AAoJEEWxSg7udFZI9twQAL+ONdiB0HvkiTEx7ClGhWQt
l69AVLUAJgddg5vo4RHF8k8lueYdNLKBpGDcMLQI8ggB4Gj3a8l8IpFjqQYp7Emn
TlYlm+m+y+rBHY5dxEoBgCaRybG1xzFzLAofJKZNNswiiNa7VL2s8lE1edjj4wuj
DdI+GkcZtxUhEqCu9wq0CZYObV3M3969qxSXogIJaBlhBrM9EH15RvbwMaTIL6za
KS7z+WGF+EbjHSLW4YxxxIe1gVBwRtxqZi7VTXHNIy1HWSjfV+BxYc6E8FaYW6vL
TmUncRT8wcqKhraDde4DRyZXe8BDiK2i3lx8wNcWyu0W0bNX9PKlvK38zdY30U5c
18an2pA+ASKMb37Cut7cpizM+ZDm6Jfb/bKNiW+bFweeEwcYcwY9e+brbO4pF8g1
zRj1xmrIJNSLge0PBo/YMRPTu8zyBPegrOMSYced1cI1dhLZem4UkVaNB05Tmg6V
pjdTe//f0TheY+cEF9nKi96n8xZ1isTw+KshlIAOW4JdILYMhTLfAVuOKlkOqZmQ
uTX0hbPYTZGNB8pgAFSdEFKlE7autxIcZHR7QuzKeVdfm25GxRvkusVXzRx0ubLQ
v/EyE6bLbDuMxuKTTNFZoGc2TY/ZuFMx2vuSz8AQIrtqA8lTzOi+NWh9znVFqYXg
FrYkp77FPb/LyVb8f1Zz
=v5Mt
-----END PGP SIGNATURE-----

--VUDLurXRWRKrGuMn--
