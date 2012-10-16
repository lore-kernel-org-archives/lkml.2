Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab2JPFK4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:10:56 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61342 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755652Ab2JPFKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:10:55 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com>
References: <20121008150949.GA15130@redhat.com> <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com>
 <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 16 Oct 2012 01:10:34 -0400
Message-ID: <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com>
Subject: Re: mpol_to_str revisited.
To: David Rientjes <rientjes@google.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        bhutchings@solarflare.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 11:58 PM, David Rientjes <rientjes@google.com> wrote:
> On Mon, 15 Oct 2012, KOSAKI Motohiro wrote:
>
>> I don't think 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a is right fix.
>
> It's certainly not a complete fix, but I think it's a much better result
> of the race, i.e. we don't panic anymore, we simply fail the read()
> instead.

Even though 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a itself is simple. It bring
to caller complex. That's not good and have no worth.

>> we should
>> close a race (or kill remain ref count leak) if we still have.
>
> As I mentioned earlier in the thread, the read() is done here on a task
> while only a reference to the task_struct is taken and we do not hold
> task_lock() which is required for task->mempolicy.  Once that is fixed,
> mpol_to_str() should never be called for !task->mempolicy so it will never
> need to return -EINVAL in such a condition.

I agree that's obviously a bug and we should fix it.
