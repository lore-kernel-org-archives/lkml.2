Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab0HXWY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:24:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720Ab0HXWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:24:53 -0400
MIME-Version: 1.0
In-Reply-To: <4c74419664798b8c9@agluck-desktop.sc.intel.com>
References: <4c74419664798b8c9@agluck-desktop.sc.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Aug 2010 15:23:52 -0700
Message-ID: <AANLkTin5mxbyH9BOcrGAW2nFiDBOeUE8=HsBR8U=x3bc@mail.gmail.com>
Subject: Re: [PATCH] hide guard page for stacks that grow upwards
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-ia64@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 24, 2010 at 3:03 PM, Luck, Tony <tony.luck@intel.com> wrote:
>
> This looks useful too ... but I can't see where the code is that
> made vm_start be PAGE_SIZE lower to begin with. I'd expect to have
> to make a matching change to make vm_end PAGE_SIZE higher for the
> VM_GROWSUP areas.

That's the fault path - the very check_stack_guard_page() logic itself.

In other words, nowhere do we _explicitly_ make the stack larger by
one page, but nowhere do we explicitly size the stack in the first
place! The stack grows by being populated, and every time a new page
is populated, check_stack_guard_page() will have expanded the stack
vma by one extra page.

                   Linus
