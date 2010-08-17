Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab0HQN77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:59:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:47754 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291Ab0HQN76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:59:58 -0400
Message-ID: <4C6A9515.5060805@kernel.org>
Date: Tue, 17 Aug 2010 15:56:37 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        Neil Brown <neilb@suse.de>
Subject: Re: [PATCH block#for-2.6.36-post] block: fix incorrect bio/request
 flag conversion in md
References: <4C694965.6040805@kernel.org> <20100817135638.GA5382@lst.de>
In-Reply-To: <20100817135638.GA5382@lst.de>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 17 Aug 2010 13:59:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/17/2010 03:56 PM, Christoph Hellwig wrote:
> On Mon, Aug 16, 2010 at 04:21:25PM +0200, Tejun Heo wrote:
>> Commit 74450be1 (block: unify flags for struct bio and struct request)
>> incorrectly converted @do_sync in md raid1 and raid10 make_requst()
>> functions.
>>
>> @do_sync is now supposed to carry the actual flag bit and directly
>> OR'd into bio->bi_rw but is still a bool and thus carries either 0 or
>> 1 instead of the actual flag bit.  This makes REQ_SYNC ignored on
>> writes and flips the direction of READ_SYNCs to WRITEs.
>>
>> Fix it by making @do_sync unsigned integers.
> 
> Yeah, you're the fourth person coming up with this independently.  Now
> all we need is to get one of the patches actually into Linus tree.

Ah, that's good to know.  It's not in mainline yet, so I guess we
should just wait for Jens to come back.

Thanks.

-- 
tejun
