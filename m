Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2IRS7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:59:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752578Ab2IRS7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:59:07 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: Re: [PATCH 0/4] Fix a crash when block device is read and block size is changed at the same time
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
	<x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com>
	<x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com>
	<Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com>
	<1343508252.2626.13184.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com>
	<1343556630.2626.13257.camel@edumazet-glaptop>
	<1343586962.2626.13266.camel@edumazet-glaptop>
	<Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
	<Pine.LNX.4.64.1208311518340.16960@file.rdu.redhat.com>
	<x49liguyg6r.fsf@segfault.boston.devel.redhat.com>
	<x49wqzswdn3.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1209181257410.11735@file.rdu.redhat.com>
	<x49obl3s0tb.fsf@segfault.boston.devel.redhat.com>
	<Pine.LNX.4.64.1209181453060.32195@file.rdu.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 18 Sep 2012 14:58:54 -0400
In-Reply-To: <Pine.LNX.4.64.1209181453060.32195@file.rdu.redhat.com> (Mikulas
	Patocka's message of "Tue, 18 Sep 2012 14:55:29 -0400 (EDT)")
Message-ID: <x49ipbbrwcx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka <mpatocka@redhat.com> writes:

> On Tue, 18 Sep 2012, Jeff Moyer wrote:
>
>> Mikulas Patocka <mpatocka@redhat.com> writes:
>> 
>> > Hi Jeff
>> >
>> > Thanks for testing.
>> >
>> > It would be interesting ... what happens if you take the patch 3, leave 
>> > "struct percpu_rw_semaphore bd_block_size_semaphore" in "struct 
>> > block_device", but remove any use of the semaphore from fs/block_dev.c? - 
>> > will the performance be like unpatched kernel or like patch 3? It could be 
>> > that the change in the alignment affects performance on your CPU too, just 
>> > differently than on my CPU.
>> 
>> I'll give it a try and report back.
>> 
>> > What is the CPU model that you used for testing?
>> 
>> http://ark.intel.com/products/53570/Intel-Xeon-Processor-E7-2860-%2824M-Cache-2_26-GHz-6_40-GTs-Intel-QPI%29
>> 
> BTW. why did you use just 4 processes? - the processor has 10 cores and 20 
> threads (so theoretically, you could run 20 processes bound on a single 
> numa node). Were the results not stable with more than 4 processes?

There is no good reason for it.  Since I was able to show some
differences in performance, I didn't see the need to scale beyond 4.  I
can certainly bump the count up if/when that becomes interesting.

Cheers,
Jeff
