Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0DFFDi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 01:03:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:20208 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab0DFFDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 01:03:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,370,1267430400"; 
   d="scan'208";a="786717895"
Date: Tue, 6 Apr 2010 13:03:25 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
Message-ID: <20100406050325.GA17797@localhost>
References: <20100331045348.GA3396@sli10-desk.sh.intel.com> <20100331142708.039E.A69D9226@jp.fujitsu.com> <20100331145030.03A1.A69D9226@jp.fujitsu.com> <20100402065052.GA28027@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402065052.GA28027@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua,

> +		scan = zone_nr_lru_pages(zone, sc, l);
> +		if (priority) {
> +			scan >>= priority;
> +			scan = (scan * fraction[file] / denominator[file]);

Ah, the (scan * fraction[file]) may overflow in 32bit kernel!

Thanks,
Fengguang
