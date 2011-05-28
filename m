Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab1E1XZL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 19:25:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755277Ab1E1XZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 19:25:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1105281437320.13942@sister.anvils>
References: <alpine.LSU.2.00.1105281317090.13319@sister.anvils>
 <1306617270.2497.516.camel@laptop> <alpine.LSU.2.00.1105281437320.13942@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 May 2011 16:24:42 -0700
Message-ID: <BANLkTinsq-XJGvRVmBa6kRp0RTj9NqGWtA@mail.gmail.com>
Subject: Re: [PATCH] mm: fix page_lock_anon_vma leaving mutex locked
To: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 3:02 PM, Hugh Dickins <hughd@google.com> wrote:
>
> But I'm replying before I've given it enough thought,
> mainly to let you know that I am back on it now.

So I applied your other two patches as obvious, but not this one.

I'm wondering - wouldn't it be nicer to just re-check (after getting
the anon_vma lock) that page->mapping still matches anon_mapping?

That said, I do agree with the "anon_vma_root" part of your patch. I
just think you mixed up two independent issues with it: the fact that
we may be unlocking a new root, and the precise check used to
determine whether the anon_vma might have changed.

So my gut feeling is that we should do the "anon_vma" root thing
independently as a fix for the "maybe anon_vma->root changed" issue,
and then as a separate patch decide on how to check whether anon_vma
is still valid.

Hmm?

                   Linus
