Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab1AUGCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:02:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:58862 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab1AUGC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:02:29 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D392227.6030603@np.css.fujitsu.com>
Date: Fri, 21 Jan 2011 15:05:27 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Fix the wrong corrupted page information of hugetlb
 page.
References: <4D38E04A.8050402@np.css.fujitsu.com> <20110121051251.GA16406@spritzera.linux.bs1.fc.nec.co.jp>
In-Reply-To: <20110121051251.GA16406@spritzera.linux.bs1.fc.nec.co.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Naoya-san

(2011/01/21 14:12), Naoya Horiguchi wrote:
> Hi,
> 
>> @@ -991,18 +995,32 @@ int __memory_failure(unsigned long pfn, int trapno, int flags)
>>  			action_result(pfn, "free buddy", DELAYED);
>>  			return 0;
>>  		} else if (PageHuge(hpage)) {
>> -			/*
>> -			 * Check "just unpoisoned", "filter hit", and
>> -			 * "race with other subpage."
>> -			 */
>>  			lock_page_nosync(hpage);
>> -			if (!PageHWPoison(p)
>> -			    || (hwpoison_filter(p) && TestClearPageHWPoison(p))
>> -			    || (p != hpage && TestSetPageHWPoison(hpage))) {
>> -				atomic_long_sub(nr_pages, &mce_bad_pages);
>> +			/* Check "just unpoisoned". */
>> +			if (!PageHWPoison(hpage)) {
>                                           ^^^^^
> Isn't this "p" (as you changed in patch 2/3) ?
Yes, you are right.
I will send a new one as soon as possible.

Thanks.

Best Regards,
Jin Dongming
> 
> -- Naoya Horiguchi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


