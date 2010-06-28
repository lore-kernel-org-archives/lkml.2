Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab0F1HDQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 03:03:16 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49591 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab0F1HDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 03:03:14 -0400
Message-ID: <4C284931.2000908@fusionio.com>
Date: Mon, 28 Jun 2010 09:03:13 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Brian Bloniarz <bmb@athenacr.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [GIT PULL] block/io bits for 2.6.35-rc
References: <4C10EC2A.8060002@fusionio.com> <AANLkTimus1Ajk-6HyDtZBmsYwQjkAf3zW-dvxNJlSlGw@mail.gmail.com> <4C1111ED.6020008@fusionio.com> <4C111685.8010400@athenacr.com> <4C27DA4A.3040708@teksavvy.com>
In-Reply-To: <4C27DA4A.3040708@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-28 01:10, Mark Lord wrote:
> On 10/06/10 12:44 PM, Brian Bloniarz wrote:
>> On 06/10/2010 12:25 PM, Jens Axboe wrote:
>>> On 2010-06-10 17:55, Linus Torvalds wrote:
>>>> On Thu, Jun 10, 2010 at 6:44 AM, Jens Axboe<jaxboe@fusionio.com>  wrote:
>>>>>
>>>>> - A set of patches fixing the WB_SYNC_NONE writeback from Christoph. So
>>>>>   we should finally have both functional and working WB_SYNC_NONE from
>>>>>   umount context.
>>>>
>>>> I _really_ think this is too late, considering how broken it has been.
>>>> We already reverted the WB_SYNC_NONE things exactly because it didn't
>>>> work, didn't we? I'm going to be off-line in two days, and this part
>>>> of the pull request really makes me nervous, if only simply because of
>>>> the history of it all (ie it's always been broken, why shouldn't it be
>>>> broken now?).
>>>>
>>>> IOW, that's a lot of scary changes, that have historically not been
>>>> safe or sufficiently tested, and have caused problems for various
>>>> filesystems. Convince me why they should suddenly be ok to merge?
>>>
>>> I agree, it's late and it makes me nervous too. I had them cook for
>>> a day, didn't see any problems. And Christoph would not send it in
>>> unless it passes at least xfs qa, which is what found the problems
>>> last time (the ones we reverted).
>>>
>>> It's fixing a regression where umount takes a LONG time if you have
>>> a lot of dirty inodes, since it basically degenerates to a data
>>> integrity writeback instead of a simple WB_SYNC_NONE. If it wasn't
>>> fixing a nasty regression (the distros are all wanting a real fix
>>> for this, it's a user problem), I would not be submitting this code
>>> at this point in time.
>>>
>>
>> Reinforcing that last point: from what I could figure out, Fedora 13
>> is shipping the buggy WB_SYNC_NONE patch currently. Ubuntu 10.04 is
>> shipping an in-kernel workaround that has serious performance
>> drawbacks.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=15906 has links to the
>> downstream bugs.
> ..
> 
> Jens, this bug has been biting my servers badly here for the past
> few months -- umount after a backup (from ext4 to ext4) takes 3-4 minutes
> instead of the expected 3-4 seconds.
> 
> Is there a patch file for this against 2.6.34 that I (and others) could use?

It's the patch series from Christoph in my for-linus branch, I intend
to push it upstream when Linus is back and taking patches.

-- 
Jens Axboe

