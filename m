Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab2HVKyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:54:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756897Ab2HVKyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:54:01 -0400
Date: Wed, 22 Aug 2012 11:48:06 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [MMTests] dbench4 async on ext3
Message-ID: <20120822104806.GD15058@suse.de>
References: <20120620113252.GE4011@suse.de>
 <20120629111932.GA14154@suse.de>
 <20120723212146.GG9222@suse.de>
 <20120821220038.GA19171@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120821220038.GA19171@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 12:00:38AM +0200, Jan Kara wrote:
> On Mon 23-07-12 22:21:46, Mel Gorman wrote:
> > Configuration:	global-dhp__io-dbench4-async-ext3
> > Result: 	http://www.csn.ul.ie/~mel/postings/mmtests-20120424/global-dhp__io-dbench4-async-ext3
> > Benchmarks:	dbench4
> > 
> > Summary
> > =======
> > 
> > In general there was a massive drop in throughput after 3.0. Very broadly
> > speaking it looks like the Read operation got faster but at the cost of
> > a big regression in the Flush operation.
>
>   Mel, I had a look into this and it's actually very likely only a
> configuration issue. In 3.1 ext3 started to default to enabled barriers
> (barrier=1 in mount options) which is a safer but slower choice. When I set
> barriers explicitely, I see no performance difference for dbench4 between
> 3.0 and 3.1.
> 

I've confirmed that disabling barriers fixed it, for one test machine and
one test at least. I'll reschedule the tests to run with barriers disabled
at some point in the future. Thanks for tracking it down, I was at least
two weeks away before I got the chance to even look.

-- 
Mel Gorman
SUSE Labs
