Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317Ab2HITKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 15:10:12 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:49879 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759269Ab2HITJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 15:09:42 -0400
Date: Thu, 9 Aug 2012 14:08:10 -0500 (CDT)
From: "Christoph Lameter (Open Source)" <cl@linux.com>
X-X-Sender: cl@greybox.home
To: Shuah Khan <shuah.khan@hp.com>
cc: penberg@kernel.org, glommer@parallels.com, js1304@gmail.com,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, shuahkhan@gmail.com
Subject: Re: [PATCH v2] mm: Restructure kmem_cache_create() to move debug
 cache integrity checks into a new function
In-Reply-To: <1344531695.2393.27.camel@lorien2>
Message-ID: <alpine.DEB.2.02.1208091406590.20908@greybox.home>
References: <1342221125.17464.8.camel@lorien2> <CAOJsxLGjnMxs9qERG5nCfGfcS3jy6Rr54Ac36WgVnOtP_pDYgQ@mail.gmail.com> <1344224494.3053.5.camel@lorien2> <1344266096.2486.17.camel@lorien2> <CAAmzW4Ne5pD90r+6zrrD-BXsjtf5OqaKdWY+2NSGOh1M_sWq4g@mail.gmail.com>
 <1344272614.2486.40.camel@lorien2> <1344287631.2486.57.camel@lorien2> <alpine.DEB.2.02.1208090911100.15909@greybox.home> <1344531695.2393.27.camel@lorien2>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012, Shuah Khan wrote:

> Moving these checks into kmem_cache_sanity_check() would mean return
> path handling will change. The first block of sanity checks for name,
> and size etc. are done before holding the slab_mutex and the second
> block that checks the slab lists is done after holding the mutex.
> Depending on which one fails, return handling is going to be different
> in that if second block fails, mutex needs to be unlocked and when the
> first block fails, there is no need to do that. Nothing that is too
> complex to solve, just something that needs to be handled.

Right. The taking of the mutex etc is not depending on the parameters at
all. So its possible. Its rather simple.

> Comments, thoughts on
>
> 1. just remove size from kmem_cache_sanity_check() parameters
> or
> 2. move first block sanity checks into kmem_cache_sanity_check()
>
> Personally I prefer the first option to avoid complexity in return path
> handling. Would like to hear what others think.

We already have to deal with the return path handling for other failure
cases.

