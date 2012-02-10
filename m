Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728Ab2BJA1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:27:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab2BJA1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:27:42 -0500
Date: Thu, 9 Feb 2012 16:27:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, David Rientjes <rientjes@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] pagemap: introduce data structure for pagemap entry
Message-Id: <20120209162741.283ecb76.akpm@linux-foundation.org>
In-Reply-To: <1328716302-16871-7-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1328716302-16871-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1328716302-16871-7-git-send-email-n-horiguchi@ah.jp.nec.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Feb 2012 10:51:42 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Currently a local variable of pagemap entry in pagemap_pte_range()
> is named pfn and typed with u64, but it's not correct (pfn should
> be unsigned long.)
> This patch introduces special type for pagemap entry and replace
> code with it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> 
> Changes since v4:
>   - Rename pme_t to pagemap_entry_t

hm.  Why this change?  I'd have thought that this should be called
pme_t.  And defined in or under pgtable.h, rather than being private to
fs/proc/task_mmu.c.
