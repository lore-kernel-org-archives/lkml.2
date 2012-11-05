Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab2KEOMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:12:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932276Ab2KEOMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:12:45 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [patch,v2 05/10] sd: use alloc_disk_node
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
	<1351892763-21325-6-git-send-email-jmoyer@redhat.com>
	<50954852.5050209@acm.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 05 Nov 2012 09:12:39 -0500
In-Reply-To: <50954852.5050209@acm.org> (Bart Van Assche's message of "Sat, 03
	Nov 2012 17:37:38 +0100")
Message-ID: <x497gq0cf54.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> writes:

> On 11/02/12 22:45, Jeff Moyer wrote:
>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>> ---
>>   drivers/scsi/sd.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 12f6fdf..8deb915 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2714,7 +2714,7 @@ static int sd_probe(struct device *dev)
>>   	if (!sdkp)
>>   		goto out;
>>
>> -	gd = alloc_disk(SD_MINORS);
>> +	gd = alloc_disk_node(SD_MINORS, dev_to_node(dev));
>>   	if (!gd)
>>   		goto out_free;
>
> shost->numa_node can be another NUMA node than dev_to_node(dev). Have
> you considered using shost->numa_node here ?

It can?  How?

Just so I'm clear, you're suggesting I use the scsi_device's host
pointer to get to the Scsi_Host, and that *will* be filled in that this
point, right?

Cheers,
Jeff
