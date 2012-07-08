Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2GHWxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 18:53:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51362 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab2GHWxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 18:53:37 -0400
Date: Sun, 8 Jul 2012 15:53:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        JoonSoo Kim <js1304@gmail.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: don't invoke __alloc_pages_direct_compact when order
 0
In-Reply-To: <CAAmzW4PXdpQ2zSnkx8sSScAt1OY0j4+HXVmf=COvP7eMLqrEvQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207081547140.18461@chino.kir.corp.google.com>
References: <1341588521-17744-1-git-send-email-js1304@gmail.com> <alpine.DEB.2.00.1207070139510.10445@chino.kir.corp.google.com> <CAAmzW4PXdpQ2zSnkx8sSScAt1OY0j4+HXVmf=COvP7eMLqrEvQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2012, JoonSoo Kim wrote:

> >> __alloc_pages_direct_compact has many arguments so invoking it is very costly.
> >> And in almost invoking case, order is 0, so return immediately.
> >>
> >
> > If "zero cost" is "very costly", then this might make sense.
> >
> > __alloc_pages_direct_compact() is inlined by gcc.
> 
> In my kernel image, __alloc_pages_direct_compact() is not inlined by gcc.

Adding Andrew and Mel to the thread since this would require that we 
revert 11e33f6a55ed ("page allocator: break up the allocator entry point 
into fast and slow paths") which would obviously not be a clean revert 
since there have been several changes to these functions over the past 
three years.

I'm stunned (and skeptical) that __alloc_pages_direct_compact() is not 
inlined by your gcc, especially since the kernel must be compiled with 
optimization (either -O1 or -O2 which causes these functions to be 
inlined).  What version of gcc are you using and on what architecture?  
Please do "make mm/page_alloc.s" and send it to me privately, I'll file 
this and fix it up on gcc-bugs.

I'll definitely be following up on this.
