Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab1ASUdJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:33:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab1ASUdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:33:07 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [patch] fs: aio fix rcu lookup
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	<x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
	<AANLkTimuCgn4aHzUJRmQfsXjG_UF-3W8fAWb0Y-sSPsM@mail.gmail.com>
	<x49tyh7mjr6.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikgsGHJ+q6=We_zPAivyABq+z2f6Atv6ZScLYOU@mail.gmail.com>
	<20110118190114.GA5070@quack.suse.cz>
	<AANLkTin1+B_1CV-weALdS8EYJO60BJd0b7AGWzc0wrWr@mail.gmail.com>
	<20110118235236.GA14087@quack.suse.cz>
	<AANLkTikvCkMDM9+i=44eEkX094=ZHpnQaN+541pm1icK@mail.gmail.com>
	<20110119132123.GC4246@quack.suse.cz>
	<x49ei88d7vl.fsf@segfault.boston.devel.redhat.com>
	<x49aaiwd6cs.fsf@segfault.boston.devel.redhat.com>
	<AANLkTiniSG3tfXx1iUtzf53sSsr=R6pmvmWrSV8FiYE9@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 19 Jan 2011 15:32:54 -0500
In-Reply-To: <AANLkTiniSG3tfXx1iUtzf53sSsr=R6pmvmWrSV8FiYE9@mail.gmail.com>
	(Nick Piggin's message of "Thu, 20 Jan 2011 07:18:53 +1100")
Message-ID: <x491v48d47d.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@gmail.com> writes:

> On Thu, Jan 20, 2011 at 6:46 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Jeff Moyer <jmoyer@redhat.com> writes:
>>
>>> Jan Kara <jack@suse.cz> writes:
>>>
>>>>  But there's the second race I describe making it possible
>>>> for new IO to be created after io_destroy() has waited for all IO to
>>>> finish...
>>>
>>> Can't that be solved by introducing memory barriers around the accesses
>>> to ->dead?
>>
>> Upon further consideration, I don't think so.
>>
>> Given the options, I think adding the synchronize rcu to the io_destroy
>> path is the best way forward.  You're already waiting for a bunch of
>> queued I/O to finish, so there is no guarantee that you're going to
>> finish that call quickly.
>
> I think synchronize_rcu() is not something to sprinkle around outside
> very slow paths. It can be done without synchronize_rcu.

I'm not sure I understand what you're saying.  Do you mean to imply that
io_destroy is not a very slow path?  Because it is.  I prefer a solution
that doesn't re-architecht things in order to solve a theoretical issue
that's never been observed.

Cheers,
Jeff
