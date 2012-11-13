Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab2KMSxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:53:09 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52156 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab2KMSxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:53:07 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1211131637240.28049@kaball.uk.xensource.com>
References: <20121112193044.GA11615@phenom.dumpdata.com>
	<1352755122-25660-1-git-send-email-yinghai@kernel.org>
	<1352755122-25660-28-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1211131637240.28049@kaball.uk.xensource.com>
Date: Tue, 13 Nov 2012 10:53:05 -0800
X-Google-Sender-Auth: JJhWoLhvnwVA9KN55yxQqusIkzA
Message-ID: <CAE9FiQUqOnOVtNUJdFfnh18EFjguxSiaRAhz0Eek5qbeLeUZWA@mail.gmail.com>
Subject: Re: [PATCH 27/46] x86, mm: Add alloc_low_pages(num)
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

On Tue, Nov 13, 2012 at 8:37 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
> On Mon, 12 Nov 2012, Yinghai Lu wrote:
>> 32bit kmap mapping needs pages to be used for low to high.
>> At this point those pages are still from pgt_buf_* from BRK, so it is
>> ok now.
>> But we want to move early_ioremap_page_table_range_init() out of
>> init_memory_mapping() and only call it one time later, that will
>> make page_table_range_init/page_table_kmap_check/alloc_low_page to
>> use memblock to get page.
>>
>> memblock allocation for pages are from high to low.
>> So will get panic from page_table_kmap_check() that has BUG_ON to do
>> ordering checking.
>>
>> This patch add alloc_low_pages to make it possible to allocate serveral
>> pages at first, and hand out pages one by one from low to high.
>>
>> -v2: add one line comment about xen requirements.
>
> where is it?

removed.
