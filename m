Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967408Ab2EPK7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 06:59:03 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39498 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967031Ab2EPK67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 06:58:59 -0400
MIME-Version: 1.0
In-Reply-To: <1337158712.27694.134.camel@twins>
References: <1337072138-8323-1-git-send-email-alex.shi@intel.com>
	<1337072138-8323-7-git-send-email-alex.shi@intel.com>
	<CAPa8GCDsSOrzQwX2qRJyocYAZdGbwjD4t4fjxmWXV6=EoXjXZw@mail.gmail.com>
	<4FB2590C.1050303@intel.com>
	<1337092577.27694.45.camel@twins>
	<1337093840.27694.56.camel@twins>
	<4FB34D49.1060809@intel.com>
	<1337155239.27694.131.camel@twins>
	<1337155464.27694.132.camel@twins>
	<4FB36B12.9000705@intel.com>
	<1337158712.27694.134.camel@twins>
Date: Wed, 16 May 2012 18:58:58 +0800
Message-ID: <CAGjg+kGErUbt5JS7SLCGtUO_JKk0LtkpyM4JgFUsxHME53k=hQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] x86/tlb: optimizing flush_tlb_mm
From: Alex Shi <lkml.alex@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@intel.com>, Nick Piggin <npiggin@gmail.com>,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com, jeremy@goop.org,
        riel@redhat.com, luto@mit.edu, avi@redhat.com, len.brown@intel.com,
        dhowells@redhat.com, fenghua.yu@intel.com, borislav.petkov@amd.com,
        yinghai@kernel.org, ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, tj@kernel.org, oleg@redhat.com,
        axboe@kernel.dk, jmorris@namei.org, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 4:58 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2012-05-16 at 16:53 +0800, Alex Shi wrote:
>>
>> Sorry. Do you mean not every archs use 'include/asm-generic/tlb.h', so
>> the assignment of tlb->start in tlb_gather_mmu make trouble?
>>
> Yes exactly. I know you work for Intel, but surely its not forbidden by
> contract to look outside of arch/x86/ ? I know!, look at arch/ia64/
> that's still Intel.

:) It is my fault. 'make cscope' just help me focus insight into x86.

But frankly speaking, it looks mess that every arch implement similar fields of
 mmu_gather. If someone can unify the common fields of mmu_gather, and
left private field for specific arch. it will be great and much helpful.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
