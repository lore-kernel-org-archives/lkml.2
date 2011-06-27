Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab1F0HpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 03:45:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59191 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948Ab1F0Hm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 03:42:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E08346F.3070203@jp.fujitsu.com>
Date: Mon, 27 Jun 2011 16:42:39 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: andrea@betterlinux.com
CC: akpm@linux-foundation.org, minchan.kim@gmail.com, riel@redhat.com,
        peterz@infradead.org, hannes@cmpxchg.org,
        kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, hughd@google.com,
        jamesjer@betterlinux.com, marcus@bluehost.com, matt@bluehost.com,
        tytso@mit.edu, shaohua.li@intel.com, P@draigBrady.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] fadvise: support POSIX_FADV_NOREUSE
References: <1308923350-7932-1-git-send-email-andrea@betterlinux.com> <4E07F349.2040900@jp.fujitsu.com> <20110627071139.GC1247@thinkpad>
In-Reply-To: <20110627071139.GC1247@thinkpad>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>  POSIX_FADV_DONTNEED = drop page cache if possible
>>>  POSIX_FADV_NOREUSE = reduce page cache eligibility
>>
>> Eeek.
>>
>> Your POSIX_FADV_NOREUSE is very different from POSIX definition.
>> POSIX says,
>>
>>        POSIX_FADV_NOREUSE
>>               Specifies that the application expects to access the specified data once  and  then
>>               not reuse it thereafter.
>>
>> IfI understand correctly, it designed for calling _before_ data access
>> and to be expected may prevent lru activation. But your NORESE is designed
>> for calling _after_ data access. Big difference might makes a chance of
>> portability issue.
> 
> You're right. NOREUSE is designed to implement drop behind policy.
> 
> I'll post a new patch that will plug this logic in DONTNEED (like the
> presious version), but without breaking the old /proc/sys/vm/drop_caches
> behavior.

Great!

thanks.



