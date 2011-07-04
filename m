Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1GDOIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:08:07 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:51197 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab1GDOIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:08:04 -0400
Date: Mon, 4 Jul 2011 11:07:55 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Carlos Alberto Lopez Perez <clopez@igalia.com>
Cc: Daniel Oliveira Nascimento <don@syst.com.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        lenb@kernel.org
Subject: Re: [PATCH 1/1] x86/platform: classmate-laptop: Add cmpc_keys
 support for new classmate laptops
Message-ID: <20110704140755.GB2967@nautilus.holoscopio.com>
References: <1308685201-15541-1-git-send-email-clopez@igalia.com>
 <20110621195038.GC2724@nautilus.holoscopio.com>
 <4E00FE19.9000606@igalia.com>
 <20110621205004.GD2724@nautilus.holoscopio.com>
 <4E0237CD.7060503@igalia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <4E0237CD.7060503@igalia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2011 at 08:43:25PM +0200, Carlos Alberto Lopez Perez wrote:
> On 06/21/2011 10:50 PM, Thadeu Lima de Souza Cascardo wrote:
> > On Tue, Jun 21, 2011 at 10:24:57PM +0200, Carlos Alberto Lopez Perez wr=
ote:
> >> On 06/21/2011 09:50 PM, Thadeu Lima de Souza Cascardo wrote:
> >>> On Tue, Jun 21, 2011 at 09:40:01PM +0200, Carlos Alberto Lopez Perez =
wrote:
> >>>> The cmpc_keys ACPI driver from the classmate-laptop module fails to
> >>>> recognize the device on the 4th generation of classmate laptops (Ato=
m N450)
> >>>> because the device ID is named "FNBT0000" (uppercase N) on this lapt=
ops.
> >>>>
> >>>> MODALIAS=3Dacpi:FNBT0000:
> >>>>
> >>>> This patch makes the driver cmpc_keys recognize it:
> >>>>
> >>>> input: cmpc_keys as /devices/LNXSYSTM:00/device:00/FNBT0000:00/input=
/input18
> >>>>
> >>>> Signed-off-by: Carlos Alberto Lopez Perez <clopez@igalia.com>
> >>>> ---
> >>>>  drivers/platform/x86/classmate-laptop.c |    3 +++
> >>>>  1 files changed, 3 insertions(+), 0 deletions(-)
> >>>>
> >>>> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platf=
orm/x86/classmate-laptop.c
> >>>> index 94f93b6..03896cd 100644
> >>>> --- a/drivers/platform/x86/classmate-laptop.c
> >>>> +++ b/drivers/platform/x86/classmate-laptop.c
> >>>> @@ -40,6 +40,7 @@ struct cmpc_accel {
> >>>>  #define CMPC_TABLET_HID		"TBLT0000"
> >>>>  #define CMPC_IPML_HID	"IPML200"
> >>>>  #define CMPC_KEYS_HID		"FnBT0000"
> >>>> +#define CMPC_KEYS_4GEN_HID	"FNBT0000"
> >>>> =20
> >>>>  /*
> >>>>   * Generic input device code.
> >>>> @@ -683,6 +684,7 @@ static int cmpc_keys_remove(struct acpi_device *=
acpi, int type)
> >>>> =20
> >>>>  static const struct acpi_device_id cmpc_keys_device_ids[] =3D {
> >>>>  	{CMPC_KEYS_HID, 0},
> >>>> +	{CMPC_KEYS_4GEN_HID, 0},
> >>>>  	{"", 0}
> >>>>  };
> >>>> =20
> >>>> @@ -754,6 +756,7 @@ static const struct acpi_device_id cmpc_device_i=
ds[] =3D {
> >>>>  	{CMPC_TABLET_HID, 0},
> >>>>  	{CMPC_IPML_HID, 0},
> >>>>  	{CMPC_KEYS_HID, 0},
> >>>> +	{CMPC_KEYS_4GEN_HID, 0},
> >>>>  	{"", 0}
> >>>>  };
> >>>> =20
> >>>> --=20
> >>>> 1.7.5.3
> >>>>
> >>>
> >>> Not-Acked-By: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> >>>
> >>> Recent Linux versions have "upper-cased" the device names, because AC=
PI
> >>> spec says devices must have upper-case letters. This is probably rela=
ted
> >>> to this change, not because the device name has changed in recent
> >>> versions of the device. So the correct fix would be to either revert
> >>> this change in Linux or use only a single uppercase name for the devi=
ce.
> >>>
> >>> Thanks anyway for this report. I have received one report in private a
> >>> while back, but was too lazy to discuss this on the list. Any pointers
> >>> on that? Easist way to go is to simply replace FnBT for FNBT.
> >>>
> >>> Regards,
> >>> Cascardo.
> >>
> >> The ACPI specification [1] says the following:
> >>
> >> """
> >> A valid PNP ID must be of the form =E2=80=9CAAA####=E2=80=9D where A i=
s an uppercase letter
> >> and # is a hex digit.
> >> A valid ACPI ID must be of the form =E2=80=9CACPI####=E2=80=9D where #=
 is a hex digit.
> >> """
> >>
> >> It don't says that the ACPI ID must be uppercase.
> >>
> >> I don't have an older generation of the classmate laptop to test if the
> >> ACPI ID is FnBT or FNBT, but I guess that if it was working until now,=
 is
> >> because the older generations have FnBT instead of FNBT.
> >>
> >> However I just found a previous discussion about this issue on LKML [2=
] and
> >> seems that the patch is included (commit: 72638f5).
> >>
> >> So... this means that the cmpc_keys module was not working for any
> >> classmate laptop since ~2.6.29 ?
> >>
> >> If that is the case then replacing FnBT with FNBT will be fine.
> >>
> >> Thanks!
> >>
> >> Best regards!
> >>
> >=20
> > Commit 77b23f712bc40a65160e7d02b045f1562bb43ff1 has changed this
> > behaviour between 2.6.36 and 2.6.37. Could you try using 2.6.36 and see
> > if the device appears as FnBT? Also, you could try using acpidump and
> > look at the decompiled DSDT so we can confirm whether it is FnBT or
> > FNBT. Attached is a patch that, when comparing device and driver names
> > for ACPI, will do it case-insensitivily.
> >=20
>=20
> You are right. The real ACPI ID of the device is FnBT0000 but the kernel
> is uppercasing it.
>=20
> # acpidump | grep -i -C1 FNBT0000
>   0b30: 00 0a 00 0a 14 5b 82 34 46 4e 42 54 08 5f 48 49  .....[.4FNBT._HI
>   0b40: 44 0d 46 6e 42 54 30 30 30 30 00 08 5f 55 49 44  D.FnBT0000.._UID
>   0b50: 0a 00 08 46 4e 4c 4b 0a 01 14 11 46 4e 43 54 01  ...FNLK....FNCT.
>=20
>=20
> [*] In kernels <=3D  2.6.36 (Tested in 2.6.32 and 2.6.36) the ACPI ID is
> registered as FnBT0000
>=20
> # cat /sys/bus/acpi/devices/FnBT0000\:00/modalias
> acpi:FnBT0000:
>=20
> And the cmpc_keys driver of the classmate-laptop module recognized the
> device as expected:
>=20
> input: cmpc_keys as /devices/LNXSYSTM:00/LNXSYBUS:00/FnBT0000:00/input/in=
put5
>=20
>=20
>=20
>=20
> [*] In kernels =3D> 2.6.37 (Tested in 2.6.37 and 2.6.39) the ACPI ID is
> registered uppercased as FNBT0000 and therefore the cmpc_keys driver fails
> to recognize it.
>=20
> # cat /sys/bus/acpi/devices/FNBT0000\:00/modalias
> acpi:FNBT0000:
>=20
>=20
>=20
> [*] With the kernel 2.6.39.1 and your patch for drivers/acpi/scan.c the
> ACPI ID is registered uppercased as FNBT0000 *but* the cmpc_keys driver
> recognizes it.
>=20
> # cat /sys/bus/acpi/devices/FNBT0000\:00/modalias
> acpi:FNBT0000:
>=20
> input: cmpc_keys as /devices/LNXSYSTM:00/device:00/FNBT0000:00/input/inpu=
t5
>=20
>=20
> [*] With the kernel 2.6.39.1 and the commit
> 77b23f712bc40a65160e7d02b045f1562bb43ff1 reverted happens the same that
> with kernels <=3D 2.6.36 (the ACPI ID is registered as FnBT0000)
>=20
>=20
> > So, we have three options here. Revert an ACPICA commit, apply a
> > different matching code for ACPI bus in Linux or tell all drivers they
> > must use an uppper-case name instead of the device name as it appears in
> > the ACPI tables.
> >=20
>=20
> Yes, we have three options here to solve the problem but I'm not sure whi=
ch
> one is the correct.
>=20
> At least I think it has been demonstrated that the ACPI ID is *not
> required* to be uppercase by the ACPI specification as you can see in the
> acpidump of this device (FnBT0000).
>=20
> So probably the "orthodox" way of solving this problem is reverting the
> commit 77b23f712bc40a65160e7d02b045f1562bb43ff1 which is doing a wrong
> assumption (its not true that the ACPI ID _must_ be uppercase).
>=20
>=20
> Regards!
>=20

I am copying the acpi list and Len Brown to see if they can tell us
which one should be the right solution:

1) reverting the patch in acpica that puts all names in uppercase
2) using a case-insensitive match in acpi bus driver
3) using uppercase name in classmate-laptop driver

Regards,
Cascardo.

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOEck6AAoJEEWxSg7udFZIycsP/iNmKy2ccBYVdbRx2cLMh8pY
96Hhlj/foHROPc7IW8DRNQ2z8mA9cpytUle0bKBcYqORBxNWURz3y+r1gzc+/Ig0
/D3IjUulJB0g0cVluUp4jLzWTzocQCzO4W6WeAOBu/7sILXJDkgxr7kcHJNnqyDu
gA60fRQZEQWNi0UGRHZYoBWLiKzs3bpPmhy3kaeIe/+Ldjsc30dd6v/fgUorK0tv
3II3TJviKW8Ue8gB1dXg2PV7ovOGuSMHHKvHthtisKnh49tIeTHgazof6qxRelMG
/USil/Cxx4TLu2CmCoCZAES7RSmsLpFTBUZOSJF/yTKRoP3Y7Z/6VgqdlJUXKBB6
dsEruAKZm7HHGiiMUXrgkW/kxUqBndzTYVj79ysrEhuoPwwzzPKgH8DR1M7H59ZE
QNSgO0sH9mrhmnqudLVpLfYkZLLuCtCt+v7nsbVkrp2LPywnAtliGqyw0SkXDo7I
sabLXgTCzXz1TLY5ukkCy/rmYIY0jt6p8MsshghiZOa9BrFMKjTNEqM0UbZuS4gD
63Xxxov7hsDsaDFPL1skQnNlgz0nYIge/LYGDg1Rxfhj4wLNduwKv4KkhFQTN3+m
Yt9rzeHg+xaQ98MNBFJHxtOYQhv5k/DOZMusYd8Har4JXQGLZSVsotA4T5+OWwS7
ISrnrsEoE5HsSEaW2OIu
=cFhK
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
