Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2FZU45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:56:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57493 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2FZU44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:56:56 -0400
Date: Tue, 26 Jun 2012 13:56:51 -0700
From: Tejun Heo <tj@kernel.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120626205651.GW3869@google.com>
References: <CAKA=qzYea71A5VQOQgrqzaZtVFadjhcghgH+Z9n4ivS7vUgW0g@mail.gmail.com>
 <20120625133047.GA9394@redhat.com>
 <CAKA=qzbXm7LaDziH=cms1W5X+cwNNRkG0LNFfWKEppr2oht6_w@mail.gmail.com>
 <20120625211850.GC10916@redhat.com>
 <CAKA=qzaU=wKLrprgJ4z32tqqyO6W0+SBcaV=ArWAdKh_9c=Zew@mail.gmail.com>
 <CAKA=qzY+J-Ab8NC-+r1Dw_-giVzC=z8SnxJhSWHF-ud8j3yg6A@mail.gmail.com>
 <20120626125953.GA22557@redhat.com>
 <CAKA=qzZ_KhRbH6F4-TWvSAWiJyDsDrz4oUO5WppoMgWNEhyZmg@mail.gmail.com>
 <20120626155332.GJ22557@redhat.com>
 <CAKA=qzYoX-1nTZ6QfdD7RhWf=KU7J6tWOJXgt-F+Kz2c3Xn0TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKA=qzYoX-1nTZ6QfdD7RhWf=KU7J6tWOJXgt-F+Kz2c3Xn0TQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Jun 26, 2012 at 03:37:31PM -0500, Josh Hunt wrote:
> The print "cfq schedule dispatch: busy_queues:1 rq_queued:1
> rq_in_driver:0 rq_in_flight[0]:0 [1]:0" is inside the if to call
> kblockd_schedule_work() so it is getting called, but you can see that
> we never see the workqueue_queue_work tracepoint being hit.

Hmm... looks like the work item is already queued.  Can you please
move the "schedule dispatch" message after kblockd_schedule_work() and
print its return value too?

> Tejun - if you could let me know what other data I should be looking
> for/need to enable in the traces I would appreciate it.

The trace seems truncated and doesn't contain 9527.XXXX traces.  Can
you please resend?

Thanks.

-- 
tejun
