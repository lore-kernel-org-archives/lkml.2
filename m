Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab1FPEdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 00:33:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42323 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751049Ab1FPEdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 00:33:09 -0400
MIME-Version: 1.0
In-Reply-To: <47FAB15C-B113-40FD-9CE0-49566AACC0DF@suse.de>
References: <47FAB15C-B113-40FD-9CE0-49566AACC0DF@suse.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 21:32:45 -0700
Message-ID: <BANLkTimubRW2Az2MmRbgV+iTB+s6UEF5-w@mail.gmail.com>
Subject: Re: Oops in VMA code
To: Alexander Graf <agraf@suse.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 2:59 PM, Alexander Graf <agraf@suse.de> wrote:
> Hi memory management experts,
>
> I just had this crash while compiling code on my PPC G5. I was running my PPC KVM tree, which was pretty much 06e86849cf4019945a106913adb9ff0abcc01770 plus a few unrelated KVM patches. User space is 64-bit.
>
> Is this a known issue or did I hit something completely unexpected?

It doesn't look at all familiar to me, nor does google really seem to
find anything half-way related.

In fact, the only thing that that oops makes me think is that we
should get rid of that find_vma_prev() function these days (the vma
list is doubly linked since commit 297c5eee3724, and the whole "look
up prev" thing is some silly old stuff).

But that's an entirely unrelated issue.

Also, your disassembly and your gdb line lookup is apparently from
some other kernel, because the addresses don't match. The actual
running kernel actually says

  NIP [c000000000190598] .do_munmap+0x138/0x3f0

so it's do_munmap, not find_vma_prev(). Although gdb claiming
find_vma_prev() might be from some inlining issue, of course.
Regardless, it's useless for debugging - it's the do_munap()
disassembly we'd want (but I'm no longer all that fluent in ppc
assembly anyway, so ir probably wouldn't help).

                           Linus
