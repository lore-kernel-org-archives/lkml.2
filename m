Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab2K1Td1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:33:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50888 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754501Ab2K1TdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:33:25 -0500
MIME-Version: 1.0
In-Reply-To: <20121128170625.GJ21266@phenom.dumpdata.com>
References: <1353123563-3103-1-git-send-email-yinghai@kernel.org>
	<1353123563-3103-13-git-send-email-yinghai@kernel.org>
	<20121128170625.GJ21266@phenom.dumpdata.com>
Date: Wed, 28 Nov 2012 11:33:24 -0800
X-Google-Sender-Auth: bhIic1X7Ywlw9jzLIRnRo_m_T4g
Message-ID: <CAE9FiQVCf1u86VyuWhD+u2YyGfY6W1V7QjNXKyAU3Vuqi3mR6A@mail.gmail.com>
Subject: Re: [PATCH v8 12/46] x86, mm: use pfn_range_is_mapped() with CPA
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 9:06 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Fri, Nov 16, 2012 at 07:38:49PM -0800, Yinghai Lu wrote:
>> We are going to map ram only, so under max_low_pfn_mapped,
>> between 4g and max_pfn_mapped does not mean mapped at all.
>
> I think I know what you are saying but I am having a hard
> time parsing it. Is this what you mean?
>
> "We check to see if the PFNs are under max_low_pfn_mapped or
> between 4G and max_pfn_mapped. If they are not: then we
> map them."  ?

No

---
We are going to map ram only in patch:
        x86, mm: Only direct map addresses that are marked as E820_RAM

so range under max_low_pfn_mapped, ranges between 4g and max_pfn_mapped
could have holes in them and the holes will not be mapped.

Use pfn_range_is_mapped() to check if the range is mapped.
---
