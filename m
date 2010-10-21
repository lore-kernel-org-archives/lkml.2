Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab0JUHa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:30:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751360Ab0JUHaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:30:25 -0400
Date: Thu, 21 Oct 2010 00:30:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-10-20-15-01 uploaded
Message-Id: <20101021003008.064302ad.akpm@linux-foundation.org>
In-Reply-To: <1287645446.3488.56.camel@twins>
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>
	<4CBFAB7B.7080306@cn.fujitsu.com>
	<4CBFB06B.3020305@cn.fujitsu.com>
	<20101020204649.46361931.akpm@linux-foundation.org>
	<1287645446.3488.56.camel@twins>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010 09:17:26 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > It would have been clearer to do
> > 
> >         WARN_ON_ONCE(vaddr != __fix_to_virt(FIX_KMAP_BEGIN + idx))
> > 
> > but I don't see what's gone wrong here.  Peter?
> 
> Right, so that's the warning that the unmapped address isn't actually
> the top-of-stack one.
> 
> Your version is much nicer, although I haven't looked too hard at it, I
> probably got my head in a twist.
> 
> But like you, I cannot directly see what's going wrong here,
> zero_user_segments() seems a simple enough function without any
> kmap_atomic nesting, so I'm not at all seeing how that's going wrong.
> 
> /me goes find where you hide your mmotm patch-queue and stare at the
> actual code.

hm, OK.  The x86 guys have been mucking with the fixmap code lately but
I don't see anything which could cause this.

btw, it's a bit sad to use KM_TYPE_NR*NR_CPUS pages of virtual address
space for kmap_atomic().  I'd expect that distros set NR_CPUS quite
large (Fedora has 256).  That's 20MB of virtual address space consumed,
I think.

And we consume it on non-highmem kernels, too...
