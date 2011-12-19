Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab1LSTCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 14:02:25 -0500
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:48131 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1LSTCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 14:02:21 -0500
Message-ID: <4EEF888C.4030101@ah.jp.nec.com>
Date: Mon, 19 Dec 2011 13:55:08 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Organization: NEC Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/3] pagemap: export KPF_THP
References: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324319919-31720-3-git-send-email-n-horiguchi@ah.jp.nec.com> <20111219184047.GA5637@one.firstfloor.org>
In-Reply-To: <20111219184047.GA5637@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 19, 2011 at 07:40:47PM +0100, Andi Kleen wrote:
> > diff --git 3.2-rc5.orig/fs/proc/page.c 3.2-rc5/fs/proc/page.c
> > index 6d8e6a9..d436fc6 100644
> > --- 3.2-rc5.orig/fs/proc/page.c
> > +++ 3.2-rc5/fs/proc/page.c
> > @@ -116,6 +116,11 @@ u64 stable_page_flags(struct page *page)
> >  	if (PageHuge(page))
> >  		u |= 1 << KPF_HUGE;
> >  
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +	if (PageTransCompound(page))
> > +		u |= 1 << KPF_THP;
> > +#endif
> 
> It would be better to have PageTransCompound be a dummy (always 0) 
> for !CONFIG_TRANSPARENT_HUGEPAGE and KPF_THP always defined.
> This would keep ifdefery in the headers.

OK, I'll do it in the next post.
Thanks for the feedback.

Naoya
