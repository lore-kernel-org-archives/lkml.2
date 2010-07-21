Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0GUUyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:54:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab0GUUyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:54:17 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, czoccolo@gmail.com
Subject: Re: [PATCH 2/3] cfq-iosched: Implement a tunable group_idle
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
	<1279739181-24482-3-git-send-email-vgoyal@redhat.com>
	<x49bpa0d3nn.fsf@segfault.boston.devel.redhat.com>
	<20100721201318.GH20458@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 21 Jul 2010 16:54:03 -0400
In-Reply-To: <20100721201318.GH20458@redhat.com> (Vivek Goyal's message of
	"Wed, 21 Jul 2010 16:13:18 -0400")
Message-ID: <x49r5iwblp0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Jul 21, 2010 at 03:40:44PM -0400, Jeff Moyer wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > o Implement a new tunable group_idle, which allows idling on the group
>> >   instead of a cfq queue. Hence one can set slice_idle = 0 and not idle
>> >   on the individual queues but idle on the group. This way on fast storage
>> >   we can get fairness between groups at the same time overall throughput
>> >   improves.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>> > ---
>> [snip]
>> > @@ -1929,13 +1941,21 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
>> >  		return;
>> >  	}
>> >  
>> > +	/* There are other queues in the group, don't do group idle */
>> > +	if (group_idle && cfqq->cfqg->nr_cfqq > 1)
>> > +		return;
>> > +
>> >  	cfq_mark_cfqq_wait_request(cfqq);
>> >  
>> > -	sl = cfqd->cfq_slice_idle;
>> > +	if (group_idle)
>> > +		sl = cfqd->cfq_group_idle;
>> > +	else
>> > +		sl = cfqd->cfq_slice_idle;
>> 
>> What happens when both group_idle and slice_idle are set?
>
> slice_idle prevails. Notice that "group_idle" is a local variable which
> is set to 1 only if we decide not to idle on the cfq queue.

Ah, silly me.

Cheers,
Jeff
