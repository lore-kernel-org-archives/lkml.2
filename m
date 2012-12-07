Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875Ab2LGHyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 02:54:53 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:48034 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab2LGHyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 02:54:52 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi.kleen@intel.com>, Tony Luck <tony.luck@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/3] HWPOISON, hugetlbfs: fix warning on freeing hwpoisoned hugepage
In-Reply-To: <1354860882-14567-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1354860882-14567-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Notmuch/0.14+97~g3977b25 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Fri, 07 Dec 2012 13:24:45 +0530
Message-ID: <878v9acn5m.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120707-8256-0000-0000-00000555E79E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> On Fri, Dec 07, 2012 at 11:06:41AM +0530, Aneesh Kumar K.V wrote:
> ...
>> > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> > Date: Thu, 6 Dec 2012 20:54:30 -0500
>> > Subject: [PATCH v2] HWPOISON, hugetlbfs: fix warning on freeing hwpoisoned
>> >  hugepage
>> >
>> > This patch fixes the warning from __list_del_entry() which is triggered
>> > when a process tries to do free_huge_page() for a hwpoisoned hugepage.
>> 
>> 
>> Can you get a dump stack for that. I am confused because the page was
>> already in freelist, and we deleted it from the list and set the
>> refcount to 1. So how are we reaching free_huge_page() again ?
>
> free_huge_page() can be called for hwpoisoned hugepage from unpoison_memory().
> This function gets refcount once and clears PageHWPoison, and then puts
> refcount twice to return the hugepage back to free pool.
> The second put_page() finally reaches free_huge_page().
>

Can we add this also to the commit message ?. With that you can add

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Thanks
-aneesh

