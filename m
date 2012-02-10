Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760024Ab2BJTpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:45:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65461 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759960Ab2BJTpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:45:15 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: akpm@linux-foundation.org, "Dan Smith" <danms@us.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ensure that walk_page_range()'s start and end are
 page-aligned
References: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
Date: Fri, 10 Feb 2012 20:45:12 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v9hahmw23l0zgt@mpn-glaptop>
In-Reply-To: <1328902796-30389-1-git-send-email-danms@us.ibm.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Feb 2012 20:39:56 +0100, Dan Smith <danms@us.ibm.com> wrote:
> The inner function walk_pte_range() increments "addr" by PAGE_SIZE after

Commit message says about walk_pte_range() but commit changes walk_page_range().

> each pte is processed, and only exits the loop if the result is equal to
> "end". Current, if either (or both of) the starting or ending addresses

So why not change the condition to addr < end?

> passed to walk_page_range() are not page-aligned, then we will never
> satisfy that exit condition and begin calling the pte_entry handler with
> bad data.
>
> To be sure that we will land in the right spot, this patch checks that
> both "addr" and "end" are page-aligned in walk_page_range() before starting
> the traversal.
>
> Signed-off-by: Dan Smith <danms@us.ibm.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/pagewalk.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index 2f5cf10..9242bfc 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -196,6 +196,8 @@ int walk_page_range(unsigned long addr, unsigned long end,
>  	if (addr >= end)
>  		return err;
>+	VM_BUG_ON((addr & ~PAGE_MASK) || (end & ~PAGE_MASK));
> +
>  	if (!walk->mm)
>  		return -EINVAL;
>


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
