Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2LTW1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 17:27:12 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:58342 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab2LTW1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 17:27:04 -0500
MIME-Version: 1.0
In-Reply-To: <50D387FD.4020008@oracle.com>
References: <alpine.LNX.2.00.1212191735530.25409@eggly.anvils>
 <alpine.LNX.2.00.1212191742440.25409@eggly.anvils> <50D387FD.4020008@oracle.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Dec 2012 14:26:43 -0800
X-Google-Sender-Auth: 9Zbti4pz3H_6bMqT3xqKBIDxCvo
Message-ID: <CA+55aFxfS0SBbRBRULX4Hm7a-xOY7ebJ=Ncu2cAdH2xvcZFO+Q@mail.gmail.com>
Subject: Re: [PATCH] ksm: make rmap walks more scalable
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Petr Holasek <pholasek@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 1:49 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 12/19/2012 08:44 PM, Hugh Dickins wrote:
>> The rmap walks in ksm.c are like those in rmap.c:
>> they can safely be done with anon_vma_lock_read().
>>
>> Signed-off-by: Hugh Dickins <hughd@google.com>
>> ---
>
> Hi Hugh,
>
> This patch didn't fix the ksm oopses I'm seeing.
>
> This is with both patches applied:

Looks like another NULL mm pointer in ksmd.. Hugh fixed one in
2832bc19f666 ("sched: numa: ksm: fix oops in task_numa_placment()"),
this looks like more of the same.

At a guess, it looks like get_mergeable_page() has a rmap_item with no
mm. No idea how that happened. Hugh? Some race due to something that
depended on the mmap_sem being exclusive, rather than for
read-ownership?

              Linus
