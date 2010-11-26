Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab0KZWbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 17:31:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625Ab0KZWbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 17:31:02 -0500
MIME-Version: 1.0
In-Reply-To: <20101125173518.GR6118@random.random>
References: <patchbomb.1288798055@v2.random> <6022613f956ee326d9b6.1288798072@v2.random>
 <20101118125249.GN8135@csn.ul.ie> <AANLkTikhXS9ot27gS9OpRWbU9zjXns_D96DarZ1jOcR6@mail.gmail.com>
 <20101125173518.GR6118@random.random>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 27 Nov 2010 07:24:37 +0900
Message-ID: <AANLkTinasCexaptMzKkY7CO3SAAUiVvp+W=FAYkk+6+q@mail.gmail.com>
Subject: Re: [PATCH 17 of 66] add pmd mangling generic functions
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 2:35 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> On Thu, Nov 18, 2010 at 09:32:36AM -0800, Linus Torvalds wrote:
>> I dunno. Those macros are _way_ too big and heavy to be macros or
>> inline functions. Why aren't pmdp_splitting_flush() etc just
>> functions?
>
> That's because ptep_clear_flush and everything else in that file named
> with ptep_* and doing expensive tlb flushes was a macro.

That may be, and you needn't necessarily clean up old use (although
that might be nice as a separate thing), but I wish we didn't make
what is already messy bigger and messier.

         Linus
