Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309Ab0DFFhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:37:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:59428 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab0DFFg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:36:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,370,1267430400"; 
   d="scan'208";a="506630874"
Date: Tue, 6 Apr 2010 13:36:44 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Message-ID: <20100406053644.GA14183@sli10-desk.sh.intel.com>
References: <20100331045348.GA3396@sli10-desk.sh.intel.com>
 <20100331142708.039E.A69D9226@jp.fujitsu.com>
 <20100331145030.03A1.A69D9226@jp.fujitsu.com>
 <20100402065052.GA28027@sli10-desk.sh.intel.com>
 <20100406050325.GA17797@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100406050325.GA17797@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 01:03:25PM +0800, Wu, Fengguang wrote:
> Shaohua,
> 
> > +		scan = zone_nr_lru_pages(zone, sc, l);
> > +		if (priority) {
> > +			scan >>= priority;
> > +			scan = (scan * fraction[file] / denominator[file]);
> 
> Ah, the (scan * fraction[file]) may overflow in 32bit kernel!
good catch. will change it to u64.
