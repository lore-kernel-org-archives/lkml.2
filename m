Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab2ICFuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 01:50:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47821 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab2ICFuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 01:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <1346572019-15806-14-git-send-email-yinghai@kernel.org>
References: <1346572019-15806-1-git-send-email-yinghai@kernel.org>
	<1346572019-15806-14-git-send-email-yinghai@kernel.org>
Date: Mon, 3 Sep 2012 08:50:01 +0300
X-Google-Sender-Auth: xGW1w2PEEUcR_c34Hn5AFujkL-s
Message-ID: <CAOJsxLFtpBnvtA3F=7NDJunqXRs4AL1=oe7HR6GECgGfr9TqDA@mail.gmail.com>
Subject: Re: [PATCH -v2 13/13] x86, 64bit: Map first 1M ram early before memblock_x86_fill()
From: Pekka Enberg <penberg@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 10:46 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> This one intend to fix bugs:
> when efi booting have too many memmap entries, will need to double memblock
> memory array or reserved array.

Okay, why do we need to do that?

> +RESERVE_BRK(early_pgt_alloc, 65536);

What is this needed for?

> +void  __init early_init_mem_mapping(void)
> +{
> +       unsigned long tables;
> +       phys_addr_t base;
> +       unsigned long start = 0, end = ISA_END_ADDRESS;
> +
> +       probe_page_size_mask();
> +
> +       if (max_pfn_mapped)
> +               return;

I find this confusing - what is this protecting for? Why is
'max_pfn_mapped' set when someone calls early_init_mem_mappings()?

Side note: we have multiple "pfn_mapped" globals and it's not at all
obvious to me what the semantics for them are. Maybe adding a comment
or two in arch/x86/include/asm/page_types.h would help.

> +
> +       tables = calculate_table_space_size(start, end);
> +       base = __pa(extend_brk(tables, PAGE_SIZE));
> +
