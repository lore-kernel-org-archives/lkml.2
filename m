Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab0KJDzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 22:55:22 -0500
Received: from mga14.intel.com ([143.182.124.37]:19313 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab0KJDzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 22:55:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,176,1288594800"; 
   d="scan'208";a="346786840"
Date: Wed, 10 Nov 2010 11:55:16 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Hellwig <hch@lst.de>,
        Jan Engelhardt <jengelh@medozas.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] writeback: stop background/kupdate works from
 livelocking other works
Message-ID: <20101110035516.GA12710@localhost>
References: <20101110023500.404859581@intel.com>
 <20101110024223.847210776@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101110024223.847210776@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan, the below comment is also updated, please double check.

>  
>  		/*
> +		 * Background writeout and kupdate-style writeback may
> +		 * run forever. Stop them if there is other work to do
> +		 * so that e.g. sync can proceed. They'll be restarted
> +		 * after the other works are all done.
> +		 */
> +		if ((work->for_background || work->for_kupdate) &&
> +		    !list_empty(&wb->bdi->work_list))
> +			break;
> +
> +		/*
>  		 * For background writeout, stop when we are below the
>  		 * background dirty threshold
>  		 */
> 
