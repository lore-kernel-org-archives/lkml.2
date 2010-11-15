Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab0KOVqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:46:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36085 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab0KOVqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:46:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AGqg6HfpSKso0m47ICa1xqvNugz4sNMnfOHWkOYaNdPY4EOlxUKLNcdboskQf1hodR
         jl9srbAieIs38jlSDdcdKsmphS5yycGzNcT3kuMfC1X0N5/FNH3b3ts2h0G9nEUmvKnv
         OYzZfR0UQolzQzMok2UF+0/9zS7XuvOg2pq74=
MIME-Version: 1.0
In-Reply-To: <20101115174251.GB31421@n2100.arm.linux.org.uk>
References: <1289584840-18097-1-git-send-email-catalin.marinas@arm.com>
	<1289584840-18097-5-git-send-email-catalin.marinas@arm.com>
	<20101115174251.GB31421@n2100.arm.linux.org.uk>
Date: Mon, 15 Nov 2010 21:46:14 +0000
X-Google-Sender-Auth: BzxvP3eiPDOgQUuswPodshWncTI
Message-ID: <AANLkTinej2U_tEWM25m7VW7=PndxVPohaKjJ=10wn+C1@mail.gmail.com>
Subject: Re: [PATCH v2 04/20] ARM: LPAE: Do not assume Linux PTEs are always
 at PTRS_PER_PTE offset
From: Catalin Marinas <catalin.marinas@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 November 2010 17:42, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Nov 12, 2010 at 06:00:24PM +0000, Catalin Marinas wrote:
>> Placing the Linux PTEs at a 2KB offset inside a page is a workaround for
>> the 2-level page table format where not enough spare bits are available.
>> With LPAE this is no longer required. This patch changes such assumption
>> by using a different macro, LINUX_PTE_OFFSET, which is defined to
>> PTRS_PER_PTE for the 2-level page tables.
>
> Hmm.  I think we should be doing this a different way - in fact, I think
> we should switch the order of the linux vs hardware page tables.  This
> actually simplifies the code a bit too - notice that we lose the arith.
> in __pte_map, __pte_unmap, pmd_page_vaddr, which is all page table
> walking stuff.

It looks like a good clean-up to me (though I need some refactoring on
my LPAE patches). Do you plan to push this upstream? If you add a
comment and a signed-off line, I can carry it in my LPAE branch until
it appears in mainline.

Thanks.

-- 
Catalin
