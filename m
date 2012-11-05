Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab2KEPcu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:32:50 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46765 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab2KEPcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:32:46 -0500
Message-ID: <5097DC13.9060809@gmail.com>
Date: Mon, 05 Nov 2012 23:32:35 +0800
From: taco <tacoee@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [patch,v2 05/10] sd: use alloc_disk_node
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com> <1351892763-21325-6-git-send-email-jmoyer@redhat.com> <50954852.5050209@acm.org> <x497gq0cf54.fsf@segfault.boston.devel.redhat.com> <5097D3D2.9020407@acm.org>
In-Reply-To: <5097D3D2.9020407@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 10:57 PM, Bart Van Assche wrote:
> On 11/05/12 15:12, Jeff Moyer wrote:
>> Bart Van Assche <bvanassche@acm.org> writes:
>>
>>> On 11/02/12 22:45, Jeff Moyer wrote:
>>>> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
>>>> ---
>>>>    drivers/scsi/sd.c |    2 +-
>>>>    1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>>>> index 12f6fdf..8deb915 100644
>>>> --- a/drivers/scsi/sd.c
>>>> +++ b/drivers/scsi/sd.c
>>>> @@ -2714,7 +2714,7 @@ static int sd_probe(struct device *dev)
>>>>        if (!sdkp)
>>>>            goto out;
>>>>
>>>> -    gd = alloc_disk(SD_MINORS);
>>>> +    gd = alloc_disk_node(SD_MINORS, dev_to_node(dev));
>>>>        if (!gd)
>>>>            goto out_free;
>>>
>>> shost->numa_node can be another NUMA node than dev_to_node(dev). Have
>>> you considered using shost->numa_node here ?
>>
>> It can?  How?
>
> E.g. if the LLD allows the user to specify the value of numa_node and 
> passes that value to scsi_host_alloc_node() (see also 
> http://lkml.org/lkml/2012/10/23/477 for further information).
>
>> Just so I'm clear, you're suggesting I use the scsi_device's host
>> pointer to get to the Scsi_Host, and that *will* be filled in that this
>> point, right?
>
> As far as I can see the sdev->host pointer is set in scsi_alloc_sdev() 
> and that happens before sd_probe() is invoked.
>
yes, struct scsi_device was created before sd, sd is the top layer.
> Bart.
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


