Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870Ab0DAUPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:15:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316Ab0DAUPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:15:10 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Denys Fedorysychenko <nuclearcat@nuclearcat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: endless sync on bdi_sched_wait()? 2.6.33.1
References: <201003311907.31342.nuclearcat@nuclearcat.com>
	<20100331221254.GI7671@dastard>
	<201004011342.42467.nuclearcat@nuclearcat.com>
	<20100401111357.GA6601@dastard>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 01 Apr 2010 16:14:54 -0400
In-Reply-To: <20100401111357.GA6601@dastard> (Dave Chinner's message of "Thu,
	1 Apr 2010 22:13:57 +1100")
Message-ID: <x49634b9bgh.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Thu, Apr 01, 2010 at 01:42:42PM +0300, Denys Fedorysychenko wrote:
>> Thats correct, it is quite busy cache server.
>> 
>> Well, if i stop squid(cache) sync will finish enough fast.
>> If i don't - it took more than hour. Actually i left that PC after 1 hour, and 
>> it didn't finish yet. I don't think it is normal.
>> Probably sync taking new data and trying to flush it too, and till he finish 
>> that, more data comes. 
>> Actually all what i need - to sync config directory. I cannot use fsync, 
>> because it is multiple files opened before by other processes, and sync is 
>> doing trick like this. I got dead process, and only fast way to recover system 
>> - kill the cache process, so I/O pumping will stop for a while, and sync() 
>> will have chance to finish.
>> Sure there is way just to "remount" config partition to ro, but i guess just 
>> sync must flush only current buffer cache pages.
>> 
>> I will do more tests now and will give exact numbers, how much time it needs 
>> with running squid and if i kill it shortly after running sync.
>
> Ok. What would be interesting is regular output from /proc/meminfo
> to see how the dirty memory is changing over the time the sync is
> running....

This sounds familiar:

http://lkml.org/lkml/2010/2/12/41

Cheers,
Jeff
