Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1EDK3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 06:29:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56122 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1EDK3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 06:29:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JQfuE3/RLm2/l4j2DGODY301z9QAji1TRVRe7lkRiGf9P/8rGJAjGoiUNcWuc6CwXf
         OIizqOrkhvAbmr3HWybMbRDt+VqehlYjmiH2SQ98T8kFv0LT3TM4Gq0btWJU7dJlzGUw
         GJ6RQZgVuW24WgzBcmvESaSVaIhEqGr+I22i0=
Message-ID: <4DC12A96.7030305@pobox.com>
Date: Wed, 04 May 2011 06:29:42 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: shaohua.li@intel.com, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, jaxboe@fusionio.com, hch@infradead.org,
        djwong@us.ibm.com
Subject: Re: [patch v2 3/3] SATA: enable non-queueable flush flag
References: <20110504081725.946950281@sli10-conroe.sh.intel.com> <20110504082115.488846050@sli10-conroe.sh.intel.com> <20110504085323.GB8007@htj.dyndns.org>
In-Reply-To: <20110504085323.GB8007@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 04:53 AM, Tejun Heo wrote:
> On Wed, May 04, 2011 at 04:17:28PM +0800, shaohua.li@intel.com wrote:
>> @@ -3424,7 +3424,9 @@ void ata_scsi_scan_host(struct ata_port
>>   			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
>>   						 NULL);
>>   			if (!IS_ERR(sdev)) {
>> +				struct request_queue *q = sdev->request_queue;
>>   				dev->sdev = sdev;
>> +				blk_set_queue_flush_queueable(q, false);
>>   				scsi_device_put(sdev);
>>   			} else {
>>   				dev->sdev = NULL;

> Isn't ata_scsi_dev_config() better place for this?

Yes :)

