Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab0GIUhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:37:32 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18364 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab0GIUha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:37:30 -0400
X-SpamScore: -35
X-BigFish: VPS-35(zz1411I1432N98dN936eM9371Pzz1202hzz15d4Rz32i2a8h34h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L5B5AD-02-B10-02
X-M-MSG: 
Date: Fri, 9 Jul 2010 22:42:31 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "Petkov, Borislav" <Borislav.Petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: unable to handle kernel paging request at 40000000
 __alloc_memory_core_early+0x147/0x1d6
Message-ID: <20100709224231.5736113b@marah.osrc.amd.com>
In-Reply-To: <4C37841F.4030500@kernel.org>
References: <20100709145415.GC11199@aftab>
	<4C3773C4.1010609@kernel.org>
	<20100709215202.4be679a8@marah.osrc.amd.com>
	<4C37841F.4030500@kernel.org>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei =?UTF-8?B?TcO8bmNoZW47IEdlc2Now6RmdHNmw7xocmVyOg==?= Alberto Bozzo,
 Andrew Bowd; Sitz: Dornach, Gemeinde Aschheim, Landkreis =?UTF-8?B?TcO8?=
 =?UTF-8?B?bmNoZW47?= Registergericht =?UTF-8?B?TcO8bmNoZW4s?= HRB Nr. 43632
X-Mailer: Claws Mail 3.7.6cvs11 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/_k6FvwO+ePWjl2o8rWak56G";
	protocol="application/pgp-signature"
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_k6FvwO+ePWjl2o8rWak56G
Content-Type: multipart/mixed; boundary="MP_/0B0X3qtuhUMakY+wpT9r_q5"

--MP_/0B0X3qtuhUMakY+wpT9r_q5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 9 Jul 2010 16:18:39 -0400
Yinghai Lu <yinghai@kernel.org> wrote:

>On 07/09/2010 12:52 PM, Conny Seidel wrote:
>> Hi,
>>
>> On Fri, 9 Jul 2010 15:08:52 -0400
>> Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> On 07/09/2010 07:54 AM, Borislav Petkov wrote:
>>>> Hi,
>>>>
>>>> this is something we're getting during testing on one of our boxes
>>>> here, a dual socket Magny-Cours machine. It is oopsing on the addr
>>>> variable in __alloc_memory_core_early() after converting it to a
>>>> virtual address in order to clear the mem region at it. I've
>>>> removed the "#if 0.. #endif" around the printk which dumps the
>>>> ranges in the early node map for more info.
>>>>
>>>> It's latest -git, 32bit build, config is attached.
>>>>
>>>
>>> can not duplicate on all my setup.
>>>
>>> but look at the code there is limit problem with 32 bit...
>>>
>>> please check if it will fix the problem.
>>>
>>> and we will need to rebase early_res to memblock patchset.
>>>
>>> Thanks
>>>
>>> Yinghai Lu
>>>
>>
>> I'm sorry but the patch isn't working.

<snip>

>can you send out boot log from start?
>
>YH
>

Sure. see the complete log in the attached file.

Conny

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

--MP_/0B0X3qtuhUMakY+wpT9r_q5
Content-Type: text/x-log
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=boot.log

root (hd0,1)
 Filesystem type is ext2fs, partition type 0x83
kernel /boot/vmlinuz-2.6.35-rc4+ root=3D/dev/sda2 console=3DttyS0,115200 ip=
=3Ddhcp ar
temis_host=3Dbancroft earlyprintk=3Dserial,ttyS0,115200
   [Linux-bzImage, setup=3D0x3400, size=3D0xff6e80]

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-rc4+ (root@hernando) (gcc version 4.1.2=
 20070115 (SUSE Linux)) #3 SMP Fri Jul 9 22:24:53 CEST 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000088c00 (usable)
[    0.000000]  BIOS-e820: 0000000000088c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000cc000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000c7e60000 (usable)
[    0.000000]  BIOS-e820: 00000000c7e60000 - 00000000c7e6b000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000c7e6b000 - 00000000c7e6d000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000c7e6d000 - 00000000c7eff000 (reserved)
[    0.000000]  BIOS-e820: 00000000c7f00000 - 00000000c8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] bootconsole [earlyser0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working aro=
und it.
[    0.000000] last_pfn =3D 0x238000 max_arch_pfn =3D 0x1000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x701060007=
0106
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000088c00 (usable)
[    0.000000]  modified: 0000000000088c00 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000cc000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000c7e60000 (usable)
[    0.000000]  modified: 00000000c7e60000 - 00000000c7e6b000 (ACPI data)
[    0.000000]  modified: 00000000c7e6b000 - 00000000c7e6d000 (ACPI NVS)
[    0.000000]  modified: 00000000c7e6d000 - 00000000c7eff000 (reserved)
[    0.000000]  modified: 00000000c7f00000 - 00000000c8000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000238000000 (usable)
[    0.000000] found SMP MP-table at [c00f72a0] f72a0
[    0.000000] init_memory_mapping: 0000000000000000-00000000375fe000
[    0.000000] ACPI: RSDP 000f7220 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT c7e60915 0009C (v01 PTLTD  ? XSDT   06040000  LTP=
 00000000)
[    0.000000] ACPI: FACP c7e66d6a 000F4 (v03 AMD    Dinar    06040000 AMD =
 000F4240)
[    0.000000] ACPI: DSDT c7e609b1 063B9 (v02    AMD    SB700 06040000 MSFT=
 03000000)
[    0.000000] ACPI: FACS c7e6cfc0 00040
[    0.000000] ACPI: TCPA c7e66ed2 00032 (v02 AMD             06040000 PTEC=
 00000000)
[    0.000000] ACPI: IVRS c7e66f04 000A8 (v01  AMD     RD890S 06040000 AMD =
 00000000)
[    0.000000] ACPI: EINJ c7e66fac 001B0 (v01 PTL    WHEAPTL  06040000 PTL =
 00000001)
[    0.000000] ACPI: HEST c7e6715c 002AC (v01 PTL    WHEAPTL  06040000 PTL =
 00000001)
[    0.000000] ACPI: BERT c7e67408 00030 (v01 PTL    WHEAPTL  06040000 PTL =
 00000001)
[    0.000000] ACPI: SSDT c7e67438 000E1 (v01 wheaos  wheaosc 06040000 INTL=
 20050624)
[    0.000000] ACPI: ERST c7e67519 00270 (v01 PTL    WHEAPTL  06040000 PTL =
 00000001)
[    0.000000] ACPI: SLIT c7e67789 0003C (v01 AMD    F10      06040000 AMD =
 00000001)
[    0.000000] ACPI: SRAT c7e677c5 002A0 (v02 AMD    F10      06040000 AMD =
 00000001)
[    0.000000] ACPI: SSDT c7e67a65 03294 (v01 AMD    POWERNOW 06040000 AMD =
 00000001)
[    0.000000] ACPI: SSDT c7e6acf9 000F5 (v01 AMD-K8 AMD-ACPI 06040000  AMD=
 00000001)
[    0.000000] ACPI: APIC c7e6adee 0019E (v01 PTLTD  ? APIC   06040000  LTP=
 00000000)
[    0.000000] ACPI: MCFG c7e6af8c 0003C (v01 PTLTD    MCFG   06040000  LTP=
 00000000)
[    0.000000] ACPI: HPET c7e6afc8 00038 (v01 PTLTD  HPETTBL  06040000  LTP=
 00000001)
[    0.000000] Reserving total of 4c00 pages for numa KVA remap
[    0.000000] kva_start_pfn ~ 32800 max_low_pfn ~ 375fe
[    0.000000] max_pfn =3D 238000
[    0.000000] 8202MB HIGHMEM available.
[    0.000000] 885MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 375fe000
[    0.000000]   low ram: 0 - 375fe000
[    0.000000] sparse_early_mem_map_alloc: sparsemem memory map backing fai=
led some memory will not be available.
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000375fe
[    0.000000]   HighMem  0x000375fe -> 0x00238000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000088
[    0.000000]     0: 0x00000100 -> 0x0007ee00
[    0.000000]     1: 0x00080000 -> 0x000c7e60
[    0.000000]     1: 0x00100000 -> 0x00136a00
[    0.000000]     2: 0x00138000 -> 0x001b6e00
[    0.000000]     3: 0x001b8000 -> 0x00236e00
[    0.000000] BUG: Int 6: CR2 (null)
[    0.000000]      EDI 00000005  ESI f3a00800  EBP c2837ed4  ESP c2837e94
[    0.000000]      EBX 00000001  EDX 00000006  ECX (null)  EAX (null)
[    0.000000]      err (null)  EIP c2cefab5   CS 00000060  flg 00010046
[    0.000000] Stack: fffffff4 (null) f3a00000 000b6a00 00000005 00080000 0=
0000001 00000002
[    0.000000]        00000002 00000001 00000002 f3a00000 c2837f04 c2c8dccb=
 (null) c2837f04
[    0.000000]        00000004 001fb1d8 c34e67a0 (null) 00000004 fffba000 (=
null) c2837f1c
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.35-rc4+ #3
[    0.000000] Call Trace:
[    0.000000]  [<c222ee55>] hlt_loop+0x0/0x3
[    0.000000]  [<c2cefab5>] ? free_area_init_node+0x641/0x6c4
[    0.000000]  [<c2c8dccb>] free_area_init_nodes+0xa0a/0xb27
[    0.000000]  [<c2c7916c>] paging_init+0x1bc/0x1df
[    0.000000]  [<c2c55b0b>] setup_arch+0x1826/0x1a38
[    0.000000]  [<c2c822be>] ? __reserve_early+0x17e/0x19a
[    0.000000]  [<c112cea4>] ? init_cgroup_css+0xd5/0x110
[    0.000000]  [<c2c4c50e>] start_kernel+0x1d1/0xc42
[    0.000000]  [<c2c4b1d9>] i386_start_kernel+0x1d9/0x1ef

--MP_/0B0X3qtuhUMakY+wpT9r_q5--

--Sig_/_k6FvwO+ePWjl2o8rWak56G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkw3ibcACgkQ8Tl8CaarBV1eNACfYnWRhTHQyjfFLbzbvMFwdn51
d9MAoNKKMLdWUwRipBLA3mTFZ34uGwKb
=CoTa
-----END PGP SIGNATURE-----

--Sig_/_k6FvwO+ePWjl2o8rWak56G--
