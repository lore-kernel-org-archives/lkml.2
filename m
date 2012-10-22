Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2JVTkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:40:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:32773 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab2JVTkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:40:15 -0400
MIME-Version: 1.0
In-Reply-To: <20121022152457.GH22780@phenom.dumpdata.com>
References: <1350593430-24470-1-git-send-email-yinghai@kernel.org>
	<1350593430-24470-17-git-send-email-yinghai@kernel.org>
	<20121022152457.GH22780@phenom.dumpdata.com>
Date: Mon, 22 Oct 2012 12:40:13 -0700
X-Google-Sender-Auth: npbbg_bHE0ajJdcmRmRy1vWeke8
Message-ID: <CAE9FiQWGkKQSGzpA5v9XNwi2-CsPodNuH3u+3bARQP_7TPHN1A@mail.gmail.com>
Subject: Re: [PATCH 13/19] x86, mm: only call early_ioremap_page_table_range_init()
 once
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 8:24 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
> On Thu, Oct 18, 2012 at 01:50:24PM -0700, Yinghai Lu wrote:
>> On 32bit, We should not keep calling that during every init_memory_mapping.
>
> Explain pls why.
>

clear ?

---
On 32bit, before patcheset that only set page table for ram, we only
call that one time.

Now, we are calling that during every init_memory_mapping if we have holes
under max_low_pfn.

We should only call it one time after all ranges under max_low_page get
mapped just like we did before.

Also that could avoid the risk to run out of pgt_buf in BRK.

Need to update page_table_range_init() to count the pages for kmap page table
at first, and use new added alloc_low_pages() to get pages in sequence.
That will conform to the requirement that pages need to be in low to high order.
---
