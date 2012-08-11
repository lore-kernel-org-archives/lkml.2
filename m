Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2HKBBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 21:01:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962Ab2HKBBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 21:01:31 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Rik van Riel <riel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] HWPOISON: improve handling/reporting of memory error on dirty pagecache
Date: Fri, 10 Aug 2012 21:01:15 -0400
Message-Id: <1344646875-17935-1-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <m2628qcpds.fsf@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 10, 2012 at 04:13:03PM -0700, Andi Kleen wrote:
> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:
> 
> > Current error reporting of memory errors on dirty pagecache has silent
> > data lost problem because AS_EIO in struct address_space is cleared
> > once checked.
> 
> Seems very complicated.  I think I would prefer something simpler
> if possible, especially unless it's proven the case is common.
> It's hard to maintain rarely used error code when it's complicated.

I'm not sure if memory error is a rare event, because I don't have
any numbers about that on real systems. But assuming that hwpoison
events are not rare, dirty pagecache error is not an ignorable case
because dirty page ratio is typically ~10% of total physical memory
in average systems. It may be small but not negligible.

> Maybe try Fengguang's simple proposal first? That would fix other IO
> errors too.

In my understanding, Fengguang's patch (specified in this patch's
description) only fixes memory error reporting. And I'm not sure
that similar appoarch (like making AS_EIO sticky) really fixes
the IO errors because this change can break userspace applications
which expect the current behavior.

Anyway, OK, I agree to start with Fengguang's one and separate
out the additional suggestion about "making dirty pagecache error
recoverable". And if possible, I want your feedback about the
additional part of my idea. Can I ask a favor?

Thanks,
Naoya
