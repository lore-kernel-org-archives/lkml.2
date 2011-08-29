Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1H2Omb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 10:42:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab1H2OmZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 10:42:25 -0400
Date: Mon, 29 Aug 2011 16:42:14 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Lin Ming <lxy@ss.pku.edu.cn>
cc: Lukas Czerner <lczerner@redhat.com>, Bart Van Assche <bvanassche@acm.org>,
        Jens Axboe <jaxboe@fusionio.com>, Mike Snitzer <snitzer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: blkdev_issue_discard() hangs forever if the underlying storage
 device is removed
In-Reply-To: <CAF1ivSY0NwdZTCQQ_BG5Vk8rnjiH=sS0V08ajxc8Gw5YBwD3qA@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1108291637470.3904@dhcp-27-109.brq.redhat.com>
References: <CAO+b5-pAY9Qn4OXKnxAHaBSrJi_6nTPOGZ+QgVg9iRdTCmequA@mail.gmail.com> <alpine.LFD.2.00.1108291342110.3904@dhcp-27-109.brq.redhat.com> <CAF1ivSY0NwdZTCQQ_BG5Vk8rnjiH=sS0V08ajxc8Gw5YBwD3qA@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Lin Ming wrote:

> On Mon, Aug 29, 2011 at 7:56 PM, Lukas Czerner <lczerner@redhat.com> wrote:
> >
> > Regarding the atomic operations I do not think that implicit memory
> > barriers are needed here as atomic_dec_and_test() implies memory
> 
> Which implicit memory barrier you are talking about?

smp_mb() at both side of the operation as documented here in
Documentation/memory-barriers.txt

[citation]
Any atomic operation that modifies some state in memory and returns
information about the state (old or new) implies an SMP-conditional
general memory barrier (smp_mb()) on each side of the actual operation
(with the exception of explicit lock operations, described later).
These include:

	xchg();
	cmpxchg();
	atomic_cmpxchg();
	atomic_inc_return();
	atomic_dec_return();
	atomic_add_return();
	atomic_sub_return();
	atomic_inc_and_test();
	atomic_dec_and_test();
	atomic_sub_and_test();
	atomic_add_negative();
	atomic_add_unless();
	test_and_set_bit();
	test_and_clear_bit();
	test_and_change_bit();

[/citation]

-Lukas

> 
> > barrier, atomic_set() is out of the scope of our interest (and it would
> > not cause the problem like that anyway) and reordering atomic_inc()
> > would not cause problem like this as well.
> 
