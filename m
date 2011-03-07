Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab1CGTuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 14:50:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab1CGTui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 14:50:38 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@gmail.com>,
        Jan Beulich <JBeulich@novell.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH v2.6.38-rc5 2/2] block: blk-flush shouldn't call directly into q->request_fn() __blk_run_queue()
References: <20110217111511.GQ19830@htj.dyndns.org>
	<20110217111619.GR19830@htj.dyndns.org>
	<AANLkTi=rPKN25yZTziv1dz=Ke0db8ZOwUgKFNzWn9+x7@mail.gmail.com>
	<20110218094903.GF21209@htj.dyndns.org> <4D6E4A46.1040709@kernel.dk>
	<20110304182507.GY20499@htj.dyndns.org>
	<x49r5aisp23.fsf@segfault.boston.devel.redhat.com>
	<4D7533B1.3070308@kernel.dk>
	<x49mxl6sot4.fsf@segfault.boston.devel.redhat.com>
	<4D7534D6.7020000@kernel.dk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 07 Mar 2011 14:50:28 -0500
In-Reply-To: <4D7534D6.7020000@kernel.dk> (Jens Axboe's message of "Mon, 07
	Mar 2011 20:41:10 +0100")
Message-ID: <x49ipvusoaj.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 2011-03-07 20:39, Jeff Moyer wrote:
>>>> I think the real issue may just be that the ide driver is blocking in
>>>> its request function.  What have I missed?
>>>
>>> So the only case where the request_fn is called and you cannot block, is
>>> if you call it from your completion function. Any other invocation
>>> should be from process context. As long as you remember to drop the
>>> queue lock and re-enable interrupts, it should work. It's not great
>>> style and I would not recommend it for a performance environment, but it
>>> should work.
>> 
>> So are you agreeing with me or disagreeing?  ;-)  It sounds to me like
>> you're saying that the ide driver should be able to cope with being
>> called from softirq context.
>
> I'm just stating how it should work :-)
>
> But yes, it sounds like IDE is violating this rule and that's why it was
> broken. Even with that, having explicit control of the queue running
> does make sense.

Well, I wonder if it makes sense *in this case*.  With all of the work
going into optimizing the flushing, is deferring work to kblockd really
the best idea?  Tejun, do you know if it has any measurable impact?

Cheers,
Jeff
