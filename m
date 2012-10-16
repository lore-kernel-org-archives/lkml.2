Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab2JPD6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 23:58:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61651 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab2JPD6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 23:58:36 -0400
Date: Mon, 15 Oct 2012 20:58:33 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        bhutchings@solarflare.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mpol_to_str revisited.
In-Reply-To: <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com>
References: <20121008150949.GA15130@redhat.com> <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012, KOSAKI Motohiro wrote:

> I don't think 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a is right fix.

It's certainly not a complete fix, but I think it's a much better result 
of the race, i.e. we don't panic anymore, we simply fail the read() 
instead.

> we should
> close a race (or kill remain ref count leak) if we still have.

As I mentioned earlier in the thread, the read() is done here on a task 
while only a reference to the task_struct is taken and we do not hold 
task_lock() which is required for task->mempolicy.  Once that is fixed, 
mpol_to_str() should never be called for !task->mempolicy so it will never 
need to return -EINVAL in such a condition.
