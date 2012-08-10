Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab2HJXJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 19:09:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:16792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab2HJXJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 19:09:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,748,1336374000"; 
   d="scan'208";a="179173690"
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Naoya Horiguchi <nhoriguc@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] HWPOISON: undo memory error handling for dirty pagecache
References: <1344634913-13681-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1344634913-13681-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Fri, 10 Aug 2012 16:09:48 -0700
In-Reply-To: <1344634913-13681-3-git-send-email-n-horiguchi@ah.jp.nec.com>
	(Naoya Horiguchi's message of "Fri, 10 Aug 2012 17:41:52 -0400")
Message-ID: <m2a9y2cpj7.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> Current memory error handling on dirty pagecache has a bug that user
> processes who use corrupted pages via read() or write() can't be aware
> of the memory error and result in discarding dirty data silently.
>
> The following patch is to improve handling/reporting memory errors on
> this case, but as a short term solution I suggest that we should undo
> the present error handling code and just leave errors for such cases
> (which expect the 2nd MCE to panic the system) to ensure data consistency.

Not sure that's the right approach. It's not worse than any other IO 
errors isn't it? 

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
