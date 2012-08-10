Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab2HJXIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 19:08:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:13690 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756193Ab2HJXIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 19:08:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,748,1336374000"; 
   d="scan'208";a="197229877"
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <andi.kleen@intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Naoya Horiguchi <nhoriguc@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] HWPOISON: fix action_result() to print out dirty/clean
References: <1344634913-13681-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1344634913-13681-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Fri, 10 Aug 2012 16:08:10 -0700
In-Reply-To: <1344634913-13681-2-git-send-email-n-horiguchi@ah.jp.nec.com>
	(Naoya Horiguchi's message of "Fri, 10 Aug 2012 17:41:51 -0400")
Message-ID: <m2ehnecplx.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> action_result() fails to print out "dirty" even if an error occurred on a
> dirty pagecache, because when we check PageDirty in action_result() it was
> cleared after page isolation even if it's dirty before error handling. This
> can break some applications that monitor this message, so should be fixed.
>
> There are several callers of action_result() except page_action(), but
> either of them are not for LRU pages but for free pages or kernel pages,
> so we don't have to consider dirty or not for them.

Looks good

Reviewed-by: Andi Kleen <ak@linux.intel.com>


-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
