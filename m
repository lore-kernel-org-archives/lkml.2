Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105Ab0KSBUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 20:20:22 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47855 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0KSBUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 20:20:21 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 19 Nov 2010 10:14:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 38 of 66] memcontrol: try charging huge pages from stock
Message-Id: <20101119101427.45d78929.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <9d26d3daf23632b20a7b.1288798093@v2.random>
References: <patchbomb.1288798055@v2.random>
	<9d26d3daf23632b20a7b.1288798093@v2.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Nov 2010 16:28:13 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> From: Johannes Weiner <hannes@cmpxchg.org>
> 
> The stock unit is just bytes, there is no reason to only take normal
> pages from it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>

nonsense. The stock size is CHARGE_SIZE=32*PAGE_SIZE at maximum.
When we make this to be larger than HUGEPAGE size, 2M per cpu at least.
This means memcg's resource "usage" accounting will have 128MB inaccuracy.

Nack.

Thanks,
-Kame

