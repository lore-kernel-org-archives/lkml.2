Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab0DBJYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 05:24:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:60527 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755478Ab0DBJYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 05:24:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,352,1267430400"; 
   d="scan'208";a="505799271"
Date: Fri, 2 Apr 2010 17:24:41 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "Wu, Fengguang" <fengguang.wu@intel.com>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Message-ID: <20100402092441.GA21100@sli10-desk.sh.intel.com>
References: <20100331145030.03A1.A69D9226@jp.fujitsu.com>
 <20100402065052.GA28027@sli10-desk.sh.intel.com>
 <20100402181307.6470.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402181307.6470.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 05:14:38PM +0800, KOSAKI Motohiro wrote:
> > > > This patch makes a lot of sense than previous. however I think <1% anon ratio
> > > > shouldn't happen anyway because file lru doesn't have reclaimable pages.
> > > > <1% seems no good reclaim rate.
> > > 
> > > Oops, the above mention is wrong. sorry. only 1 page is still too big.
> > > because under streaming io workload, the number of scanning anon pages should
> > > be zero. this is very strong requirement. if not, backup operation will makes
> > > a lot of swapping out.
> > Sounds there is no big impact for the workload which you mentioned with the patch.
> > please see below descriptions.
> > I updated the description of the patch as fengguang suggested.
> 
> Umm.. sorry, no.
> 
> "one fix but introduce another one bug" is not good deal. instead, 
> I'll revert the guilty commit at first as akpm mentioned.
Even we revert the commit, the patch still has its benefit, as it increases
calculation precision, right?

Thanks,
Shaohua
