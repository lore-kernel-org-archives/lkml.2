Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032072Ab2CIT7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:59:13 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42525 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030917Ab2CIT7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:59:10 -0500
Date: Fri, 9 Mar 2012 11:58:34 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Tejun Heo <tj@kernel.org>, Ying Han <yinghan@google.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3.3] memcg: free mem_cgroup by RCU to fix oops
In-Reply-To: <alpine.LSU.2.00.1203072155140.11048@eggly.anvils>
Message-ID: <alpine.LSU.2.00.1203091138260.19300@eggly.anvils>
References: <alpine.LSU.2.00.1203072155140.11048@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Hugh Dickins wrote:
> 
> I'm posting this a little prematurely to get eyes on it, since it's
> more than a two-liner, but 3.3 time is running out.  If it is what's
> needed to fix my oopses, I won't really be sure before Friday morning.
> What's running now on the machine affected is using kfree_rcu(), but I
> did hack it earlier to check that the vfree_rcu() alternative works.

Yes, please do send that patch on to Linus for 3.3.

It did not get as much as the 36 hours of testing I had hoped for, only
25 hours so far.  12 hours while I was out yesterday got wasted by a
wireless driver interrupt spewing approximately one million messages:

iwl3945 0000:08:00.0: MAC is in deep sleep!. CSR_GP_CNTRL = 0xFFFFFFFF

which I've not suffered from before, and hope not again.  Having kdb
in, I did take a look what was going on with the memcg load when it was
interrupted: it appeared to be normal, and I've no reason to suppose that
my kfree_rcu() was in any way responsible for the wireless aberration.

Thanks,
Hugh
