Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab0GJIMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 04:12:54 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:26562
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752430Ab0GJIMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 04:12:51 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zz1432N98dN936eM9371Pzz1202hzz15d4Rz32i2a8h34h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L5C1B4-01-7EA-02
X-M-MSG: 
Date: Sat, 10 Jul 2010 10:14:10 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "Petkov, Borislav" <Borislav.Petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: unable to handle kernel paging request at 40000000
 __alloc_memory_core_early+0x147/0x1d6
Message-ID: <20100710101410.4b7fb0f3@marah.osrc.amd.com>
In-Reply-To: <4C37C6EE.9060104@kernel.org>
References: <20100709145415.GC11199@aftab>
	<4C3773C4.1010609@kernel.org>
	<20100709215202.4be679a8@marah.osrc.amd.com>
	<4C37841F.4030500@kernel.org>
	<20100709224231.5736113b@marah.osrc.amd.com>
	<4C379DB6.3040605@kernel.org>
	<20100710015142.3f94b9dd@marah.osrc.amd.com>
	<4C37C6EE.9060104@kernel.org>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei =?UTF-8?B?TcO8bmNoZW47IEdlc2Now6RmdHNmw7xocmVyOg==?= Alberto Bozzo,
 Andrew Bowd; Sitz: Dornach, Gemeinde Aschheim, Landkreis =?UTF-8?B?TcO8?=
 =?UTF-8?B?bmNoZW47?= Registergericht =?UTF-8?B?TcO8bmNoZW4s?= HRB Nr. 43632
X-Mailer: Claws Mail 3.7.6cvs11 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/CXKaTU+sLgYfyTiGWEpU1A0";
	protocol="application/pgp-signature"
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CXKaTU+sLgYfyTiGWEpU1A0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 9 Jul 2010 21:03:42 -0400
Yinghai Lu <yinghai@kernel.org> wrote:

>On 07/09/2010 04:51 PM, Conny Seidel wrote:
>> On Fri, 9 Jul 2010 18:07:50 -0400
>> Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> On 07/09/2010 01:42 PM, Conny Seidel wrote:
>>>> sparse_early_mem_map_alloc: sparsemem memory map backing failed some
>>>> memory will not be available.
>>>
>>> please check
>>>
>> This still panics, see logfile for complete trace.
>>
>
>this one should fix the problem.
>
>Thanks
>
>Yinghai

Yes, Patch -v3 fixes the issue, thanks.

>[PATCH -v3] x86,nobootmem: make alloc_bootmem_node fall back to other node=
 when 32bit numa are used
>
>Borislav Petkov <borislav.petkov@amd.com> reported his 32bit numa has prob=
lem:
>
>[    0.000000] Reserving total of 4c00 pages for numa KVA remap
>[    0.000000] kva_start_pfn ~ 32800 max_low_pfn ~ 375fe
>[    0.000000] max_pfn =3D 238000
>[    0.000000] 8202MB HIGHMEM available.
>[    0.000000] 885MB LOWMEM available.
>[    0.000000]   mapped low ram: 0 - 375fe000
>[    0.000000]   low ram: 0 - 375fe000
>[    0.000000] alloc (nid=3D8 100000 - 7ee00000) (1000000 - ffffffff) 1000=
 1000 =3D> 34e7000
>[    0.000000] alloc (nid=3D8 100000 - 7ee00000) (1000000 - ffffffff) 200 =
40 =3D> 34c9d80
>[    0.000000] alloc (nid=3D0 100000 - 7ee00000) (1000000 - ffffffffffffff=
ff) 180 40 =3D> 34e6140
>[    0.000000] alloc (nid=3D1 80000000 - c7e60000) (1000000 - ffffffffffff=
ffff) 240 40 =3D> 80000000
>[    0.000000] BUG: unable to handle kernel paging request at 40000000
>[    0.000000] IP: [<c2c8cff1>] __alloc_memory_core_early+0x147/0x1d6
>[    0.000000] *pdpt =3D 0000000000000000 *pde =3D f000ff53f000ff00
>...
>[    0.000000] Call Trace:
>[    0.000000]  [<c2c8b4f8>] ? __alloc_bootmem_node+0x216/0x22f
>[    0.000000]  [<c2c90c9b>] ? sparse_early_usemaps_alloc_node+0x5a/0x10b
>[    0.000000]  [<c2c9149e>] ? sparse_init+0x1dc/0x499
>[    0.000000]  [<c2c79118>] ? paging_init+0x168/0x1df
>[    0.000000]  [<c2c780ff>] ? native_pagetable_setup_start+0xef/0x1bb
>
>looks like it allocate much high address for bootmem.
>
>try to cut limit with get_max_mapped()
>
>-v3: make alloc_bootmem_node could fallback to other node.
>     just like old alloc_bootmem_node did
>
>need this patch for 2.6.34 and 2.6.35
>
>Reported-by: Borislav Petkov <borislav.petkov@amd.com>
>Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>Cc: stable@kernel.org

Tested-by: Conny Seidel <conny.seidel@amd.com>

##
##################################################################
# Email : conny.seidel@amd.com            GnuPG-Key : 0xA6AB055D #
# Fingerprint: 17C4 5DB2 7C4C C1C7 1452 8148 F139 7C09 A6AB 055D #
##################################################################
# Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach      #
# General Managers: Alberto Bozzo, Andrew Bowd                   #
# Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen #
#               HRB Nr. 43632                                    #
##################################################################

--Sig_/CXKaTU+sLgYfyTiGWEpU1A0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkw4K9IACgkQ8Tl8CaarBV3ZRwCfTFLFosTSKPTZNDQwnNQhql77
8WUAn0aCp0Z75yj1Hvr13ZciXeYfRHa4
=CHjl
-----END PGP SIGNATURE-----

--Sig_/CXKaTU+sLgYfyTiGWEpU1A0--
