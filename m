Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1C2ONp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:13:45 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37943 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab1C2ONn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:13:43 -0400
Message-ID: <4D91E912.7060307@parallels.com>
Date: Tue, 29 Mar 2011 09:13:38 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Commit 7eaceaccab5f40 causing boot hang.
References: <4D9179EE.9040707@parallels.com> <4D917DB1.9030300@fusionio.com> <4D919DE5.1010509@parallels.com> <4D91E5CE.1080803@fusionio.com>
In-Reply-To: <4D91E5CE.1080803@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 08:59 AM, Jens Axboe wrote:
> On 2011-03-29 10:52, Rob Landley wrote:
>> I'm booting all this under kvm or qemu, by the way:
>>
>> qemu-system-x86_64 -m 1024 -kernel arch/x86/boot/bzImage \
>>   -hda ~/sid.ext3 -append "root=/dev/hda rw"
>>
>> Sometimes with init=/bin/bash in that last quoted bit.  The root
>> filesystem's debian sid but that's probably not relevant because it
>> worked fine with .38.
> 
> Does this help?
> 
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index 0e406d73..ca27d30 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -570,8 +570,7 @@ void ide_requeue_and_plug(ide_drive_t *drive, struct request *rq)
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  
>  	/* Use 3ms as that was the old plug delay */
> -	if (rq)
> -		blk_delay_queue(q, 3);
> +	blk_delay_queue(q, 3);
>  }
>  
>  static int drive_is_ready(ide_drive_t *drive)
> 

Nope, still hung the same way.

Rob
