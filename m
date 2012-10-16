Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2JPGKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:10:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37705 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2JPGKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:10:12 -0400
Date: Mon, 15 Oct 2012 23:10:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        bhutchings@solarflare.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: mpol_to_str revisited.
In-Reply-To: <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210152306320.9480@chino.kir.corp.google.com>
References: <20121008150949.GA15130@redhat.com> <CAHGf_=pr1AYeWZhaC2MKN-XjiWB7=hs92V0sH-zVw3i00X-e=A@mail.gmail.com> <alpine.DEB.2.00.1210152055150.5400@chino.kir.corp.google.com> <CAHGf_=rLjQbtWQLDcbsaq5=zcZgjdveaOVdGtBgBwZFt78py4Q@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, KOSAKI Motohiro wrote:

> >> I don't think 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a is right fix.
> >
> > It's certainly not a complete fix, but I think it's a much better result
> > of the race, i.e. we don't panic anymore, we simply fail the read()
> > instead.
> 
> Even though 80de7c3138ee9fd86a98696fd2cf7ad89b995d0a itself is simple. It bring
> to caller complex. That's not good and have no worth.
> 

Before: the kernel panics, all workloads cease.
After: the file shows garbage, all workloads continue.

This is better, in my opinion, but at best it's only a judgment call and 
has no effect on anything.

I agree it would be better to respect the return value of mpol_to_str() 
since there are other possible error conditions other than a freed 
mempolicy, but let's not consider reverting 80de7c3138.  It is obviously 
not a full solution to the problem, though, and we need to serialize with 
task_lock().

Dave, are you interested in coming up with a patch?
