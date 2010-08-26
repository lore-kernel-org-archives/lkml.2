Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0HZNcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 09:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab0HZNcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 09:32:52 -0400
Message-ID: <4C766CD7.8000004@redhat.com>
Date: Thu, 26 Aug 2010 09:32:07 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix hang on anon_vma->root->lock
References: <alpine.LSU.2.00.1008252305540.19107@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1008252305540.19107@sister.anvils>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2010 02:12 AM, Hugh Dickins wrote:
> After several hours, kbuild tests hang with anon_vma_prepare() spinning on
> a newly allocated anon_vma's lock - on a box with CONFIG_TREE_PREEMPT_RCU=y
> (which makes this very much more likely, but it could happen without).
>
> The ever-subtle page_lock_anon_vma() now needs a further twist: since
> anon_vma_prepare() and anon_vma_fork() are liable to change the ->root
> of a reused anon_vma structure at any moment, page_lock_anon_vma()
> needs to check page_mapped() again before succeeding, otherwise
> page_unlock_anon_vma() might address a different root->lock.
>
> Signed-off-by: Hugh Dickins<hughd@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>

And yes, AFAIK this code lived just in -mm up to now.

-- 
All rights reversed
