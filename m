Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab0KXOfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:35:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:52589 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868Ab0KXOfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:35:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,248,1288594800"; 
   d="scan'208";a="577178994"
Date: Wed, 24 Nov 2010 22:34:59 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Li, Shaohua" <shaohua.li@intel.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] writeback: bdi write bandwidth estimation
Message-ID: <20101124143459.GA14502@localhost>
References: <20101117042720.033773013@intel.com>
 <20101117042850.002299964@intel.com>
 <1290596732.2072.450.camel@laptop>
 <20101124121046.GA8333@localhost>
 <1290603047.2072.465.camel@laptop>
 <20101124131437.GE10413@localhost>
 <20101124132012.GA12117@localhost>
 <1290606129.2072.467.camel@laptop>
 <20101124134641.GA12987@localhost>
 <1290607953.2072.472.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290607953.2072.472.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btw, I noticed that the same dd is constantly running from different
CPUs.

It's multi-core CPUs on the same socket, so should not be a big
problem. I'll test NUMA setup later.

This trace is for single dd case. 

dd-2893  [005]  3535.182111: balance_dirty_pages: bdi=8:0
dd-2893  [001]  3535.230125: balance_dirty_pages: bdi=8:0
dd-2893  [005]  3535.274805: balance_dirty_pages: bdi=8:0
dd-2893  [005]  3535.289337: balance_dirty_pages: bdi=8:0
dd-2893  [005]  3535.497863: balance_dirty_pages: bdi=8:0
dd-2893  [005]  3535.585510: balance_dirty_pages: bdi=8:0
dd-2893  [005]  3535.622001: balance_dirty_pages: bdi=8:0
dd-2893  [005]  3535.645003: balance_dirty_pages: bdi=8:0
dd-2893  [001]  3535.659603: balance_dirty_pages: bdi=8:0
dd-2893  [001]  3535.669497: balance_dirty_pages: bdi=8:0
dd-2893  [001]  3535.731294: balance_dirty_pages: bdi=8:0
dd-2893  [001]  3535.785879: balance_dirty_pages: bdi=8:0
dd-2893  [001]  3535.827724: balance_dirty_pages: bdi=8:0
dd-2893  [001]  3535.853108: balance_dirty_pages: bdi=8:0
dd-2893  [001]  3535.875667: balance_dirty_pages: bdi=8:0
dd-2893  [005]  3535.895731: balance_dirty_pages: bdi=8:0
dd-2893  [005]  3535.914920: balance_dirty_pages: bdi=8:0
dd-2893  [005]  3535.925765: balance_dirty_pages: bdi=8:0
dd-2893  [005]  3535.935545: balance_dirty_pages: bdi=8:0
dd-2893  [001]  3536.015888: balance_dirty_pages: bdi=8:0
dd-2893  [001]  3536.085571: balance_dirty_pages: bdi=8:0

Here is another run (1-dd):

dd-3014  [001]  1248.388001: balance_dirty_pages: bdi=8:0 bdi_dirty=122640 avg_dirty=122643 
dd-3014  [002]  1248.465999: balance_dirty_pages: bdi=8:0 bdi_dirty=122400 avg_dirty=122625 
dd-3014  [007]  1248.531451: balance_dirty_pages: bdi=8:0 bdi_dirty=122240 avg_dirty=122600 
dd-3014  [007]  1248.599260: balance_dirty_pages: bdi=8:0 bdi_dirty=122000 avg_dirty=122561 
dd-3014  [003]  1248.667152: balance_dirty_pages: bdi=8:0 bdi_dirty=120840 avg_dirty=122447 
dd-3014  [007]  1248.734848: balance_dirty_pages: bdi=8:0 bdi_dirty=120640 avg_dirty=122328 
dd-3014  [007]  1248.798652: balance_dirty_pages: bdi=8:0 bdi_dirty=120440 avg_dirty=122210 
dd-3014  [007]  1248.862456: balance_dirty_pages: bdi=8:0 bdi_dirty=120240 avg_dirty=122087 
dd-3014  [003]  1248.926280: balance_dirty_pages: bdi=8:0 bdi_dirty=120040 avg_dirty=121960 
dd-3014  [005]  1248.986091: balance_dirty_pages: bdi=8:0 bdi_dirty=119760 avg_dirty=121832 
dd-3014  [005]  1249.045841: balance_dirty_pages: bdi=8:0 bdi_dirty=119600 avg_dirty=121702 

And this 100 dd case looks much better (however it's not always the case):

dd-2775  [007]   454.844907: balance_dirty_pages: bdi=8:0 bdi_dirty=104040 avg_dirty=409468930 
dd-2775  [007]   455.048108: balance_dirty_pages: bdi=8:0 bdi_dirty=103800 avg_dirty=409676055 
dd-2775  [007]   455.252347: balance_dirty_pages: bdi=8:0 bdi_dirty=103720 avg_dirty=409676055 
dd-2775  [007]   455.455538: balance_dirty_pages: bdi=8:0 bdi_dirty=103800 avg_dirty=409676055 
dd-2775  [007]   455.658597: balance_dirty_pages: bdi=8:0 bdi_dirty=103880 avg_dirty=409676055 
dd-2775  [007]   455.862631: balance_dirty_pages: bdi=8:0 bdi_dirty=103760 avg_dirty=410276387 
dd-2775  [007]   456.068149: balance_dirty_pages: bdi=8:0 bdi_dirty=103800 avg_dirty=410276387 
dd-2775  [007]   456.266729: balance_dirty_pages: bdi=8:0 bdi_dirty=103760 avg_dirty=410833633 
dd-2775  [007]   456.470184: balance_dirty_pages: bdi=8:0 bdi_dirty=103840 avg_dirty=410833633 
dd-2775  [007]   456.668919: balance_dirty_pages: bdi=8:0 bdi_dirty=103960 avg_dirty=410833633 
dd-2775  [007]   456.872522: balance_dirty_pages: bdi=8:0 bdi_dirty=103880 avg_dirty=411001977 
dd-2775  [007]   457.070753: balance_dirty_pages: bdi=8:0 bdi_dirty=104040 avg_dirty=411001977 
dd-2775  [007]   457.275970: balance_dirty_pages: bdi=8:0 bdi_dirty=103960 avg_dirty=411227747 
dd-2775  [007]   457.473736: balance_dirty_pages: bdi=8:0 bdi_dirty=103920 avg_dirty=411534633 
dd-2775  [007]   457.677204: balance_dirty_pages: bdi=8:0 bdi_dirty=103920 avg_dirty=412195106 
dd-2775  [007]   457.881156: balance_dirty_pages: bdi=8:0 bdi_dirty=104040 avg_dirty=412195106 
dd-2775  [007]   458.085173: balance_dirty_pages: bdi=8:0 bdi_dirty=103920 avg_dirty=412295260 
dd-2775  [007]   458.285146: balance_dirty_pages: bdi=8:0 bdi_dirty=104000 avg_dirty=412295260 
dd-2775  [007]   458.490109: balance_dirty_pages: bdi=8:0 bdi_dirty=103960 avg_dirty=412789184 
dd-2775  [007]   458.692230: balance_dirty_pages: bdi=8:0 bdi_dirty=103960 avg_dirty=412789184 

Thanks,
Fengguang
