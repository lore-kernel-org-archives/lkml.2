Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab2E3G1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 02:27:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab2E3G1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 02:27:07 -0400
Message-ID: <4FC5BDF5.2040000@redhat.com>
Date: Wed, 30 May 2012 14:28:05 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tim Gardner <rtg.canonical@gmail.com>
CC: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tim.gardner@canonical.com
Subject: Re: [PATCH V3] block: Mitigate lock unbalance caused by lock switching
References: <20120528102214.GB15202@dhcp-172-17-108-109.mtv.corp.google.com> <1338255542-22247-1-git-send-email-asias@redhat.com> <4FC4D2F2.2070309@gmail.com>
In-Reply-To: <4FC4D2F2.2070309@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 09:45 PM, Tim Gardner wrote:
> On 05/28/2012 07:39 PM, Asias He wrote:
>
> <snip>
>
>> @@ -440,6 +435,11 @@ void blk_cleanup_queue(struct request_queue *q)
>>   	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
>>   	blk_sync_queue(q);
>>
>> +	spin_lock_irq(lock);
>> +	if (q->queue_lock !=&q->__queue_lock)
>> +		q->queue_lock =&q->__queue_lock;
>> +	spin_unlock_irq(lock);
>> +
>
> Isn't the 'if' clause superfluous ? You could just do the assignment, e.g.,
>
> +	spin_lock_irq(lock);
> +	q->queue_lock =&q->__queue_lock;
> +	spin_unlock_irq(lock);

Well, this saves a if clause but adds an unnecessary assignment if the 
lock is already internal lock.

-- 
Asias
