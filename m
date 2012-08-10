Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355Ab2HJXNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 19:13:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:11691 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab2HJXNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 19:13:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,748,1336374000"; 
   d="scan'208";a="206609312"
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Naoya Horiguchi <nhoriguc@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] HWPOISON: improve handling/reporting of memory error on dirty pagecache
References: <1344634913-13681-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1344634913-13681-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Fri, 10 Aug 2012 16:13:03 -0700
In-Reply-To: <1344634913-13681-4-git-send-email-n-horiguchi@ah.jp.nec.com>
	(Naoya Horiguchi's message of "Fri, 10 Aug 2012 17:41:53 -0400")
Message-ID: <m2628qcpds.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> Current error reporting of memory errors on dirty pagecache has silent
> data lost problem because AS_EIO in struct address_space is cleared
> once checked.

Seems very complicated.  I think I would prefer something simpler
if possible, especially unless it's proven the case is common.
It's hard to maintain rarely used error code when it's complicated.
Maybe try Fengguang's simple proposal first? That would fix other IO
errors too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
