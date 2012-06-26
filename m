Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2FZUn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:43:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33012 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2FZUn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:43:26 -0400
Date: Tue, 26 Jun 2012 13:43:22 -0700
From: Tejun Heo <tj@kernel.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: multi-second application stall in open()
Message-ID: <20120626204322.GV3869@google.com>
References: <CAKA=qzbycm0cjLyiuKaKkD8sxDm5DvX9WVqSxN2QVT2WZOzU0Q@mail.gmail.com>
 <CAKA=qza_s6zr+wZzfFTVPSzgPQAov=K63jf-SJOTDcrnDELY5w@mail.gmail.com>
 <CAKA=qzYea71A5VQOQgrqzaZtVFadjhcghgH+Z9n4ivS7vUgW0g@mail.gmail.com>
 <20120625133047.GA9394@redhat.com>
 <CAKA=qzbXm7LaDziH=cms1W5X+cwNNRkG0LNFfWKEppr2oht6_w@mail.gmail.com>
 <20120625211850.GC10916@redhat.com>
 <CAKA=qzaU=wKLrprgJ4z32tqqyO6W0+SBcaV=ArWAdKh_9c=Zew@mail.gmail.com>
 <CAKA=qzY+J-Ab8NC-+r1Dw_-giVzC=z8SnxJhSWHF-ud8j3yg6A@mail.gmail.com>
 <20120626125953.GA22557@redhat.com>
 <CAKA=qzZ_KhRbH6F4-TWvSAWiJyDsDrz4oUO5WppoMgWNEhyZmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzZ_KhRbH6F4-TWvSAWiJyDsDrz4oUO5WppoMgWNEhyZmg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 26, 2012 at 10:18:04AM -0500, Josh Hunt wrote:
> Do you have any suggestions on how to debug this?
> 
> I did "perf record -a -e workqueue:*" and grabbed some tracepoint
> data, but it's hard to correlate when these events are occurring in
> the blktrace logs. Will keep investigating.

Yeah, as Vivek said, it would be better to get both traces through
perf instead of using blktrace.  queue_work and execute_start TPs
print out the function pointer.  Only printing out entries which match
the unplug_work would reduce a lot of noise - you can grep
cfq_kick_queue's address from /proc/kallsyms and set up
/sys/kernel/debug/tracing/events/workqueue/EVENT/filter - "echo
function==0xFUNCADDR > /sys/kernel/debug.../filter".  Not sure how to
do that with perf tho.

Ooh, you posted another message.  Will continue there.

Thanks.

-- 
tejun
