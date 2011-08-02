Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1HBOZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 10:25:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab1HBOZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 10:25:03 -0400
Date: Tue, 2 Aug 2011 15:24:59 +0100
From: Mel Gorman <mgorman@suse.de>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel BUG at mm/vmscan.c:1114
Message-ID: <20110802142459.GF10436@suse.de>
References: <CAJn8CcE20-co4xNOD8c+0jMeABrc1mjmGzju3xT34QwHHHFsUA@mail.gmail.com>
 <CAJn8CcG-pNbg88+HLB=tRr26_R+A0RxZEWsJQg4iGe4eY2noXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJn8CcG-pNbg88+HLB=tRr26_R+A0RxZEWsJQg4iGe4eY2noXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 03:09:57PM +0800, Xiaotian Feng wrote:
> Hi,
>    I'm hitting the kernel BUG at mm/vmscan.c:1114 twice, each time I
> was trying to build my kernel. The photo of crash screen and my config
> is attached. Thanks.
> Regards
> Xiaotian

I am obviously blind because in 3.0, I cannot see what BUG is at
mm/vmscan.c:1114 :(. I see

1109:			/*
1110:			 * If we don't have enough swap space, reclaiming of
1111:			 * anon page which don't already have a swap slot is
1112:			 * pointless.
1113:			 */
1114:			if (nr_swap_pages <= 0 && PageAnon(cursor_page) &&
1115:			    !PageSwapCache(cursor_page))
1116:				break;
1117:
1118:			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
1119:				list_move(&cursor_page->lru, dst);
1120:				mem_cgroup_del_lru(cursor_page);

Is this 3.0 vanilla or are there some other patches applied?

-- 
Mel Gorman
SUSE Labs
