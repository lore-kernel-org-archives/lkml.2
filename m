Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab1CZVg5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 17:36:57 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:25088 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750892Ab1CZVg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 17:36:56 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: hpZ0.PEVM1nESAgaXp6khgq.JbZRZYpNFmtotlCQ1eBAbAi
 .rFZSOYsufcQFSTVySdHdLWYxJpM5cMb6eqxaOb_rnQBQaUkCTmjiG2WjW39
 9LEb.op4Uc8cbdgrJYDiT8MV45_1RneCVSz2WjgetotFk1SyadfVk930pY1p
 SpQpSBkCerGBM7xiyKfhnNTVdmZI_vn87V8p8oNZAO2st.ZXtiZ3je3JxpdM
 iQsn6fP4KOQ8wgsbE5i86lQNytfy95Pkl.sTlEZ6mE7vWl.IiHCXoTb5JFwQ
 cpuz3S7TILklXsxWJDVdwnaOMbCdUSWIO.3aMjXCM_m3Jg7kG
X-Yahoo-Newman-Property: ymail-3
Date: Sat, 26 Mar 2011 16:36:51 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Ingo Molnar <mingo@elte.hu>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tj@kernel.org, npiggin@kernel.dk,
        rientjes@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] slub: Disable the lockless allocator
In-Reply-To: <20110326195722.GA7748@elte.hu>
Message-ID: <alpine.DEB.2.00.1103261636210.29331@router.home>
References: <20110324185258.GA28370@elte.hu> <alpine.LFD.2.00.1103242005530.31464@localhost6.localdomain6> <20110324192247.GA5477@elte.hu> <AANLkTinBwM9egao496WnaNLAPUxhMyJmkusmxt+ARtnV@mail.gmail.com> <20110326112725.GA28612@elte.hu> <20110326114736.GA8251@elte.hu>
 <1301161507.2979.105.camel@edumazet-laptop> <alpine.DEB.2.00.1103261406420.24195@router.home> <alpine.DEB.2.00.1103261428200.25375@router.home> <alpine.DEB.2.00.1103261440160.25375@router.home> <20110326195722.GA7748@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Mar 2011, Ingo Molnar wrote:

> > Subject: per_cpu: Fixup cmpxchg_double for !SMP
> >
> > cmpxchg_double should only be provided for SMP. In the UP case
> > the GS register is not defined and the function will fail.
> >
> > Signed-off-by: Christoph Lameter <cl@linux.com>
>
> I.e. the bug got introduced by:
>
>  | commit b9ec40af0e18fb7d02106be148036c2ea490fdf9
>  | Author: Christoph Lameter <cl@linux.com>
>  | Date:   Mon Feb 28 11:02:24 2011 +0100
>  |
>  |     percpu, x86: Add arch-specific this_cpu_cmpxchg_double() support
>
> and then the lockless allocator made use of it, right?

Correct.

