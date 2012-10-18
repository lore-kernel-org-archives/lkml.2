Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2JRUnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:43:45 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37064 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab2JRUnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:43:42 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1210181444380.2689@kaball.uk.xensource.com>
References: <1349827115-16600-1-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1210101609170.2689@kaball.uk.xensource.com>
	<CAE9FiQW952+jHBHxhKu2PX_fpwb8fXVQp2xX0i=HdzgKWuGFCA@mail.gmail.com>
	<alpine.DEB.2.02.1210181444380.2689@kaball.uk.xensource.com>
Date: Thu, 18 Oct 2012 13:43:40 -0700
X-Google-Sender-Auth: IyF95ZgYuHN5tnH4ZCnS92nQPuw
Message-ID: <CAE9FiQXD3JYQe3kwRM3S4=OaocSP7iXNkOajQ9ka9bzM2NVKSA@mail.gmail.com>
Subject: Re: [PATCH -v3 0/7] x86: Use BRK to pre mapping page table to make
 xen happy
From: Yinghai Lu <yinghai@kernel.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 9:17 AM, Stefano Stabellini
<stefano.stabellini@eu.citrix.com> wrote:
>
> I find that patch series are easier to review than having to checkout
> your code and read the commit messages. Please post your patch series to
> the LKML next time.

ok, will post -v5 to the list.

>
> In any case, regarding "x86, xen: Add xen_mapping_mark_page_ro": please
> take Peter's feedback into account; mark_page_ro is not a good name for
> a pvops.
> Also I don't believe that this call is actually needed, see below.
>
> Regarding "x86, mm: setup page table in top-down": if you mark the
> pagetable page RO in alloc_low_page, won't the entire thing crash as
> soon as you try to write to it? You are supposed to mark it RO after
> filling up the pagetable page and before hooking it into the live
> pagetable.
> However contrary to my expectations, I did a quick test and it seems to
> be working, that is probably due to a bug: maybe __pa or lookup_address
> don't work correctly when called so early?
>
> In any case we don't care about that because if we assume that
> alloc_low_pages will always return a page from a range that is already
> mapped, then we do not need this pvop anymore. That's because
> xen_alloc_pte_init, xen_alloc_pmd_init, etc, will mark the page RO
> before hooking it into the pagetable automatically.
> Sorry for I misled you last time.

yeah, I was confused how xen could RO page for page table.

>
> Let me repeat it again:
> Can we assume that the page returned by alloc_low_pages is already mapped?
>
> Yes? In that case let's get rid of mark_page_ro and everything should
> work.

yes, removed.

>
> It is worth stating it in clear letters in a comment on top of
> alloc_low_pages:
>
> "This function always returns a page from a memory range already
> mapped."

actually alloc_...  should be always return mapped.

Thanks

Yinghai
