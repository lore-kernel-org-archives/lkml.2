Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0GITrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 15:47:22 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:54927
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063Ab0GITrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 15:47:20 -0400
X-SpamScore: -35
X-BigFish: VPS-35(zz1411I1432N98dN936eM9371Pzz1202hzz15d4Rz32i2a8h34h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L5B2YM-01-HJ4-02
X-M-MSG: 
Date: Fri, 9 Jul 2010 21:52:02 +0200
From: Conny Seidel <conny.seidel@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: "Petkov, Borislav" <Borislav.Petkov@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: unable to handle kernel paging request at 40000000
 __alloc_memory_core_early+0x147/0x1d6
Message-ID: <20100709215202.4be679a8@marah.osrc.amd.com>
In-Reply-To: <4C3773C4.1010609@kernel.org>
References: <20100709145415.GC11199@aftab>
	<4C3773C4.1010609@kernel.org>
Organization: Advanced Micro Devices GmbH; Einsteinring 24; 85609 Dornach
 bei =?UTF-8?B?TcO8bmNoZW47IEdlc2Now6RmdHNmw7xocmVyOg==?= Alberto Bozzo,
 Andrew Bowd; Sitz: Dornach, Gemeinde Aschheim, Landkreis =?UTF-8?B?TcO8?=
 =?UTF-8?B?bmNoZW47?= Registergericht =?UTF-8?B?TcO8bmNoZW4s?= HRB Nr. 43632
X-Mailer: Claws Mail 3.7.6cvs11 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
	boundary="Sig_/f=nKrM0quQJvqdm/Qw3+n9N";
	protocol="application/pgp-signature"
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/f=nKrM0quQJvqdm/Qw3+n9N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 9 Jul 2010 15:08:52 -0400
Yinghai Lu <yinghai@kernel.org> wrote:

>On 07/09/2010 07:54 AM, Borislav Petkov wrote:
>> Hi,
>>
>> this is something we're getting during testing on one of our boxes
>> here, a dual socket Magny-Cours machine. It is oopsing on the addr
>> variable in __alloc_memory_core_early() after converting it to a
>> virtual address in order to clear the mem region at it. I've removed
>> the "#if 0.. #endif" around the printk which dumps the ranges in the
>> early node map for more info.
>>
>> It's latest -git, 32bit build, config is attached.
>>
>
>can not duplicate on all my setup.
>
>but look at the code there is limit problem with 32 bit...
>
>please check if it will fix the problem.
>
>and we will need to rebase early_res to memblock patchset.
>
>Thanks
>
>Yinghai Lu
>

I'm sorry but the patch isn't working.

Now we are seeing this:

[    0.000000] BUG: Int 6: CR2 (null)
[    0.000000]      EDI 00000005  ESI f3e00800  EBP c21afed4  ESP c21afe90
[    0.000000]      EBX 01000000  EDX 00000006  ECX (null)  EAX fffffff4
[    0.000000]      err (null)  EIP c2359558   CS 00000060  flg 00010046
[    0.000000] Stack: fffffff4 (null) 00000001 f3e00000 00000005 00080000 0=
0000001 00000002
[    0.000000]        000b6800 00000002 f3e00000 00000001 00000002 c21aff0c=
 c2359dd2 (null)
[    0.000000]        ffe00000 00000004 (null) 00000004 001fafd8 c2943000 (=
null) 00004e00
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.35-rc4+ #1
[    0.000000] Call Trace:
[    0.000000]  [<c1dd39d9>] hlt_loop+0x0/0x3
[    0.000000]  [<c2359558>] ? free_area_init_node+0x5b1/0x647
[    0.000000]  [<c2359dd2>] free_area_init_nodes+0x7b5/0x89a
[    0.000000]  [<c234a2c9>] paging_init+0x1a9/0x1cc
[    0.000000]  [<c2330325>] setup_arch+0x1414/0x15f7
[    0.000000]  [<c23510c1>] ? __reserve_early+0x119/0x135
[    0.000000]  [<c1078c8a>] ? printk+0x36/0x54
[    0.000000]  [<c232917b>] start_kernel+0x1d0/0xb6f
[    0.000000]  [<c2328163>] i386_start_kernel+0x163/0x179


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

--Sig_/f=nKrM0quQJvqdm/Qw3+n9N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkw3feIACgkQ8Tl8CaarBV1PQwCg7KclRB/Y0mzHBo4OJ2PDv+u0
Kz0An0N/0F5HocFgL0milUC2lO+bKWvj
=x1sT
-----END PGP SIGNATURE-----

--Sig_/f=nKrM0quQJvqdm/Qw3+n9N--
