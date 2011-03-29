Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1C2ORD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:17:03 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:56036 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668Ab1C2ORB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:17:01 -0400
X-ASG-Debug-ID: 1301408220-01de284cf8d1df0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D91E9DA.4050504@fusionio.com>
Date: Tue, 29 Mar 2011 16:16:58 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Rob Landley <rlandley@parallels.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <4D9179EE.9040707@parallels.com> <4D917DB1.9030300@fusionio.com> <4D919DE5.1010509@parallels.com> <4D91E5CE.1080803@fusionio.com> <4D91E912.7060307@parallels.com>
X-ASG-Orig-Subj: Re: Commit 7eaceaccab5f40 causing boot hang.
In-Reply-To: <4D91E912.7060307@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301408220
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59316
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-29 16:13, Rob Landley wrote:
> On 03/29/2011 08:59 AM, Jens Axboe wrote:
>> On 2011-03-29 10:52, Rob Landley wrote:
>>> I'm booting all this under kvm or qemu, by the way:
>>>
>>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
>>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
>>>
>>> Sometimes with init=/bin/bash in that last quoted bit.  The root
>>> filesystem's debian sid but that's probably not relevant because it
>>> worked fine with .38.
>>
>> Does this help?
>>
>> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
>> index 0e406d73..ca27d30 100644
>> --- a/drivers/ide/ide-io.c
>> +++ b/drivers/ide/ide-io.c
>> @@ -570,8 +570,7 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
>>  	spin_unlock_irqrestore(q->queue_lock, flags);
>>  
>>  	/* Use 3ms as that was the old plug delay */
>> -	if (rq)
>> -		blk_delay_queue(q, 3);
>> +	blk_delay_queue(q, 3);
>>  }
>>  
>>  static int drive_is_ready(ide_drive_t *drive)
>>
> 
> Nope, still hung the same way.

Funky. I'll try and reproduce this tonight.

-- 
Jens Axboe

