Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab0IBP1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab0IBP1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:27:45 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Doug Neal <dneallkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: I/O scheduler deadlocks on Xen virtual block devices
References: <AANLkTi=O6Tpiz8TRFFknEpW7MMTGBAtqCpr7zH3abO67@mail.gmail.com>
	<x49fwxtqsh8.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikGYEuCE2-TaKwANwoCFEjVNL4KZa1AhJ2woGud@mail.gmail.com>
	<x49bp8gfeax.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimjuyHMkVPrjpPAe2sMwCAVnQjDigQkHmV4ZhAc@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 02 Sep 2010 11:25:18 -0400
In-Reply-To: <AANLkTimjuyHMkVPrjpPAe2sMwCAVnQjDigQkHmV4ZhAc@mail.gmail.com>
	(Doug Neal's message of "Thu, 2 Sep 2010 15:06:48 +0100")
Message-ID: <x49iq2odv6p.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Neal <dneallkml@gmail.com> writes:

>>>>
>>>> Did you try these different I/O schedulers in the domU or on the dom0?
>>>> Does switching I/O schedulers in either place make the problem go away
>>>> when it happens?
>>>>
>>>
>>> In the domU, and the bug was present in all cases. The dom0 was using
>>> cfq. I'll run the tests again using each scheduler in the dom0 with
>>> domU set to noop and report back.
>>
>> While I think this is an interesting test, you need only test one I/O
>> scheduler in the dom0.  Also, I think you misunderstood the second
>> question.  I'd like to know if switching I/O schedulers while the system
>> is in this bad state helps get I/O going again.
>>
> Jeff,
>
> Issue confirmed in the following cases:
>
> dom0:domU
> noop:noop
> noop:deadline
> noop:anticipatory
> cfq:noop
> cfq:deadline
> cfq:anticipatory
> cfq:cfq
>
> I try switching schedulers in the domU during the lockup, the echo x >
> /sys/block/xvda/queue/scheduler command also hangs. In the dom0, no
> effect.

OK.  So, this means that the I/O is not hung up in the I/O scheduler.  I
don't have a whole lot of experience with the Xen I/O stack, but I think
that's where I'd start digging (especially if there's nothing in the
logs about command timed out).

I hope this was a somewhat helpful exercise.  Sorry I can't be of more
help.

Cheers!
Jeff
