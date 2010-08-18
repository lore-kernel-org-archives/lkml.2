Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0HRV0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 17:26:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:1709 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414Ab0HRV0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 17:26:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,229,1280732400"; 
   d="scan'208";a="314212700"
Date: Thu, 19 Aug 2010 05:26:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Li Shaohua <shaohua.li@intel.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [TESTCASE] Clean pages clogging the VM
Message-ID: <20100818212613.GA7366@localhost>
References: <20100809133000.GB6981@wil.cx>
 <20100817195001.GA18817@linux.intel.com>
 <20100818141308.GD1779@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818141308.GD1779@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Mapped file pages get two rounds on the LRU list, so once the VM
> starts scanning, it has to go through all of them twice and can only
> reclaim them on the second encounter.

This can be fixed gracefully based on Rik's refault-distance patch :)
With the distance info we can safely drop the use-once mapped file pages.

Thanks,
Fengguang
