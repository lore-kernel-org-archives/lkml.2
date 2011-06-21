Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1FUUYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 16:24:41 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:33513 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab1FUUYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 16:24:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0MABf9AE5bdWOb/2dsb2JhbABUoClWhnOIdb9VhioEjRiETod5iA8
X-IronPort-AV: E=Sophos;i="4.65,402,1304287200"; 
   d="asc'?scan'208";a="377371109"
Message-ID: <4E00FE19.9000606@igalia.com>
Date: Tue, 21 Jun 2011 22:24:57 +0200
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
References: <1308685201-15541-1-git-send-email-clopez@igalia.com> <20110621195038.GC2724@nautilus.holoscopio.com>
In-Reply-To: <20110621195038.GC2724@nautilus.holoscopio.com>
X-Enigmail-Version: 1.1.2
OpenPGP: id=E6ECAF78;
	url=http://pgp.rediris.es:11371/pks/lookup?op=get&search=0x3C7D8C94E6ECAF78
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig22AF3FACC26E6FE9ABDB57CB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig22AF3FACC26E6FE9ABDB57CB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/21/2011 09:50 PM, Thadeu Lima de Souza Cascardo wrote:
> On Tue, Jun 21, 2011 at 09:40:01PM +0200, Carlos Alberto Lopez Perez wr=
ote:
>> The cmpc_keys ACPI driver from the classmate-laptop module fails to
>> recognize the device on the 4th generation of classmate laptops (Atom =
N450)
>> because the device ID is named "FNBT0000" (uppercase N) on this laptop=
s.
>>
>> MODALIAS=3Dacpi:FNBT0000:
>>
>> This patch makes the driver cmpc_keys recognize it:
>>
>> input: cmpc_keys as /devices/LNXSYSTM:00/device:00/FNBT0000:00/input/i=
nput18
>>
>> Signed-off-by: Carlos Alberto Lopez Perez <clopez@igalia.com>
>> ---
>>  drivers/platform/x86/classmate-laptop.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platfor=
m/x86/classmate-laptop.c
>> index 94f93b6..03896cd 100644
>> --- a/drivers/platform/x86/classmate-laptop.c
>> +++ b/drivers/platform/x86/classmate-laptop.c
>> @@ -40,6 +40,7 @@ struct cmpc_accel {
>>  #define CMPC_TABLET_HID		"TBLT0000"
>>  #define CMPC_IPML_HID	"IPML200"
>>  #define CMPC_KEYS_HID		"FnBT0000"
>> +#define CMPC_KEYS_4GEN_HID	"FNBT0000"
>> =20
>>  /*
>>   * Generic input device code.
>> @@ -683,6 +684,7 @@ static int cmpc_keys_remove(struct acpi_device *ac=
pi, int type)
>> =20
>>  static const struct acpi_device_id cmpc_keys_device_ids[] =3D {
>>  	{CMPC_KEYS_HID, 0},
>> +	{CMPC_KEYS_4GEN_HID, 0},
>>  	{"", 0}
>>  };
>> =20
>> @@ -754,6 +756,7 @@ static const struct acpi_device_id cmpc_device_ids=
[] =3D {
>>  	{CMPC_TABLET_HID, 0},
>>  	{CMPC_IPML_HID, 0},
>>  	{CMPC_KEYS_HID, 0},
>> +	{CMPC_KEYS_4GEN_HID, 0},
>>  	{"", 0}
>>  };
>> =20
>> --=20
>> 1.7.5.3
>>
>=20
> Not-Acked-By: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
>=20
> Recent Linux versions have "upper-cased" the device names, because ACPI=

> spec says devices must have upper-case letters. This is probably relate=
d
> to this change, not because the device name has changed in recent
> versions of the device. So the correct fix would be to either revert
> this change in Linux or use only a single uppercase name for the device=
=2E
>=20
> Thanks anyway for this report. I have received one report in private a
> while back, but was too lazy to discuss this on the list. Any pointers
> on that? Easist way to go is to simply replace FnBT for FNBT.
>=20
> Regards,
> Cascardo.

The ACPI specification [1] says the following:

"""
A valid PNP ID must be of the form =93AAA####=94 where A is an uppercase =
letter
and # is a hex digit.
A valid ACPI ID must be of the form =93ACPI####=94 where # is a hex digit=
=2E
"""

It don't says that the ACPI ID must be uppercase.

I don't have an older generation of the classmate laptop to test if the
ACPI ID is FnBT or FNBT, but I guess that if it was working until now, is=

because the older generations have FnBT instead of FNBT.

However I just found a previous discussion about this issue on LKML [2] a=
nd
seems that the patch is included (commit: 72638f5).

So... this means that the cmpc_keys module was not working for any
classmate laptop since ~2.6.29 ?

If that is the case then replacing FnBT with FNBT will be fine.

Thanks!

Best regards!

-------
[1] http://www.acpi.info/DOWNLOADS/ACPIspec40a.pdf
[2] https://lkml.org/lkml/2009/1/21/238


--------------enig22AF3FACC26E6FE9ABDB57CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4A/hkACgkQPH2MlObsr3gUSACfbFWLKWVRxLNp3XFL6FZRQFX1
4HMAn1sjxWDFpIrsY4PUsaQ2JY+0obZ8
=N8n4
-----END PGP SIGNATURE-----

--------------enig22AF3FACC26E6FE9ABDB57CB--
