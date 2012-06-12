Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab2FLPbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:31:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab2FLPbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:31:13 -0400
Message-ID: <4FD760BC.7030409@canonical.com>
Date: Tue, 12 Jun 2012 17:31:08 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mahmood Naderan <nt_mahmood@yahoo.com>
CC: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: CPU MTRRs and linux kernel
References: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com> <20120612103954.GB10124@x1.osrc.amd.com> <1339508890.39685.YahooMailNeo@web111705.mail.gq1.yahoo.com> <4FD75C84.7020105@canonical.com> <1339514128.5023.YahooMailNeo@web111708.mail.gq1.yahoo.com>
In-Reply-To: <1339514128.5023.YahooMailNeo@web111708.mail.gq1.yahoo.com>
X-Enigmail-Version: 1.5pre
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig59F05AE2762A292B1075E11E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig59F05AE2762A292B1075E11E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12.06.2012 17:15, Mahmood Naderan wrote:
>> And the latest kernel is 2.6.32-41.89 by now...
>=20
> Sorry 3.4.2 ???

Not sure what this is intended to mean. From the kernel version you gave =
in the
initial post I take you are using a Ubuntu 10.04 server installation. And=
 the
latest kernel for that release is 2.6.32-41.89 (which should replace any =
older
kernel if you do updates).

-Stefan
> =20
>=20
> // Naderan *Mahmood;
>=20
>=20
> ----- Original Message -----
> From: Stefan Bader <stefan.bader@canonical.com>
> To: Mahmood Naderan <nt_mahmood@yahoo.com>
> Cc: Borislav Petkov <bp@alien8.de>; "linux-kernel@vger.kernel.org" <lin=
ux-kernel@vger.kernel.org>; Andreas Herrmann <andreas.herrmann3@amd.com>
> Sent: Tuesday, June 12, 2012 7:43 PM
> Subject: Re: CPU MTRRs and linux kernel
>=20
> On 12.06.2012 15:48, Mahmood Naderan wrote:
>> Thanks Borislav,
>> I want to know, should I upgrade to the latest kernel or it is possibl=
e to download the source of 2.6.32-24 from repository and modify cleanup.=
c and then recompile?
>>
> Just update to the latest kernel. 2.6.32-24.39 is way old. The fix Bori=
s
> mentioned was in 2.6.32-27.49. And the latest kernel is 2.6.32-41.89 by=
 now...
>=20
> -Stefan
>=20
>> ~MN
>>
>> ----- Original Message -----
>> From: Borislav Petkov <bp@alien8.de>
>> To: Mahmood Naderan <nt_mahmood@yahoo.com>
>> Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; And=
reas Herrmann <andreas.herrmann3@amd.com>
>> Sent: Tuesday, June 12, 2012 3:09 PM
>> Subject: Re: CPU MTRRs and linux kernel
>>
>> On Tue, Jun 12, 2012 at 02:37:40AM -0700, Mahmood Naderan wrote:
>>> Hi everybody,
>>> Abour rhis warnning in boot log:
>>>
>>> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 61952M=
B of RAM
>>>
>>>  =20
>>> I
>>>    searched a lot however didn't find a clear solution. Does AMD new =

>>> processors (62XX) have problems with new kernels or old kernels??
>>> Mine is:
>>>
>>> Linux n1 2.6.32-24-server #39-Ubuntu SMP Wed Jul 28 06:21:40 UTC 2010=
 x86_64 GNU/Linux
>>>
>>> Should I upgrade?
>>
>> Yes, fix is below and it got backported to -stable AFAICT but obviousl=
y
>> the ubuntus don't have it in the kernel you cite above.
>>
>>
>> commit 3fdbf004c1706480a7c7fac3c9d836fa6df20d7d
>> Author: Andreas Herrmann <andreas.herrmann3@amd.com>
>> Date:   Thu Sep 30 14:32:35 2010 +0200
>>
>>      x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all futur=
e AMD CPUs
>>    =20
>>      Instead of adapting the CPU family check in amd_special_default_m=
trr()
>>      for each new CPU family assume that all new AMD CPUs support the
>>      necessary bits in SYS_CFG MSR.
>>    =20
>>      Tom2Enabled is architectural (defined in APM Vol.2).
>>      Tom2ForceMemTypeWB is defined in all BKDGs starting with K8 NPT.
>>      In pre K8-NPT BKDG this bit is reserved (read as zero).
>>    =20
>>      W/o this adaption Linux would unnecessarily complain about bad MT=
RR
>>      settings on every new AMD CPU family, e.g.
>>    =20
>>      [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of me=
mory, losing 4863MB of RAM.
>>    =20
>>      Cc: stable@kernel.org # .32.x, .35.x
>>      Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
>>      LKML-Reference: <20100930123235.GB20545@loge.amd.com>
>>      Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>>
>> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/=
mtrr/cleanup.c
>> index c5f59d071425..ac140c7be396 100644
>> --- a/arch/x86/kernel/cpu/mtrr/cleanup.c
>> +++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
>> @@ -827,7 +827,7 @@ int __init amd_special_default_mtrr(void)
>>
>>          if (boot_cpu_data.x86_vendor !=3D X86_VENDOR_AMD)
>>                  return 0;
>> -       if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
>> +       if (boot_cpu_data.x86 < 0xf)
>>                  return 0;
>>          /* In case some hypervisor doesn't pass SYSCFG through: */
>>          if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--------------enig59F05AE2762A292B1075E11E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIbBAEBCgAGBQJP12C8AAoJEOhnXe7L7s6jQPcP+KThJxmtBzCnkbmN3uQLpcxV
p25VQVGmYrQ1hTfEPIyOOJ10X2iCbjyMGHsTtJtlsASX3vYgF70YCkXOeTU8X50l
8/oNOBrcU07xOrlEn+wkqU9z7zB6YIGJGhMxcgkTWuSXsYcHlskzzu09qm+9QtmR
+WsjBcJ2OHXCQpm8H+V/l+OAnUO0J2DkFe18j7F3QBFWXQ5bCSBMFFU3Q27bhf22
5OrhwPyOG+PUgo6spQSvOGZ1wzp0Uyqsf5uD6CCc/S3WqDoNwEOVkoIEtHO/weyS
tJHRjxlnQcP0oUOdIcngKx6H55S+l2Vr0pfWHtY+kmPzNphnul606LDvFKh36zKX
imXyZOvL/BVR5ZO8vhGLVyvf10eJ2BrfA05B2q5mmyqXTXApZV/7nwTvwH628Hou
5M3K5eXUAiiBfW+d26SBmkNeUWGFqLJilwAnyADdWv1/GeHbHrZtE15Fg+t6ivdb
XGYxDyh6ggEj1WHaR+0LmQh/JHlP37+SVFeYvuIEavRZbQXUTUgPOzwdd4x9qnQz
b70bPvHna9SYJUppHS1og+o+1k5V9HQxENKHsi4KXimJE2txyIVtFqIdAyzyp6gP
mHN2zjet5IkdXGzKki9zP6wd3y0+Woofej8jrHp3zmTbCs+PIMgWU1/6D3+umL4E
LjNawhgV/t7h7r+/oS0=
=mGs8
-----END PGP SIGNATURE-----

--------------enig59F05AE2762A292B1075E11E--
