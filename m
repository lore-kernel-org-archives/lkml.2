Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab1CYPp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 11:45:29 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:25418 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753766Ab1CYPp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 11:45:28 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: LOHiHx4VM1kZ.QRxub2mnpyD90PYV18h1mfFHLbIKTQhmbE
 jxlsLLpzGorxe7iCFaCvpCmSejFZDNt3uglVVjVHr7W3q4CKPoR0.PCY9osT
 kRdCVyfxBXuGltysoBFFy.LyPgJ6me5FPU6ymCwcJPL1o0xXtHjMInZrhFzT
 3_iTh4iVoyLDXBoIqyzQlIgbbn4.r3i3f_0pIQR4cqS2oRwhpoL7qfSKuqTU
 htxSh9yRVZ1eUYamdsmTCaPJGbgQzlP9pAk40WZYTWes250811fcjwvtBlei
 iG1XxNplK5YLFagQbPTtbWV9dnbPWbQR7kvAuFvHXZB3JaF85LwVOldLUvgI
 i5VPqUONg0U54lVZlkmFg0KYy
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 25 Mar 2011 10:45:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <tj@kernel.org>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, npiggin@kernel.dk,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [GIT PULL] SLAB changes for v2.6.39-rc1
In-Reply-To: <20110325151353.GG1409@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1103251041240.27814@router.home>
References: <AANLkTik3rkNvLG-rgiWxKaPc-v9sZQq96ok0CXfAU+r_@mail.gmail.com> <20110324185903.GA30510@elte.hu> <AANLkTi=66Q-8=AV3Y0K28jZbT3ddCHy9azWedoCC4Nrn@mail.gmail.com> <alpine.DEB.2.00.1103241404490.5576@router.home> <AANLkTimWYCHEsZjswLpD-xDcu_cL=GqsMshKRtkHt5Vn@mail.gmail.com>
 <20110324193647.GA7957@elte.hu> <AANLkTinBwKT3s=1En5Urs56gmt_zCNgPXnQzzy52Tgdo@mail.gmail.com> <alpine.DEB.2.00.1103241451060.5576@router.home> <1300997290.2714.2.camel@edumazet-laptop> <alpine.DEB.2.00.1103241541560.8108@router.home>
 <20110325151353.GG1409@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Mar 2011, Tejun Heo wrote:

> I've looked through the code but can't figure out what the difference
> is.  The memset code is in mm/percpu-vm.c::pcpu_populate_chunk().
>
> 	for_each_possible_cpu(cpu)
> 		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
>
> (pcpu_chunk_addr(chunk, cpu, 0) + off) is the same vaddr as will be
> obtained by per_cpu_ptr(ptr, cpu), so all allocated memory regions are
> accessed before being returned.  Dazed and confused (seems like the
> theme of today for me).
>
> Could it be that the vmalloc page is taking more than one faults?

The vmalloc page only contains per cpu data from a single cpu right?

Could anyone have set write access restrictions that would require a fault
to get rid of?

Or does an access from a different cpu require a "page table sync"?

There is some rather strange looking code in arch/x86/mm/fault.c:vmalloc_fault



