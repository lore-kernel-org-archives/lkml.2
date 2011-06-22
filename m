Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab1FVSnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 14:43:11 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:59751 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758652Ab1FVSnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 14:43:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuANAN42Ak5bdWOb/2dsb2JhbABUoDxWhnaIcwLASYYtBI0chE6HfYgR
X-IronPort-AV: E=Sophos;i="4.65,407,1304287200"; 
   d="asc'?scan'208";a="775406411"
Message-ID: <4E0237CD.7060503@igalia.com>
Date: Wed, 22 Jun 2011 20:43:25 +0200
From: Carlos Alberto Lopez Perez <clopez@igalia.com>
Organization: Igalia S.L.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Icedove/3.1.10
MIME-Version: 1.0
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
CC: Daniel Oliveira Nascimento <don@syst.com.br>,
        Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/platform: classmate-laptop: Add cmpc_keys support
 for new classmate laptops
References: <1308685201-15541-1-git-send-email-clopez@igalia.com> <20110621195038.GC2724@nautilus.holoscopio.com> <4E00FE19.9000606@igalia.com> <20110621205004.GD2724@nautilus.holoscopio.com>
In-Reply-To: <20110621205004.GD2724@nautilus.holoscopio.com>
X-Enigmail-Version: 1.1.2
OpenPGP: id=E6ECAF78;
	url=http://pgp.rediris.es:11371/pks/lookup?op=get&search=0x3C7D8C94E6ECAF78
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4AAD10D1CE09A3B6E8469DF1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4AAD10D1CE09A3B6E8469DF1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/21/2011 10:50 PM, Thadeu Lima de Souza Cascardo wrote:
> On Tue, Jun 21, 2011 at 10:24:57PM +0200, Carlos Alberto Lopez Perez wr=
ote:
>> On 06/21/2011 09:50 PM, Thadeu Lima de Souza Cascardo wrote:
>>> On Tue, Jun 21, 2011 at 09:40:01PM +0200, Carlos Alberto Lopez Perez =
wrote:
>>>> The cmpc_keys ACPI driver from the classmate-laptop module fails to
>>>> recognize the device on the 4th generation of classmate laptops (Ato=
m N450)
>>>> because the device ID is named "FNBT0000" (uppercase N) on this lapt=
ops.
>>>>
>>>> MODALIAS=3Dacpi:FNBT0000:
>>>>
>>>> This patch makes the driver cmpc_keys recognize it:
>>>>
>>>> input: cmpc_keys as /devices/LNXSYSTM:00/device:00/FNBT0000:00/input=
/input18
>>>>
>>>> Signed-off-by: Carlos Alberto Lopez Perez <clopez@igalia.com>
>>>> ---
>>>>  drivers/platform/x86/classmate-laptop.c |    3 +++
>>>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platf=
orm/x86/classmate-laptop.c
>>>> index 94f93b6..03896cd 100644
>>>> --- a/drivers/platform/x86/classmate-laptop.c
>>>> +++ b/drivers/platform/x86/classmate-laptop.c
>>>> @@ -40,6 +40,7 @@ struct cmpc_accel {
>>>>  #define CMPC_TABLET_HID		"TBLT0000"
>>>>  #define CMPC_IPML_HID	"IPML200"
>>>>  #define CMPC_KEYS_HID		"FnBT0000"
>>>> +#define CMPC_KEYS_4GEN_HID	"FNBT0000"
>>>> =20
>>>>  /*
>>>>   * Generic input device code.
>>>> @@ -683,6 +684,7 @@ static int cmpc_keys_remove(struct acpi_device *=
acpi, int type)
>>>> =20
>>>>  static const struct acpi_device_id cmpc_keys_device_ids[] =3D {
>>>>  	{CMPC_KEYS_HID, 0},
>>>> +	{CMPC_KEYS_4GEN_HID, 0},
>>>>  	{"", 0}
>>>>  };
>>>> =20
>>>> @@ -754,6 +756,7 @@ static const struct acpi_device_id cmpc_device_i=
ds[] =3D {
>>>>  	{CMPC_TABLET_HID, 0},
>>>>  	{CMPC_IPML_HID, 0},
>>>>  	{CMPC_KEYS_HID, 0},
>>>> +	{CMPC_KEYS_4GEN_HID, 0},
>>>>  	{"", 0}
>>>>  };
>>>> =20
>>>> --=20
>>>> 1.7.5.3
>>>>
>>>
>>> Not-Acked-By: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>=

>>>
>>> Recent Linux versions have "upper-cased" the device names, because AC=
PI
>>> spec says devices must have upper-case letters. This is probably rela=
ted
>>> to this change, not because the device name has changed in recent
>>> versions of the device. So the correct fix would be to either revert
>>> this change in Linux or use only a single uppercase name for the devi=
ce.
>>>
>>> Thanks anyway for this report. I have received one report in private =
a
>>> while back, but was too lazy to discuss this on the list. Any pointer=
s
>>> on that? Easist way to go is to simply replace FnBT for FNBT.
>>>
>>> Regards,
>>> Cascardo.
>>
>> The ACPI specification [1] says the following:
>>
>> """
>> A valid PNP ID must be of the form =93AAA####=94 where A is an upperca=
se letter
>> and # is a hex digit.
>> A valid ACPI ID must be of the form =93ACPI####=94 where # is a hex di=
git.
>> """
>>
>> It don't says that the ACPI ID must be uppercase.
>>
>> I don't have an older generation of the classmate laptop to test if th=
e
>> ACPI ID is FnBT or FNBT, but I guess that if it was working until now,=
 is
>> because the older generations have FnBT instead of FNBT.
>>
>> However I just found a previous discussion about this issue on LKML [2=
] and
>> seems that the patch is included (commit: 72638f5).
>>
>> So... this means that the cmpc_keys module was not working for any
>> classmate laptop since ~2.6.29 ?
>>
>> If that is the case then replacing FnBT with FNBT will be fine.
>>
>> Thanks!
>>
>> Best regards!
>>
>=20
> Commit 77b23f712bc40a65160e7d02b045f1562bb43ff1 has changed this
> behaviour between 2.6.36 and 2.6.37. Could you try using 2.6.36 and see=

> if the device appears as FnBT? Also, you could try using acpidump and
> look at the decompiled DSDT so we can confirm whether it is FnBT or
> FNBT. Attached is a patch that, when comparing device and driver names
> for ACPI, will do it case-insensitivily.
>=20

You are right. The real ACPI ID of the device is FnBT0000 but the kernel
is uppercasing it.

# acpidump | grep -i -C1 FNBT0000
  0b30: 00 0a 00 0a 14 5b 82 34 46 4e 42 54 08 5f 48 49  .....[.4FNBT._HI=

  0b40: 44 0d 46 6e 42 54 30 30 30 30 00 08 5f 55 49 44  D.FnBT0000.._UID=

  0b50: 0a 00 08 46 4e 4c 4b 0a 01 14 11 46 4e 43 54 01  ...FNLK....FNCT.=



[*] In kernels <=3D  2.6.36 (Tested in 2.6.32 and 2.6.36) the ACPI ID is
registered as FnBT0000

# cat /sys/bus/acpi/devices/FnBT0000\:00/modalias
acpi:FnBT0000:

And the cmpc_keys driver of the classmate-laptop module recognized the
device as expected:

input: cmpc_keys as /devices/LNXSYSTM:00/LNXSYBUS:00/FnBT0000:00/input/in=
put5




[*] In kernels =3D> 2.6.37 (Tested in 2.6.37 and 2.6.39) the ACPI ID is
registered uppercased as FNBT0000 and therefore the cmpc_keys driver fail=
s
to recognize it.

# cat /sys/bus/acpi/devices/FNBT0000\:00/modalias
acpi:FNBT0000:



[*] With the kernel 2.6.39.1 and your patch for drivers/acpi/scan.c the
ACPI ID is registered uppercased as FNBT0000 *but* the cmpc_keys driver
recognizes it.

# cat /sys/bus/acpi/devices/FNBT0000\:00/modalias
acpi:FNBT0000:

input: cmpc_keys as /devices/LNXSYSTM:00/device:00/FNBT0000:00/input/inpu=
t5


[*] With the kernel 2.6.39.1 and the commit
77b23f712bc40a65160e7d02b045f1562bb43ff1 reverted happens the same that
with kernels <=3D 2.6.36 (the ACPI ID is registered as FnBT0000)


> So, we have three options here. Revert an ACPICA commit, apply a
> different matching code for ACPI bus in Linux or tell all drivers they
> must use an uppper-case name instead of the device name as it appears i=
n
> the ACPI tables.
>=20

Yes, we have three options here to solve the problem but I'm not sure whi=
ch
one is the correct.

At least I think it has been demonstrated that the ACPI ID is *not
required* to be uppercase by the ACPI specification as you can see in the=

acpidump of this device (FnBT0000).

So probably the "orthodox" way of solving this problem is reverting the
commit 77b23f712bc40a65160e7d02b045f1562bb43ff1 which is doing a wrong
assumption (its not true that the ACPI ID _must_ be uppercase).


Regards!


--------------enig4AAD10D1CE09A3B6E8469DF1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4CN80ACgkQPH2MlObsr3j41gCePq2rPqkclBpE8I837TDwiPxn
uowAoITcmo94Bz5b4iLxCr7RTU7aPgLU
=R4JX
-----END PGP SIGNATURE-----

--------------enig4AAD10D1CE09A3B6E8469DF1--
