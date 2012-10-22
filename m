Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335Ab2JVNfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:35:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58858 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab2JVNff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:35:35 -0400
Date: Mon, 22 Oct 2012 15:35:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v6
Message-ID: <20121022133534.GR16230@one.firstfloor.org>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org> <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com> <20121022132733.GQ16230@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121022132733.GQ16230@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 03:27:33PM +0200, Andi Kleen wrote:
> > Maybe I am missing something obvious, but does this not conflict with
> > include/uapi/asm-generic/mman-common.h:
> > 
> > #ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
> > # define MAP_UNINITIALIZED 0x4000000
> > ...
> > 
> > 0x4000000 == (1 << 26
> > 
> 
> You're right. Someone added that since I wrote the patch originally.
> I owned them when originally submitted @) Thanks for catching.
> 
> Have to move my bits two up, which will still work, but limit the

Two up won't work, need one up.  

32..28 = 16  is too small for 2^30 = 1GB pages
32..27 = 32  max 4GB pages

So this will use up all remaining flag bits now.

-Andi
