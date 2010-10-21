Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0JUHRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:17:39 -0400
Received: from fep18.mx.upcmail.net ([62.179.121.38]:36732 "EHLO
	fep18.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0JUHRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:17:38 -0400
X-SourceIP: 80.56.199.130
Subject: Re: mmotm 2010-10-20-15-01 uploaded
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20101020204649.46361931.akpm@linux-foundation.org>
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
	 <4CBFAB7B.7080306@cn.fujitsu.com> <4CBFB06B.3020305@cn.fujitsu.com>
	 <20101020204649.46361931.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 09:17:26 +0200
Message-ID: <1287645446.3488.56.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=BBXmjR/jrMMj1wHBsuD7Cdv69cLzNztNz9uR8CXiauo= c=1 sm=0 a=OHuDnJXnxFEA:10 a=IkcTkHD0fZMA:10 a=2F5E-7aXOXnKwpUEvboA:9 a=2lYgmc_wo3q56ufZuZorqYViq9UA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 20:46 -0700, Andrew Morton wrote:
> 
> > ------------[ cut here ]------------
> > WARNING: at arch/x86/mm/highmem_32.c:82 __kunmap_atomic+0x80/0xd4()
> 
>                 WARN_ON_ONCE(idx !=
>                         ((vaddr - __fix_to_virt(FIX_KMAP_BEGIN)) >> PAGE_SHIFT));
> 
> > Hardware name: ASPIRE AG1720
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted 2.6.36-rc8-mm1+ #1
> > Call Trace:
> >  [<c0440982>] warn_slowpath_common+0x6a/0x7f
> >  [<c042e6c5>] ? __kunmap_atomic+0x80/0xd4
> >  [<c04409ab>] warn_slowpath_null+0x14/0x18
> >  [<c042e6c5>] __kunmap_atomic+0x80/0xd4
> >  [<c04f2d1f>] zero_user_segments+0x5e/0x64
> >  [<c04f2e58>] simple_write_begin+0x5e/0x6c
> >  [<c04a6518>] generic_file_buffered_write+0xc0/0x1c5

<snip>

> It would have been clearer to do
> 
>         WARN_ON_ONCE(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx))
> 
> but I don't see what's gone wrong here.  Peter?

Right, so that's the warning that the unmapped address isn't actually
the top-of-stack one.

Your version is much nicer, although I haven't looked too hard at it, I
probably got my head in a twist.

But like you, I cannot directly see what's going wrong here,
zero_user_segments() seems a simple enough function without any
kmap_atomic nesting, so I'm not at all seeing how that's going wrong.

/me goes find where you hide your mmotm patch-queue and stare at the
actual code.

