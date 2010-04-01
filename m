Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab0DALOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 07:14:06 -0400
Received: from bld-mail19.adl2.internode.on.net ([150.101.137.104]:43769 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755165Ab0DALOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 07:14:01 -0400
Date: Thu, 1 Apr 2010 22:13:57 +1100
From: Dave Chinner <david@fromorbit.com>
To: Denys Fedorysychenko <nuclearcat@nuclearcat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
Message-ID: <20100401111357.GA6601@dastard>
References: <201003311907.31342.nuclearcat@nuclearcat.com>
 <20100331221254.GI7671@dastard>
 <201004011342.42467.nuclearcat@nuclearcat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004011342.42467.nuclearcat@nuclearcat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 01:42:42PM +0300, Denys Fedorysychenko wrote:
> Thats correct, it is quite busy cache server.
> 
> Well, if i stop squid(cache) sync will finish enough fast.
> If i don't - it took more than hour. Actually i left that PC after 1 hour, and 
> it didn't finish yet. I don't think it is normal.
> Probably sync taking new data and trying to flush it too, and till he finish 
> that, more data comes. 
> Actually all what i need - to sync config directory. I cannot use fsync, 
> because it is multiple files opened before by other processes, and sync is 
> doing trick like this. I got dead process, and only fast way to recover system 
> - kill the cache process, so I/O pumping will stop for a while, and sync() 
> will have chance to finish.
> Sure there is way just to "remount" config partition to ro, but i guess just 
> sync must flush only current buffer cache pages.
> 
> I will do more tests now and will give exact numbers, how much time it needs 
> with running squid and if i kill it shortly after running sync.

Ok. What would be interesting is regular output from /proc/meminfo
to see how the dirty memory is changing over the time the sync is
running....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
