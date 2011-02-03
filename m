Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab1BCTe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 14:34:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:55268 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab1BCTe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 14:34:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,421,1291622400"; 
   d="scan'208";a="703766361"
Subject: Re: [patch] x86, mm: avoid stale tlb entries by clearing prev
 mm_cpumask after switching mm
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Mallick, Asit K" <asit.k.mallick@intel.com>
In-Reply-To: <AANLkTimuSV273ksidN_vQ4o1rLr6D--9Q3dNnBiB13-K@mail.gmail.com>
References: <1296677247.4418.103.camel@sbsiddha-MOBL3.sc.intel.com>
	 <AANLkTi=P+aoY4GY32xa8D8gHbDP73QpPmzvKbB4VM7g2@mail.gmail.com>
	 <AANLkTinvQatNF0ZJqmvuKYNq7oKXqfR5Ke1FuaSLFNEF@mail.gmail.com>
	 <1296757637.4418.1482.camel@sbsiddha-MOBL3.sc.intel.com>
	 <AANLkTimuSV273ksidN_vQ4o1rLr6D--9Q3dNnBiB13-K@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 03 Feb 2011 11:34:31 -0800
Message-Id: <1296761671.4418.1558.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-03 at 11:13 -0800, Linus Torvalds wrote:
> On Thu, Feb 3, 2011 at 10:27 AM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> >> Actually, for normal entries I could well imagine the code that wants
> >> to do a flush before freeing the page caring.
> >>
> >> So I think the _patch_ may be correct, but the changelog is definitely
> >> not correct, and needs serious surgery to explain what the bug that
> >> this fixes actually is.
> >
> > Linus, I updated the changelog to explain the failing case in more
> > detail. Please review. Thanks.
> 
> So this explains the bug, and the explanation looks good. Except for
> one (large) detail: it has nothing to do with "stale" entries.
> 
> The problematic entries are simply _bogus_, not stale. They were never
> valid to begin with. So the subject and the initial part is very
> misleading.

True. 'stale' is the wrong word. Do you want me to send a corrected one
by replacing it with 'bogus'?

> The global bit seems to be largely irrelevant too, except for the fact
> that a global bogus entry obviously stays around and causes way more
> trouble. But I could imagine that there could be trouble with entries
> that have conflicting PSE or cacheability issues (causing machine
> checks or something) even if they are ephemeral and not global.

my understanding is that unless we end up using that TLB entry, we will
not have the issues like machine checks due to cacheability issues etc.
If it is not global, upcoming cr3 change will flush it and meanwhile I
don't think there is a scenario where we refer to these user-addresses.

thanks,
suresh

