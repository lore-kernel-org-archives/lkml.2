Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681Ab1CDOqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:46:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:21282 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab1CDOqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:46:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,264,1297065600"; 
   d="scan'208";a="663871464"
Date: Fri, 4 Mar 2011 09:46:33 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [REVIEW] NVM Express driver
Message-ID: <20110304144633.GB3663@linux.intel.com>
References: <20110303204749.GY3663@linux.intel.com>
 <20110304130645.GA21454@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304130645.GA21454@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 08:06:45AM -0500, Christoph Hellwig wrote:
> What's the reason to make this a make_request based driver?  That loses
> all the intelligence that has been put into the queueing layer, like I/O
> bandwith controlling and fair scheduling.  Is it just queue_lock
> contention?  If so it would be great if you could help with testing
> Jens' stack-plug and request allocation scalability patches.

The hardware has the ability to do I/O bandwidth control and fair
scheduling (albeit on a fairly coarse granularity).  By doing it in
software, all we're doing for these devices is increasing I/O latency
and burning CPU cycles.
