Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1FNOwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 10:52:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab1FNOwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 10:52:37 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 3/4] Staging: zram: allow partial page operations
References: <1307712529-9757-1-git-send-email-jmarchan@redhat.com>
	<1307712529-9757-2-git-send-email-jmarchan@redhat.com>
	<1307712529-9757-3-git-send-email-jmarchan@redhat.com>
	<4DF2493F.8040507@vflare.org> <4DF5DB79.3010004@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 14 Jun 2011 10:49:26 -0400
In-Reply-To: <4DF5DB79.3010004@redhat.com> (Jerome Marchand's message of "Mon,
	13 Jun 2011 11:42:17 +0200")
Message-ID: <x49aadk31u1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jerome Marchand <jmarchan@redhat.com> writes:

> On 06/10/2011 06:41 PM, Nitin Gupta wrote:
>> On 06/10/2011 06:28 AM, Jerome Marchand wrote:
>>> Commit 7b19b8d45b216ff3186f066b31937bdbde066f08 (zram: Prevent overflow
>>> in logical block size) introduced ZRAM_LOGICAL_BLOCK_SIZE constant to
>>> prevent overflow of logical block size on 64k page kernel.
>>> However, the current implementation of zram only allow operation on block
>>> of the same size as a page. That makes theorically legit 4k requests fail
>>> on 64k page kernel.
>>>
>>> This patch makes zram allow operation on partial pages. Basically, it
>>> means we still do operations on full pages internally, but only copy the
>>> relevent segments from/to the user memory.
>>>
>> 
>> Couldn't we just change struct queue_limits.logical_block_size type to 
>> unsigned int or something so it could hold value of 64K? Then we could
>> avoid making all these changes to handle partial page requests.
>> 
>> Thanks,
>> Nitin
>
> I believe logical_block_size is meant to be small. I don't know if it is
> reasonable to set it to such a big value as 64k. I CCed Jens and Martin to
> have a more valuable opinion on the matter.

I don't think there's any reason the logical block size can't be
increased.  For zram, so long as you don't care that the minimum I/O
size is 64k on these systems (and by you, I mean the users of zram, like
file systems, or anything using the block device directly), then it's
a fine trade-off to make.

Jens, Martin, what do you guys think about bumping the size of the
queue_limits.logical_block_size?

Cheers,
Jeff
