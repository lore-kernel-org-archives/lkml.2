Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759579Ab0FJQo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 12:44:56 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:8828 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759278Ab0FJQoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 12:44:55 -0400
Message-ID: <4C111685.8010400@athenacr.com>
Date: Thu, 10 Jun 2010 12:44:53 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
References: <4C10EC2A.8060002@fusionio.com> <AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com> <4C1111ED.6020008@fusionio.com>
In-Reply-To: <4C1111ED.6020008@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2010 12:25 PM, Jens Axboe wrote:
> On 2010-06-10 17:55, Linus Torvalds wrote:
>> On Thu, Jun 10, 2010 at 6:44 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>>>
>>> - A set of patches fixing the WB_SYNC_NONE writeback from Christoph. So
>>>  we should finally have both functional and working WB_SYNC_NONE from
>>>  umount context.
>>
>> I _really_ think this is too late, considering how broken it has been.
>> We already reverted the WB_SYNC_NONE things exactly because it didn't
>> work, didn't we? I'm going to be off-line in two days, and this part
>> of the pull request really makes me nervous, if only simply because of
>> the history of it all (ie it's always been broken, why shouldn't it be
>> broken now?).
>>
>> IOW, that's a lot of scary changes, that have historically not been
>> safe or sufficiently tested, and have caused problems for various
>> filesystems. Convince me why they should suddenly be ok to merge?
> 
> I agree, it's late and it makes me nervous too. I had them cook for
> a day, didn't see any problems. And Christoph would not send it in
> unless it passes at least xfs qa, which is what found the problems
> last time (the ones we reverted).
> 
> It's fixing a regression where umount takes a LONG time if you have
> a lot of dirty inodes, since it basically degenerates to a data
> integrity writeback instead of a simple WB_SYNC_NONE. If it wasn't
> fixing a nasty regression (the distros are all wanting a real fix
> for this, it's a user problem), I would not be submitting this code
> at this point in time.
> 

Reinforcing that last point: from what I could figure out, Fedora 13
is shipping the buggy WB_SYNC_NONE patch currently. Ubuntu 10.04 is
shipping an in-kernel workaround that has serious performance
drawbacks.

https://bugzilla.kernel.org/show_bug.cgi?id=15906 has links to the
downstream bugs.
