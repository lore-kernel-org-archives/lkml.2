Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab0KRRdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:33:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932726Ab0KRRdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:33:37 -0500
MIME-Version: 1.0
In-Reply-To: <20101118125249.GN8135@csn.ul.ie>
References: <patchbomb.1288798055@v2.random> <6022613f956ee326d9b6.1288798072@v2.random>
 <20101118125249.GN8135@csn.ul.ie>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Nov 2010 09:32:36 -0800
Message-ID: <AANLkTikhXS9ot27gS9OpRWbU9zjXns_D96DarZ1jOcR6@mail.gmail.com>
Subject: Re: [PATCH 17 of 66] add pmd mangling generic functions
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 4:52 AM, Mel Gorman <mel@csn.ul.ie> wrote:
> On Wed, Nov 03, 2010 at 04:27:52PM +0100, Andrea Arcangeli wrote:
>> From: Andrea Arcangeli <aarcange@redhat.com>
>>
>> Some are needed to build but not actually used on archs not supporting
>> transparent hugepages. Others like pmdp_clear_flush are used by x86 too.
>>
>> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
>> Acked-by: Rik van Riel <riel@redhat.com>
>
> Acked-by: Mel Gorman <mel@csn.ul.ie>

I dunno. Those macros are _way_ too big and heavy to be macros or
inline functions. Why aren't pmdp_splitting_flush() etc just
functions?

There is no performance advantage to inlining them - the TLB flush is
going to be expensive enough that there's no point in avoiding a
function call. And that header file really does end up being _really_
ugly.

                      Linus
