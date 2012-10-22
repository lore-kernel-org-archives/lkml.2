Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab2JVN1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 09:27:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58849 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078Ab2JVN1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 09:27:40 -0400
Date: Mon, 22 Oct 2012 15:27:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] MM: Support more pagesizes for MAP_HUGETLB/SHM_HUGETLB v6
Message-ID: <20121022132733.GQ16230@one.firstfloor.org>
References: <1350665289-7288-1-git-send-email-andi@firstfloor.org> <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHO5Pa0W-WGBaPvzdRJxYPdrg-K9guChswo3KJheK4BaRzsRwQ@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe I am missing something obvious, but does this not conflict with
> include/uapi/asm-generic/mman-common.h:
> 
> #ifdef CONFIG_MMAP_ALLOW_UNINITIALIZED
> # define MAP_UNINITIALIZED 0x4000000
> ...
> 
> 0x4000000 == (1 << 26
> 

You're right. Someone added that since I wrote the patch originally.
I owned them when originally submitted @) Thanks for catching.

Have to move my bits two up, which will still work, but limit the
maximum page size slightly more, but will likely still work for most
people.

I'll send a new patch.

BTW seriously MAP_UNINITIALIZED? Who came up with that? 
MAP_COMPLETELY_INSECURE or MAP_INSANE would have been more appropiate.
Maybe I should list as an advantage that my patch will prohibit
too many further such "innovations".

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
