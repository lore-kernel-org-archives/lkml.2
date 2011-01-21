Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750955Ab1AUFNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 00:13:45 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41392 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1AUFNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 00:13:44 -0500
Date: Fri, 21 Jan 2011 14:12:51 +0900
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Fix the wrong corrupted page information of hugetlb
 page.
Message-ID: <20110121051251.GA16406@spritzera.linux.bs1.fc.nec.co.jp>
References: <4D38E04A.8050402@np.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
In-Reply-To: <4D38E04A.8050402@np.css.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> @@ -991,18 +995,32 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
>  			action_result(pfn, "free buddy", DELAYED);
>  			return 0;
>  		} else if (PageHuge(hpage)) {
> -			/*
> -			 * Check "just unpoisoned", "filter hit", and
> -			 * "race with other subpage."
> -			 */
>  			lock_page_nosync(hpage);
> -			if (!PageHWPoison(p)
> -			    || (hwpoison_filter(p) && TestClearPageHWPoison(p))
> -			    || (p != hpage && TestSetPageHWPoison(hpage))) {
> -				atomic_long_sub(nr_pages, &mce_bad_pages);
> +			/* Check "just unpoisoned". */
> +			if (!PageHWPoison(hpage)) {
                                          ^^^^^
Isn't this "p" (as you changed in patch 2/3) ?

-- Naoya Horiguchi
