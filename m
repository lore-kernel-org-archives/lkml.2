Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762956Ab2KBOT7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:19:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab2KBOT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:19:57 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [patch 01/10] scsi: make __scsi_alloc_queue numa-aware
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
	<1351628084-29358-4-git-send-email-jmoyer@redhat.com>
	<5093AF19.5040707@acm.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 02 Nov 2012 10:19:52 -0400
In-Reply-To: <5093AF19.5040707@acm.org> (Bart Van Assche's message of "Fri, 02
	Nov 2012 12:31:37 +0100")
Message-ID: <x49txt8xf1z.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> writes:

> On 10/30/12 21:14, Jeff Moyer wrote:
>> Pass the numa node id set in the Scsi_Host on to blk_init_queue_node
>> in order to keep all allocations local to the numa node the device is
>> closest to.
>>
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>> ---
>>   drivers/scsi/scsi_lib.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index da36a3a..8662a09 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1664,7 +1664,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
>>   	struct request_queue *q;
>>   	struct device *dev = shost->dma_dev;
>>
>> -	q = blk_init_queue(request_fn, NULL);
>> +	q = blk_init_queue_node(request_fn, NULL, shost->numa_node);
>>   	if (!q)
>>   		return NULL;
>
> Hello Jeff,
>
> I haven't seen the patch that introduces numa_node in struct Scsi_Host
> nor the cover letter of this patch series ? Have these been posted on
> the linux-scsi mailing list ?

Hi, Bart,

Wow, looks like I left out the first patch!  The cover letter I think
only went to lkml.  I have to do a repost, so I'll be sure to send the
cover to linux-scsi as well, and CC you (and credit you for the idea,
which I totally forgot to do).  I'll send a repost out today.

Cheers,
Jeff
