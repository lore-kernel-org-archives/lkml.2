Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1GHRla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:41:30 -0400
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:38561 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752667Ab1GHRl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:41:29 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: wH8JgUEVM1lYo9Azfxxhez1SVNJyXppFtsLQ_Hkr32G.d28
 KHeARH76bpalsGVRQO0pC.QsYjqCKinmulHEy87Lic2XQ4OUo4JFexjfzMAJ
 SNJh63Fd5KsKEj984Va8.W28LZi91F023y6sUzQfpg3OjvJWfxuRJqOrhEim
 g45kRMGQkBU0n5JhekZdfGfost7FBvTDrtZfqFPea0kolor7phfw1EaW5IPq
 e.Drz9bRrwzj96VIWUqUsPfPA0HDAgeYiF_f3fqqH_kWioHgpwRVN3Lm9k9o
 ZcIicTSGfamRa6mhgndVGXkGDGqEA_vq8yggmqin4pTJYkTvjTr8zgml8iD_
 ImocR6mU0kRuOFzMY3d.prbpo
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 8 Jul 2011 12:41:24 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: Pekka Enberg <penberg@kernel.org>, David Miller <davem@davemloft.net>,
        marcin.slusarz@gmail.com, mpm@selenic.com,
        linux-kernel@vger.kernel.org, rientjes@google.com, linux-mm@kvack.org
Subject: Re: [PATCH] slub: reduce overhead of slub_debug
In-Reply-To: <m2box5cplq.fsf@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1107081240010.23187@router.home>
References: <alpine.DEB.2.00.1107071314320.21719@router.home> <1310064771.21902.55.camel@jaguar> <alpine.DEB.2.00.1107071402490.24248@router.home> <20110707.122151.314840355798805828.davem@davemloft.net> <CAOJsxLFsX3Q84QAeyRt5dZOdRxb3TiABPrP-YrWc91+BmR8ZBg@mail.gmail.com>
 <alpine.DEB.2.00.1107071511010.26083@router.home> <m2box5cplq.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Andi Kleen wrote:

> Christoph Lameter <cl@linux.com> writes:
>
>
> > +#ifdef __HAVE_ARCH_INV_MEMSCAN
> > +void *inv_memscan(void *addr, int c, size_t size)
> > +{
> > +	if (!size)
> > +		return addr;
> > +	asm volatile("repz; scasb\n\t"
>
> This will just do the slow byte accesses again internally.
> scasb is not normally very optimized in microcode as far
> as I know.
>
> Also rep has quite some startup overhead which makes
> it a bad idea for small sizes (<16-20 or so)
>
> I would stay with the C version. I bet that one is
> faster.

If the c code is such an improvement then memscan and other
implementations can be accellerated in the same way. That would be useful
in general. We can get rid of the implementation for memscan and friends
in x86 arch code.



