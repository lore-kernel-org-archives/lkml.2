Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423948Ab2LGCS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 21:18:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964925Ab2LGCSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 21:18:25 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] HWPOISON, hugetlbfs: fix warning on freeing hwpoisoned hugepage
Date: Thu,  6 Dec 2012 21:18:14 -0500
Message-Id: <1354846694-6101-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F1C963B5E@ORSMSX108.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 10:13:42PM +0000, Luck, Tony wrote:
> > This patch fixes the warning from __list_del_entry() which is triggered
> > when a process tries to do free_huge_page() for a hwpoisoned hugepage.
> 
> Ultimately it would be nice to avoid poisoning huge pages. Generally we know the
> location of the poison to a cache line granularity (but sometimes only to a 4K
> granularity) ... and it is rather inefficient to take an entire 2M page out of service.
> With 1G pages things would be even worse!!

Thanks for the comment.
And yes, it's remaining work to be done.

> It also makes life harder for applications that would like to catch the SIGBUS
> and try to take their own recovery actions. Losing more data than they really
> need to will make it less likely that they can do something to work around the
> loss.
> 
> Has anyone looked at how hard it might be to have the code in memory-failure.c
> break up a huge page and only poison the 4K that needs to be taken out of service?

This work is one of my interest and became a bit easier than used to be,
because now transparent hugepage works commonly and some of code can be
copied from or shared with it.

Thanks,
Naoya
