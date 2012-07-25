Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2GYLOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:14:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57344 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab2GYLOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:14:16 -0400
Message-ID: <500FD4FA.7020904@canonical.com>
Date: Wed, 25 Jul 2012 13:14:02 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: x86/mm: Limit 2/4M size calculation to x86_32
References: <5000259D.9020303@canonical.com> <CAM_iQpVPzB69R1_4E_J5Yw=d1TncqHe0+dWEwOufQniNcpBVtg@mail.gmail.com> <500FCDF3.7080808@redhat.com>
In-Reply-To: <500FCDF3.7080808@redhat.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig767F28A8F1EC5CA9043C70A1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig767F28A8F1EC5CA9043C70A1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 25.07.2012 12:44, Avi Kivity wrote:
> On 07/24/2012 06:52 PM, Cong Wang wrote:
>=20
>>> From 6b679d1af20656929c0e829f29eed60b0a86a74f Mon Sep 17 00:00:00 200=
1
>>> From: Stefan Bader <stefan.bader@canonical.com>
>>> Date: Fri, 13 Jul 2012 15:16:33 +0200
>>> Subject: [PATCH] x86/mm: Limit 2/4M size calculation to x86_32
>>>
>>> commit 722bc6b (x86/mm: Fix the size calculation of mapping tables)
>>> did modify the extra space calculation for mapping tables in order
>>> to make up for the first 2/4M memory range using 4K pages.
>>> However this setup is only used when compiling for 32bit. On 64bit
>>> there is only the trailing area of 4K pages (which is already added).=

>>>
>>> The code was already adapted once for things went wrong on a 8TB
>>> machine (bd2753b x86/mm: Only add extra pages count for the first mem=
ory
>>> range during pre-allocation early page table space), but it looks a b=
it
>>> like it currently would overdo things for 64bit.
>>> I only noticed while bisecting for the reason I could not make a cras=
h
>>> kernel boot (which ended up on this patch).
>>>
>>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>>> Cc: WANG Cong <xiyou.wangcong@gmail.com>
>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>> Cc: Tejun Heo <tj@kernel.org>
>>
>> Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
>>
>> Sorry for that I was not aware of x86_64 is different with x86 in the
>> first 2/4M.
>=20
> Why would there be a difference?
>=20
> Shouldn't the IO space at 0xa0000-0x100000 be mapped with uncacheable
> attributes (or WC for VGA)?  If it's done later, it can be done later
> for both.
>=20
arch/x86/mm/init.c

unsigned long __init_refok init_memory_mapping(...
=2E..
ifdef CONFIG_X86_32
        /*
         * Don't use a large page for the first 2/4MB of memory
         * because there are often fixed size MTRRs in there
         * and overlapping MTRRs into large pages can cause
         * slowdowns.
         */




--------------enig767F28A8F1EC5CA9043C70A1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJQD9UDAAoJEOhnXe7L7s6jxbMQAIlTD9oR2RXTB7Rx38wZeFdN
DI+BuIUsCjZ/VjrCRfgchilPHLxKO7kboB+D+gDYElU3Ox4JZwIQbb99/sbrw65b
DRurBFJts+8ks6AwA6fMZNKwE1SuJIMdthIoJfkJLq53H5wlycP7wViXbs4tNU7h
o1u0f2kvYhskPLsM1MJQZTzyz6Qla2JYau61VlfTbIywA4cy+VAWfE5FBpafpXEL
fq99j1kse5lfDx+zWtyxbeoNT3gqJHi3DQHT3wkCvheZL/PZveTqBXIZpYZFY5gQ
O5P5ItZ7+CruU1CtDnjwU0DI7K9sCagGXMIOkypwMRGzwPJqdGQV5kEn2vqbiYGE
uNyMlXvLxEaUA6wU5oemkhMsSL6UPo8CV1Y7B7D2XEgpgXL5Pt8YK+WNXLp9baDX
zV/t9/j+lTQ3ve+2vm4bpxRJemjJrqgSMXafU5hAB87U7y9x/ycgh6gJ10ytzjj3
hCfkXVpM5IdCXnJyrFPNvLBiA96ZmGJHUN81JImeI8W1+xs0N2S64HIFrTW9FS0q
pp20JzDoKFL2/NyLYa5TbktzZqi+WjpDuSLEnqZ024T7EIkB9NlQ75fJtclSLqW1
9QazLhxcFzWD+IXIGqekuvBn1w2rRZqyAMzw70uvSr/GWGP3JRl6q+57JItG1+1p
YBa9zlM6ELNZzNeCyFFI
=PCYK
-----END PGP SIGNATURE-----

--------------enig767F28A8F1EC5CA9043C70A1--
