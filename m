Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab2KMSwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:52:03 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33734 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab2KMSwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:52:00 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1211131629230.28049@kaball.uk.xensource.com>
References: <20121112193044.GA11615@phenom.dumpdata.com>
	<1352755122-25660-1-git-send-email-yinghai@kernel.org>
	<1352755122-25660-27-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1211131629230.28049@kaball.uk.xensource.com>
Date: Tue, 13 Nov 2012 10:51:59 -0800
X-Google-Sender-Auth: BokghV0aXgOOmFv6zSloWkBG3Ps
Message-ID: <CAE9FiQUc0Jz0g+oZXye95dNCV0W4YMr-WMroUR_HaUmh-qZwoA@mail.gmail.com>
Subject: Re: [PATCH 26/46] x86, mm, Xen: Remove mapping_pagetable_reserve()
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 8:36 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 12 Nov 2012, Yinghai Lu wrote:
>> Page table area are pre-mapped now after
>>       x86, mm: setup page table in top-down
>>       x86, mm: Remove early_memremap workaround for page table accessing on 64bit
>>
>> mapping_pagetable_reserve is not used anymore, so remove it.
>
> You should mention in the description of the patch that you are
> removing mask_rw_pte too.
>
> The reason why you can do that safely is that you previously modified
> allow_low_page to always return pages that are already mapped, moreover
> xen_alloc_pte_init, xen_alloc_pmd_init, etc, will mark the page RO
> before hooking it into the pagetable automatically.

updated change log:
---
x86, mm, Xen: Remove mapping_pagetable_reserve()

Page table area are pre-mapped now after
        x86, mm: setup page table in top-down
        x86, mm: Remove early_memremap workaround for page table
accessing on 64bit

mapping_pagetable_reserve is not used anymore, so remove it.

Also remove operation in mask_rw_pte(), as modified allow_low_page
always return pages that are already mapped, moreover
xen_alloc_pte_init, xen_alloc_pmd_init, etc, will mark the page RO
before hooking it into the pagetable automatically.

-v2: add changelog about mask_rw_pte() from Stefano.
-----


>
> [ ... ]
>
> you should just get rid of mask_rw_pte completely

then how about 32bit mask_rw_pte? Maybe you can clean up that later?

Thanks

Yinghai
