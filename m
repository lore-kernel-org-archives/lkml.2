Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab1BIGqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 01:46:30 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55792 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab1BIGq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 01:46:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 9 Feb 2011 15:40:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [mmotm] BUG: Bad page state in process khugepaged ?
Message-Id: <20110209154017.f6489f4e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110209151036.f24a36a6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110209151036.f24a36a6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Feb 2011 15:10:36 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 2nd log, "kernel BUG at include/linux/mm.h:420!" is  This one.
> ==
> static inline void __ClearPageBuddy(struct page *page)
> {
>         VM_BUG_ON(!PageBuddy(page));
>         atomic_set(&page->_mapcount, -1);
> }
> ==
> But this is just a tail of bad_page().
> ==
> static void bad_page(struct page *page)
> {
>         static unsigned long resume;
>         static unsigned long nr_shown;
>         static unsigned long nr_unshown;
> ...
>         dump_stack();
> out:
>         /* Leave bad fields for debug, except PageBuddy could make trouble */
>         __ClearPageBuddy(page);
>         add_taint(TAINT_BAD_PAGE);
> }
> ==
> So, what important is bad_page().
> 
> BAD page says
> ==
> BUG: Bad page state in process khugepaged  pfn:1e9800
> page:ffffea0006b14000 count:0 mapcount:0 mapping:          (null) index:0x2800
> page flags: 0x40000000004000(head)
> pc:ffff880214a30000 pc->flags:2146246697418756 pc->mem_cgroup:ffffc9000177a000
> ==
> 
> Maybe page_mapcount(page) was > 0. and ->mapping was NULL.
Sorry please ignore above. bad_page() used page_mapcount().


Regards,
-Kame





