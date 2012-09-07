Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab2IGVzw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 17:55:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42394 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab2IGVzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 17:55:49 -0400
Message-ID: <504A6D57.1030607@kernel.dk>
Date: Fri, 07 Sep 2012 15:55:35 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH v10 4/8] block: Add bio_reset()
References: <1346970902-10931-1-git-send-email-koverstreet@google.com> <1346970902-10931-5-git-send-email-koverstreet@google.com> <50494F1A.4080207@kernel.dk> <20120907205823.GD16360@google.com>
In-Reply-To: <20120907205823.GD16360@google.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-07 14:58, Kent Overstreet wrote:
> On Thu, Sep 06, 2012 at 07:34:18PM -0600, Jens Axboe wrote:
>> On 2012-09-06 16:34, Kent Overstreet wrote:
>>> Reusing bios is something that's been highly frowned upon in the past,
>>> but driver code keeps doing it anyways. If it's going to happen anyways,
>>> we should provide a generic method.
>>>
>>> This'll help with getting rid of bi_destructor - drivers/block/pktcdvd.c
>>> was open coding it, by doing a bio_init() and resetting bi_destructor.
>>>
>>> This required reordering struct bio, but the block layer is not yet
>>> nearly fast enough for any cacheline effects to matter here.
>>
>> That's an odd and misplaced comment. Was just doing testing today at 5M
>> IOPS, and even years back we've had cache effects for O_DIRECT in higher
>> speed setups.
> 
> Ah, I wasn't aware that you were pushing that many iops through the
> block layer - most I've tested myself was around 1M. It wouldn't
> surprise me if cache effects in struct bio mattered around 5M...

5M is nothing, just did 13.5M :-)

But we can reshuffle for now. As mentioned, we're way overdue for a
decent look at cache profiling in any case.

>> That said, we haven't done cache analysis in a long time. So moving
>> members around isn't necessarily a huge deal.
> 
> Ok, good to know. I've got another patch coming later that reorders
> struct bio a bit more, for immutable bvecs (bi_sector, bi_size, bi_idx
> go into a struct bvec_iter together).

OK

>> Lastly, this isn't a great commit message for other reasons. Anyone can
>> see that it moves members around. It'd be a lot better to explain _why_
>> it is reordering the struct.
> 
> Yeah, I suppose so. Will keep that in mind for the next patch.

Thanks.

>> BTW, I looked over the rest of the patches, and it looks OK to me.
> 
> Resent them. Thanks!

Got it.

-- 
Jens Axboe

