Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab2KEOHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 09:07:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab2KEOHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 09:07:03 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [patch,v2 01/10] scsi: add scsi_host_alloc_node
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
	<1351892763-21325-2-git-send-email-jmoyer@redhat.com>
	<509547D5.2020800@acm.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 05 Nov 2012 09:06:53 -0500
In-Reply-To: <509547D5.2020800@acm.org> (Bart Van Assche's message of "Sat, 03
	Nov 2012 17:35:33 +0100")
Message-ID: <x49fw4ocfeq.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> writes:

> On 11/02/12 22:45, Jeff Moyer wrote:
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index 593085a..7d7ad8b 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -336,16 +336,25 @@ static struct device_type scsi_host_type = {
>>    **/
>>   struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>>   {
>> +	return scsi_host_alloc_node(sht, privsize, -1);
>
> Using NUMA_NO_NODE here might improve readability.

Agreed, I'll fix that.

>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index 4908480..a1b5c8e 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -733,6 +733,12 @@ struct Scsi_Host {
>>   	struct device *dma_dev;
>>
>>   	/*
>> +	 * Numa node this device is closest to, used for allocating
>> +	 * data structures locally.
>> +	 */
>> +	int numa_node;
>
> Have you considered using #ifdef CONFIG_NUMA / #endif here ? I've
> noticed that all other numa_node members in structures under include/
> have this.

That was an oversight, thanks for pointing it out.  I'll fix it up.

Cheers,
Jeff
