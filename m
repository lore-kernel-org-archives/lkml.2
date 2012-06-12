Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab2FLPNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 11:13:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52087 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab2FLPNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 11:13:22 -0400
Message-ID: <4FD75C84.7020105@canonical.com>
Date: Tue, 12 Jun 2012 17:13:08 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mahmood Naderan <nt_mahmood@yahoo.com>
CC: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: CPU MTRRs and linux kernel
References: <1339493860.10145.YahooMailNeo@web111708.mail.gq1.yahoo.com> <20120612103954.GB10124@x1.osrc.amd.com> <1339508890.39685.YahooMailNeo@web111705.mail.gq1.yahoo.com>
In-Reply-To: <1339508890.39685.YahooMailNeo@web111705.mail.gq1.yahoo.com>
X-Enigmail-Version: 1.5pre
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig68729D020F2947AB403F2414"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig68729D020F2947AB403F2414
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12.06.2012 15:48, Mahmood Naderan wrote:
> Thanks Borislav,
> I want to know, should I upgrade to the latest kernel or it is possible=
 to download the source of 2.6.32-24 from repository and modify cleanup.c=
 and then recompile?
>=20
Just update to the latest kernel. 2.6.32-24.39 is way old. The fix Boris
mentioned was in 2.6.32-27.49. And the latest kernel is 2.6.32-41.89 by n=
ow...

-Stefan

> ~MN
>=20
> ----- Original Message -----
> From: Borislav Petkov <bp@alien8.de>
> To: Mahmood Naderan <nt_mahmood@yahoo.com>
> Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; Andr=
eas Herrmann <andreas.herrmann3@amd.com>
> Sent: Tuesday, June 12, 2012 3:09 PM
> Subject: Re: CPU MTRRs and linux kernel
>=20
> On Tue, Jun 12, 2012 at 02:37:40AM -0700, Mahmood Naderan wrote:
>> Hi everybody,
>> Abour rhis warnning in boot log:
>>
>> WARNING: BIOS bug: CPU MTRRs don't cover all of memory, losing 61952MB=
 of RAM
>>
>> =20
>> I
>>   searched a lot however didn't find a clear solution. Does AMD new=20
>> processors (62XX) have problems with new kernels or old kernels??
>> Mine is:
>>
>> Linux n1 2.6.32-24-server #39-Ubuntu SMP Wed Jul 28 06:21:40 UTC 2010 =
x86_64 GNU/Linux
>>
>> Should I upgrade?
>=20
> Yes, fix is below and it got backported to -stable AFAICT but obviously=

> the ubuntus don't have it in the kernel you cite above.
>=20
>=20
> commit 3fdbf004c1706480a7c7fac3c9d836fa6df20d7d
> Author: Andreas Herrmann <andreas.herrmann3@amd.com>
> Date:   Thu Sep 30 14:32:35 2010 +0200
>=20
>     x86, mtrr: Assume SYS_CFG[Tom2ForceMemTypeWB] exists on all future =
AMD CPUs
>    =20
>     Instead of adapting the CPU family check in amd_special_default_mtr=
r()
>     for each new CPU family assume that all new AMD CPUs support the
>     necessary bits in SYS_CFG MSR.
>    =20
>     Tom2Enabled is architectural (defined in APM Vol.2).
>     Tom2ForceMemTypeWB is defined in all BKDGs starting with K8 NPT.
>     In pre K8-NPT BKDG this bit is reserved (read as zero).
>    =20
>     W/o this adaption Linux would unnecessarily complain about bad MTRR=

>     settings on every new AMD CPU family, e.g.
>    =20
>     [    0.000000] WARNING: BIOS bug: CPU MTRRs don't cover all of memo=
ry, losing 4863MB of RAM.
>    =20
>     Cc: stable@kernel.org # .32.x, .35.x
>     Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
>     LKML-Reference: <20100930123235.GB20545@loge.amd.com>
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>=20
> diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/m=
trr/cleanup.c
> index c5f59d071425..ac140c7be396 100644
> --- a/arch/x86/kernel/cpu/mtrr/cleanup.c
> +++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
> @@ -827,7 +827,7 @@ int __init amd_special_default_mtrr(void)
>=20
>         if (boot_cpu_data.x86_vendor !=3D X86_VENDOR_AMD)
>                 return 0;
> -       if (boot_cpu_data.x86 < 0xf || boot_cpu_data.x86 > 0x11)
> +       if (boot_cpu_data.x86 < 0xf)
>                 return 0;
>         /* In case some hypervisor doesn't pass SYSCFG through: */
>         if (rdmsr_safe(MSR_K8_SYSCFG, &l, &h) < 0)
>=20



--------------enig68729D020F2947AB403F2414
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJP11yMAAoJEOhnXe7L7s6jZwQP/241DaN5bhzxYS4dhtIR5dCh
vZkpw7WPTc4omil/p+avwT7UYaTj2nVxPc9HDcdlYoJF/uBQG1J1pIIYZCQwNynT
FaVMGuWpoxPlJ9hdN2k5hNQs1bWIg3g+HfYeRWuezvR31zzIfpkv6zXZ2I1ha3p1
bvTJOscMXoR+J/VSl1tCLYwUeThtDZdQLcsHjH1bMBiX6+3bmTUVTa8CZZd8pR05
p9Bbeb1A1bx7JoLgxaY6DIZwktiFi7c4hkVSHhOgEg8DT61RtlWe0oauyXSazufy
P1qqOcFOH13/WKxb3HvxnNPvogAOihcG9PYnyny3SKow5y5HEH0/yfTYIj0iQxKd
bGEDYIFmTwv3CeKFDnzziR++8rDuCscDzQ1QmVM1VnqSPfipdWpg3zRUTpwo0KP+
N+WkrcygbCAaOMDgIZlfKNV4ZggX/XJZJnWL1QQkWALRC3QvPZ3pHSUhbntcglrl
W1cpy4mFpklvJHnh61cv9m8UW/Gk8+123rRd+sW0450bakopnTgtsGBtkoeUOV5f
jqxJkg0qqmnsI9JUpJvnI909D6ixCZt/NdJKTkon4GqeBl4mBzJeoQQeZPHe4C6E
cJLX880lSe7QNrZ9e1pV8YMG8eYSIlMd2dyLXMXB2VHqAwzN+qv6h40HS2K/dah5
DrWMreJSCJjlmVWj7ERl
=+Sog
-----END PGP SIGNATURE-----

--------------enig68729D020F2947AB403F2414--
