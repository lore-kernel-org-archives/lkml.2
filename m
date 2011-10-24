Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769Ab1JXSzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 14:55:11 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39204 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1JXSzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 14:55:09 -0400
MIME-Version: 1.0
In-Reply-To: <11382.1319479512@turing-police.cc.vt.edu>
References: <1319397143-20301-1-git-send-email-acme@infradead.org>
 <1319397143-20301-5-git-send-email-acme@infradead.org> <11382.1319479512@turing-police.cc.vt.edu>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Mon, 24 Oct 2011 20:54:29 +0200
Message-ID: <CAPybu_2rU7Zh9UOBuPp1-3sNMJiZxPkCzAYmXSBrtbDGB6RjTA@mail.gmail.com>
Subject: Re: [PATCH 4/4] perf symbols: Increase symbol KSYM_NAME_LEN size
To: Valdis.Kletnieks@vt.edu
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        David Ahern <daahern@cisco.com>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also suck a big binary blob does not help :)

ricardo@newpili:/tmp/fglrx-driver-11-9/arch/x86_64/lib/modules/fglrx/build_mod$
for a in $( objdump -t libfglrx_ip.a | grep text| awk '{print $6}' );
do printf " %s $a\n" $(echo $a|  wc -c) ; done | sort -n  | tee
symbols | tail -n 10
 137 _ZNK11R800AddrLib28ComputeSurfaceInfoMicroTiledEPK32_ADDR_COMPUTE_SURFACE_INFO_INPUTP33_ADDR_COMPUTE_SURFACE_INFO_OUTPUTj13_AddrTileMode
 140 _ZNK11R800AddrLib33DispatchComputeFmaskCoordFromAddrEPK39_ADDR_COMPUTE_FMASK_COORDFROMADDR_INPUTP40_ADDR_COMPUTE_FMASK_COORDFROMADDR_OUTPUT
 141 _ZNK11R600AddrLib30HwlComputeSurfaceAddrFromCoordEPK41_ADDR_COMPUTE_SURFACE_ADDRFROMCOORD_INPUTP42_ADDR_COMPUTE_SURFACE_ADDRFROMCOORD_OUTPUT
 141 _ZNK11R600AddrLib30HwlComputeSurfaceCoordFromAddrEPK41_ADDR_COMPUTE_SURFACE_COORDFROMADDR_INPUTP42_ADDR_COMPUTE_SURFACE_COORDFROMADDR_OUTPUT
 141 _ZNK11R800AddrLib30HwlComputeSurfaceAddrFromCoordEPK41_ADDR_COMPUTE_SURFACE_ADDRFROMCOORD_INPUTP42_ADDR_COMPUTE_SURFACE_ADDRFROMCOORD_OUTPUT
 141 _ZNK11R800AddrLib30HwlComputeSurfaceCoordFromAddrEPK41_ADDR_COMPUTE_SURFACE_COORDFROMADDR_INPUTP42_ADDR_COMPUTE_SURFACE_COORDFROMADDR_OUTPUT
 146 _ZNK11R600AddrLib35DispatchComputeSurfaceAddrFromCoordEPK41_ADDR_COMPUTE_SURFACE_ADDRFROMCOORD_INPUTP42_ADDR_COMPUTE_SURFACE_ADDRFROMCOORD_OUTPUT
 146 _ZNK11R600AddrLib35DispatchComputeSurfaceCoordFromAddrEPK41_ADDR_COMPUTE_SURFACE_COORDFROMADDR_INPUTP42_ADDR_COMPUTE_SURFACE_COORDFROMADDR_OUTPUT
 146 _ZNK11R800AddrLib35DispatchComputeSurfaceAddrFromCoordEPK41_ADDR_COMPUTE_SURFACE_ADDRFROMCOORD_INPUTP42_ADDR_COMPUTE_SURFACE_ADDRFROMCOORD_OUTPUT
 146 _ZNK11R800AddrLib35DispatchComputeSurfaceCoordFromAddrEPK41_ADDR_COMPUTE_SURFACE_COORDFROMADDR_INPUTP42_ADDR_COMPUTE_SURFACE_COORDFROMADDR_OUTPUT


On Mon, Oct 24, 2011 at 20:05,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sun, 23 Oct 2011 17:12:23 -0200, Arnaldo Carvalho de Melo said:
>
>> Fglrx propietary driver has symbol names over 128 chars (:S). This
>> breaks the function kallsyms__parse.
>
> Well, that explains why they haven't upstreamed the driver, it will never
> pass checkpatch's line-lenght check :)
>
> But at some point you really need to just tell the vendors to put down
> the crack pipe.
>
> (What *are* the symbols? C++ mangled function names?)
>



-- 
Ricardo Ribalda
