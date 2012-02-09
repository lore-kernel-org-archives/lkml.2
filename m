Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758024Ab2BIEQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 23:16:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984Ab2BIEQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 23:16:38 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] pagemap: introduce data structure for pagemap entry
Date: Wed,  8 Feb 2012 23:16:20 -0500
Message-Id: <1328760980-3460-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20120209112936.1395fc2c.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 09, 2012 at 11:29:36AM +0900, KAMEZAWA Hiroyuki wrote:
> On Wed,  8 Feb 2012 10:51:42 -0500
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > Currently a local variable of pagemap entry in pagemap_pte_range()
> > is named pfn and typed with u64, but it's not correct (pfn should
> > be unsigned long.)
> 
> Does this means "the name 'pfn' implies unsigned long, usually. And
> this usage is confusing." ?

Yes, that is one I meant.
And another meaning is that this variable can contain not only page frame
number but also other information about page state. The format of pagemap
entry is described in a comment above pagemap_read() like this

 * Bits 0-55  page frame number (PFN) if present
 * Bits 0-4   swap type if swapped
 * Bits 5-55  swap offset if swapped
 * Bits 55-60 page shift (page size = 1<<page shift)
 * Bit  61    reserved for future use
 * Bit  62    page swapped
 * Bit  63    page present
 *
 * If the page is not present but in swap, then the PFN contains an
 * encoding of the swap file number and the page's offset into the
 * swap. Unmapped pages return a null PFN. This allows determining
 * precisely which pages are mapped (or in swap) and comparing mapped
 * pages between processes.

. So the name 'pfn' does not exactly match what it represents.


> > This patch introduces special type for pagemap entry and replace
> > code with it.
> > 
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > 
> 
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thank you.
