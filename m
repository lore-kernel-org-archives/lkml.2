Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932652Ab0KRR3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:29:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755182Ab0KRR3Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:29:24 -0500
MIME-Version: 1.0
In-Reply-To: <20101118114902.GJ8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <fc2579c9bddbfcf78d72.1288798060@v2.random>
 <20101118114902.GJ8135@csn.ul.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 09:28:27 -0800
Message-ID: <AANLkTik9U_r7tqdDYw24xwTgvp5c740Z9eMQeh8y4Hpi@mail.gmail.com>
Subject: Re: [PATCH 05 of 66] compound_lock
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 3:49 AM, Mel Gorman <mel@csn.ul.ie> wrote:
>> +
>> +static inline void compound_lock_irqsave(struct page *page,
>> +                                      unsigned long *flagsp)
>> +{
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> +     unsigned long flags;
>> +     local_irq_save(flags);
>> +     compound_lock(page);
>> +     *flagsp = flags;
>> +#endif
>> +}
>> +
>
> The pattern for spinlock irqsave passes in unsigned long, not unsigned
> long *. It'd be nice if they matched.

Indeed. Just make the thing return the flags the way the normal
spin_lock_irqsave() function does.

                  Linus
