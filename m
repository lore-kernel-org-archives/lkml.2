Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab2JQOYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 10:24:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:43305 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab2JQOYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 10:24:53 -0400
Message-ID: <507EBF6C.90506@kernel.dk>
Date: Wed, 17 Oct 2012 16:23:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Ben Hutchings <ben@decadent.org.uk>, Sasha Levin <levinsasha928@gmail.com>,
        Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: blk: NULL ptr deref in blk_dequeue_request()
References: <505E2108.2060108@gmail.com>  <CA+1xoqc1Bc1rPgH+9Xs9-BV7qp3N7mDpNLj1mPwZHdF=H4mHTg@mail.gmail.com>  <20121008172207.GB14767@quack.suse.cz>  <alpine.LNX.2.00.1210082340501.19980@pobox.suse.cz>  <507424F7.60801@gmail.com> <50742600.10606@gmail.com>  <1349884374.6336.67.camel@deadeye.wl.decadent.org.uk>  <CA+1xoqcGN1xYP5-N17eZQ=F_JTG-8gr43DAxREa-Wf+n8=P7Og@mail.gmail.com> <1350437371.26833.71.camel@deadeye.wl.decadent.org.uk> <alpine.LNX.2.00.1210171610220.17129@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1210171610220.17129@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-17 16:11, Jiri Kosina wrote:
> On Wed, 17 Oct 2012, Ben Hutchings wrote:
> 
>>>> 1. redo_fd_request() races with tear-down of the disks, but because
>>>> set_next_request() checks disk->queue before doing anything this was
>>>> usually harmless.  Now that do_floppy_init() doesn't clear disk->queue,
>>>> the race condition is much easier to hit.  This may fix that problem in
>>>> do_floppy_init(), though there appear to be worse bugs in tear-down
>>>> order in floppy_module_exit():
>> [...]
>>>> 2. I made a big mistake in using the existing GENHD_FL_UP flag, as it is
>>>> cleared by del_gendisk().  Incremental patch below, but it should be
>>>> squashed into the previous patch if that branch is still rebase-able.
>> [...]
>>> I'm now seeing these instead:
>> [...]
>>
>> Sorry, I'm not going to spend more time in the quagmire of the floppy
>> driver.  Whoever has this commit in their tree, please revert or drop it
>> as appropriate.
> 
> As far as I can tell, Jens has pulled it from me, but it hasn't made it 
> into Linus' tree as of today.
> 
> I will do it in my tree and send a new pull request to Jens.

I did not add the patch from Ben, as it was reported as not working. My
driver pull is late this time due to travel, but it'll go out start of
next week. So if you have pending floppy updates that are tested at that
time, then please do send them my way.

-- 
Jens Axboe

