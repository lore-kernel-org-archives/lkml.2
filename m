Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab1E1X4j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 19:56:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754852Ab1E1X4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 19:56:37 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinsq-XJGvRVmBa6kRp0RTj9NqGWtA@mail.gmail.com>
References: <alpine.LSU.2.00.1105281317090.13319@sister.anvils>
 <1306617270.2497.516.camel@laptop> <alpine.LSU.2.00.1105281437320.13942@sister.anvils>
 <BANLkTinsq-XJGvRVmBa6kRp0RTj9NqGWtA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 May 2011 16:56:11 -0700
Message-ID: <BANLkTinoFnTjCDL8B2HEYdYHqbMgCw_RrQ@mail.gmail.com>
Subject: Re: [PATCH] mm: fix page_lock_anon_vma leaving mutex locked
To: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 4:24 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That said, I do agree with the "anon_vma_root" part of your patch. I
> just think you mixed up two independent issues with it: the fact that
> we may be unlocking a new root, and the precise check used to
> determine whether the anon_vma might have changed.

Thinking some more about it, I end up agreeing with the whole patch.
The "page_mapped()" test is what we use in the slow-path after
incrementing the anon_vma count too when the trylock didn't work too,
so it can't be too wrong.

So I'm going to apply it as-is as an improvement (at least we won't be
unlocking the wrong anon_vma root), and hope that you and Peter end up
agreeing about what the sufficient test is for whether the anon_vma is
the right one.

                             Linus
