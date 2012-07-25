Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2GYNY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:24:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756667Ab2GYNYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:24:54 -0400
Message-ID: <500FF3A1.6080809@canonical.com>
Date: Wed, 25 Jul 2012 15:24:49 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: x86/mm: Limit 2/4M size calculation to x86_32
References: <5000259D.9020303@canonical.com> <CAM_iQpVPzB69R1_4E_J5Yw=d1TncqHe0+dWEwOufQniNcpBVtg@mail.gmail.com> <500FCDF3.7080808@redhat.com> <500FD4FA.7020904@canonical.com> <500FE74C.4040907@redhat.com>
In-Reply-To: <500FE74C.4040907@redhat.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig90DDF3E61B22AF70BB28D766"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig90DDF3E61B22AF70BB28D766
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 25.07.2012 14:32, Avi Kivity wrote:
> On 07/25/2012 02:14 PM, Stefan Bader wrote:
>> On 25.07.2012 12:44, Avi Kivity wrote:
>>> On 07/24/2012 06:52 PM, Cong Wang wrote:
>>>
>>>>> From 6b679d1af20656929c0e829f29eed60b0a86a74f Mon Sep 17 00:00:00 2=
001
>>>>> From: Stefan Bader <stefan.bader@canonical.com>
>>>>> Date: Fri, 13 Jul 2012 15:16:33 +0200
>>>>> Subject: [PATCH] x86/mm: Limit 2/4M size calculation to x86_32
>>>>>
>>>>> commit 722bc6b (x86/mm: Fix the size calculation of mapping tables)=

>>>>> did modify the extra space calculation for mapping tables in order
>>>>> to make up for the first 2/4M memory range using 4K pages.
>>>>> However this setup is only used when compiling for 32bit. On 64bit
>>>>> there is only the trailing area of 4K pages (which is already added=
).
>>>>>
>>>>> The code was already adapted once for things went wrong on a 8TB
>>>>> machine (bd2753b x86/mm: Only add extra pages count for the first m=
emory
>>>>> range during pre-allocation early page table space), but it looks a=
 bit
>>>>> like it currently would overdo things for 64bit.
>>>>> I only noticed while bisecting for the reason I could not make a cr=
ash
>>>>> kernel boot (which ended up on this patch).
>>>>>
>>>>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>>>>> Cc: WANG Cong <xiyou.wangcong@gmail.com>
>>>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>>>> Cc: Tejun Heo <tj@kernel.org>
>>>>
>>>> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
>>>>
>>>> Sorry for that I was not aware of x86_64 is different with x86 in th=
e
>>>> first 2/4M.
>>>
>>> Why would there be a difference?
>>>
>>> Shouldn't the IO space at 0xa0000-0x100000 be mapped with uncacheable=

>>> attributes (or WC for VGA)?  If it's done later, it can be done later=

>>> for both.
>>>
>> arch/x86/mm/init.c
>>
>> unsigned long __init_refok init_memory_mapping(...
>> ...
>> ifdef CONFIG_X86_32
>>         /*
>>          * Don't use a large page for the first 2/4MB of memory
>>          * because there are often fixed size MTRRs in there
>>          * and overlapping MTRRs into large pages can cause
>>          * slowdowns.
>>          */
>>
>=20
> That's equally true for X86_64.
>=20
> Best would be to merge the MTRRs into PAT, but that might not work for =
SMM.
>=20
>=20
Ok, true. Not sure why this was restricted to 32bit when reconsidering. E=
xcept
if in 64bit it was assumed (or asserted) that the regions are aligned to =
2M...
But maybe this can be answered by someone knowing the details. I would no=
t mind
either way (have the first range with 4K pages in all cases or fixing the=

additional PTE allocation). Just as it is now it is inconsistent.



--------------enig90DDF3E61B22AF70BB28D766
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJQD/OhAAoJEOhnXe7L7s6jfCUP/jWjZlXV4SAG74NJ8N21z5hj
dAn3+fmxwYZOcVKvgp2vR2loMTV4+/oDSYuePtQBvi0QKAvyXDOzj4Z2mDeWRUYK
2j7sl3w18faxJim2SmbpY6mzWCJPi19rMS3jJVAvoh1/SGt0GAfqdDVbqZgWcGBY
gLqwlQf3UTGdQtv7TiAhZRffvWpjfDJS7W54LowH37L3MVrGqPw/+9W72QOV7gX3
YWvt4r94JNA6mORCmBVrIlXn89p1jKV0eB6FbnZVeg/d84l+za3vq/o+NeSNcDkQ
Bn8Xabxs4PJpn9jZofPlIfZilefUnY0NOTCz064Gyn+JbYb1Vd7lSjtl4JQfGXH4
mrXw75Qug85/s/HRVU9bHTtALhMba6ucZ2EIjQGZmw8JD1tsxcSWcaxoShFePxZU
Kag9MSn3KAhK8pzSzPdVRmOOvsVCZZLjur5HC1PKnHKQahHD61yJifPtwn/cIgp6
dKsHqcsh2efotTofL86WlzwMuKe4TiG9saOMY/SWupPOe0ONjplrAJ67CUhOdif/
2YA/vPCSuqB44FuwpUWXLRa3NChyHugUTJ5JTLsAWm8rwiPTMvzq2SehuCnH3eBt
nCKiFnpacUM2TDVHrahXZ4I/LAOqJHitk9oQQdL+x0n9kRXpHjUI4CTtJat6xd/K
mnjmUUmYGZPMpr7n9fEQ
=pXp/
-----END PGP SIGNATURE-----

--------------enig90DDF3E61B22AF70BB28D766--
