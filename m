Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab2GPXse (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 19:48:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34334 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2GPXs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 19:48:28 -0400
Date: Mon, 16 Jul 2012 16:48:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Shuah Khan <shuah.khan@hp.com>, Pekka Enberg <penberg@kernel.org>,
        glommer@parallels.com, js1304@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH TRIVIAL] mm: Fix build warning in kmem_cache_create()
In-Reply-To: <alpine.DEB.2.00.1207161506390.32319@router.home>
Message-ID: <alpine.DEB.2.00.1207161642420.18232@chino.kir.corp.google.com>
References: <1342221125.17464.8.camel@lorien2> <alpine.DEB.2.00.1207140216040.20297@chino.kir.corp.google.com> <CAOJsxLE3dDd01WaAp5UAHRb0AiXn_s43M=Gg4TgXzRji_HffEQ@mail.gmail.com> <1342407840.3190.5.camel@lorien2> <alpine.DEB.2.00.1207160257420.11472@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1207160915470.28952@router.home> <alpine.DEB.2.00.1207161253240.29012@chino.kir.corp.google.com> <alpine.DEB.2.00.1207161506390.32319@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Christoph Lameter wrote:

> > Sounds like a response from someone who is very familiar with slab
> > allocators.  The reality, though, is that very few people are going to be
> > doing development with CONFIG_DEBUG_VM enabled unless they notice problems
> > beforehand.
> 
> Kernels are certainly run with CONFIG_DEBUG_VM before merges to mainstream
> occur. If the developer does not do it then someone else will.
> 

So let's say a developer wants to pass a dynamically allocated string to 
kmem_cache_create() for the cache name and it happens to be NULL because 
of a failed allocation but this never happened in testing (or it does 
happen but CONFIG_DEBUG_VM=n) and they are using CONFIG_SLAB.

What would the failure be in linux-next?  It looks like it would just 
result in a corrupted slabinfo.  Bad result, we used to catch this problem 
before the extraction of common functionality and now we've allowed a 
corrupted slabinfo for nothing: optimizing kmem_cache_create() is 
pointless.

> The kernel cannot check everything and will blow up in unexpected ways if
> someone codes something stupid. There are numerous debugging options that
> need to be switched on to get better debugging information to investigate
> deper. Adding special code to replicate these checks is bad.
> 

Disagree, CONFIG_SLAB does not blow up for a NULL name string and just 
corrupts userspace.
