Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1JWMuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 08:50:04 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35193 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab1JWMuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 08:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <20111023115635.GA17912@n2100.arm.linux.org.uk>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com>
 <1312988619-16804-9-git-send-email-catalin.marinas@arm.com> <20111023115635.GA17912@n2100.arm.linux.org.uk>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Sun, 23 Oct 2011 14:49:41 +0200
X-Google-Sender-Auth: oeA8auw5PMalGGkQH-0yIQX_Ivs
Message-ID: <CAHkRjk6kJmc7+MDGvyDqhVTBefPzjm-_XdrC85kpZozuYEb=YA@mail.gmail.com>
Subject: Re: [PATCH v7 08/16] ARM: LPAE: Page table maintenance for the
 3-level format
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 October 2011 13:56, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Aug 10, 2011 at 04:03:31PM +0100, Catalin Marinas wrote:
>> This patch modifies the pgd/pmd/pte manipulation functions to support
>> the 3-level page table format. Since there is no need for an 'ext'
>> argument to cpu_set_pte_ext(), this patch conditionally defines a
>> different prototype for this function when CONFIG_ARM_LPAE.
>
> This has a really large number of ifdefs.  You've split the 2 and 3
> level page table stuff into two different header files already,
> conditionalized on CONFIG_ARM_LPAE, yet we still end up with lots of
> junk in the common header file conditionalized on that symbol.  Can't
> we find a way to restructure pgtable.h to sort this out more cleanly?

I'll look into this.

> Do we really need to change the set_pte_ext() prototype as well - do
> we _really_ need ifdefs around its declaration, and every usage of it
> as well?  Can't we just leave the 3rd argument as zero?

The LPAE variant of cpu_v7_set_pte_ext takes the second argument as a
64-bit value:

r0 - ptep
r2, r3 - pteval

If we pass a third argument, that would go on the stack.

-- 
Catalin
