Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2HUWAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 18:00:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758594Ab2HUWAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 18:00:40 -0400
Date: Wed, 22 Aug 2012 00:00:38 +0200
From: Jan Kara <jack@suse.cz>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [MMTests] dbench4 async on ext3
Message-ID: <20120821220038.GA19171@quack.suse.cz>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
 <20120723212146.GG9222@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120723212146.GG9222@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 23-07-12 22:21:46, Mel Gorman wrote:
> Configuration:	global-dhp__io-dbench4-async-ext3
> Result: 	http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-dbench4-async-ext3
> Benchmarks:	dbench4
> 
> Summary
> =======
> 
> In general there was a massive drop in throughput after 3.0. Very broadly
> speaking it looks like the Read operation got faster but at the cost of
> a big regression in the Flush operation.
  Mel, I had a look into this and it's actually very likely only a
configuration issue. In 3.1 ext3 started to default to enabled barriers
(barrier=1 in mount options) which is a safer but slower choice. When I set
barriers explicitely, I see no performance difference for dbench4 between
3.0 and 3.1.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
