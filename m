Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab1LVAe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:34:58 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38870 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab1LVAe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:34:56 -0500
MIME-Version: 1.0
In-Reply-To: <20111221163240.ef73f77e.akpm@linux-foundation.org>
References: <20111222001800.GL9213@google.com>
	<20111222001939.GM9213@google.com>
	<20111221163240.ef73f77e.akpm@linux-foundation.org>
Date: Wed, 21 Dec 2011 16:34:55 -0800
X-Google-Sender-Auth: la2QXDJWn_H4n1HVM0gRjbFVWsg
Message-ID: <CAOS58YOGPvtdTna_yNn=_=H1De75Di8OH4FGqwdJZs7EYG0dEA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mempool: fix first round failure behavior
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Wed, Dec 21, 2011 at 4:32 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> This is a significant change in behaviour.  Previously the mempool code
> would preserve emergency pools while waiting for someone to return an
> item.  Now, it will permit many more items to be allocated, chewing
> into the emergency pools.
>
> We *know* that items will soon become available, so why not wait for
> that to happen rather than consuming memory which less robust callers
> could have utilised?
>
> IOW, this change appears to make the kernel more vulnerable to memory
> exhaustion failures?

Yeah, that's me misreading the code.  mempool allocator doesn't retry
with the original gfp mask.  It does with umm... less modified one, so
the patch description is wrong but the behavior w.r.t. emergency pool
doesn't change. I'm rewriting the commit message.

Thanks.

-- 
tejun
