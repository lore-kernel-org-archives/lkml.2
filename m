Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab2KEO52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:57:28 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:42043 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab2KEO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:57:27 -0500
Message-ID: <5097D3D2.9020407@acm.org>
Date: Mon, 05 Nov 2012 15:57:22 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [patch,v2 05/10] sd: use alloc_disk_node
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com> <1351892763-21325-6-git-send-email-jmoyer@redhat.com> <50954852.5050209@acm.org> <x497gq0cf54.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x497gq0cf54.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/12 15:12, Jeff Moyer wrote:
> Bart Van Assche <bvanassche@acm.org> writes:
>
>> On 11/02/12 22:45, Jeff Moyer wrote:
>>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>>> ---
>>>    drivers/scsi/sd.c |    2 +-
>>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>> index 12f6fdf..8deb915 100644
>>> --- a/drivers/scsi/sd.c
>>> +++ b/drivers/scsi/sd.c
>>> @@ -2714,7 +2714,7 @@ static int sd_probe(struct device *dev)
>>>    	if (!sdkp)
>>>    		goto out;
>>>
>>> -	gd = alloc_disk(SD_MINORS);
>>> +	gd = alloc_disk_node(SD_MINORS, dev_to_node(dev));
>>>    	if (!gd)
>>>    		goto out_free;
>>
>> shost->numa_node can be another NUMA node than dev_to_node(dev). Have
>> you considered using shost->numa_node here ?
>
> It can?  How?

E.g. if the LLD allows the user to specify the value of numa_node and 
passes that value to scsi_host_alloc_node() (see also 
http://lkml.org/lkml/2012/10/23/477 for further information).

> Just so I'm clear, you're suggesting I use the scsi_device's host
> pointer to get to the Scsi_Host, and that *will* be filled in that this
> point, right?

As far as I can see the sdev->host pointer is set in scsi_alloc_sdev() 
and that happens before sd_probe() is invoked.

Bart.

