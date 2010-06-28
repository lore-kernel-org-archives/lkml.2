Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab0F1Mlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:41:32 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43339 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab0F1Mla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:41:30 -0400
Message-ID: <4C28987A.7000701@kernel.dk>
Date: Mon, 28 Jun 2010 14:41:30 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com,
       James.Bottomley@suse.de, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com, akpm@linux-foundation.org
Subject: Re: [PATCH 2/2] block: defer the use of inline biovecs for discard
  requests
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-2-git-send-email-snitzer@redhat.com> <4C2896C6.9030607@kernel.dk> <20100628123742.GB19497@redhat.com>
In-Reply-To: <20100628123742.GB19497@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-28 14:37, Mike Snitzer wrote:
> On Mon, Jun 28 2010 at  8:34am -0400,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 2010-06-26 21:56, Mike Snitzer wrote:
>>> Don't alloc discard bio with a biovec in blkdev_issue_discard.  Doing so
>>> means bio_has_data() will not be true until the SCSI layer adds the
>>> payload to the discard request via blk_add_request_payload.
>>
>> Sorry, this looks horrible.
> 
> Your judgment isn't giving me much to work with... not sure where I go
> with "horrible".

The horrible part is working around that issue by fiddling with the
assignment of the internal vec. THAT looks like a horrible solution
to that problem.

How about just adding a check to bio_has_data() for non-zero
bio->bi_vcnt?

-- 
Jens Axboe

