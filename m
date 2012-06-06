Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2FFCLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 22:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2FFCLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 22:11:35 -0400
Message-ID: <4FCEBC9B.5040201@redhat.com>
Date: Wed, 06 Jun 2012 10:12:43 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: Tejun Heo <tj@kernel.org>, Tim Gardner <rtg.canonical@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        tim.gardner@canonical.com
Subject: Re: [PATCH V3] block: Mitigate lock unbalance caused by lock switching
References: <20120528102214.GB15202@dhcp-172-17-108-109.mtv.corp.google.com> <1338255542-22247-1-git-send-email-asias@redhat.com> <4FC4D2F2.2070309@gmail.com> <4FC5BDF5.2040000@redhat.com> <CAOS58YMq1DiWgHGsjpABhaeYs9RjRgkHoifQQUKTKNi876bNgQ@mail.gmail.com> <4FC88BF9.2030807@kernel.dk>
In-Reply-To: <4FC88BF9.2030807@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens

On 06/01/2012 05:31 PM, Jens Axboe wrote:
> On 05/30/2012 08:28 AM, Tejun Heo wrote:
>> Hello,
>>
>> On Wed, May 30, 2012 at 3:28 PM, Asias He<asias@redhat.com>  wrote:
>>>> Isn't the 'if' clause superfluous ? You could just do the assignment,
>>>> e.g.,
>>>>
>>>> +       spin_lock_irq(lock);
>>>> +       q->queue_lock =&q->__queue_lock;
>>>> +       spin_unlock_irq(lock);
>>>
>>>
>>> Well, this saves a if clause but adds an unnecessary assignment if the lock
>>> is already internal lock.
>>
>> It's not hot path. Dirtying the cacheline there doesn't mean anything.
>> I don't really care either way but making optimization argument is
>> pretty silly here.
>
> And more importantly, dropping the if loses information as well. That's
> a lot more important than any misguided optimization attempts. So I
> agree, the if stays.

Could you pick this patch in your tree?

-- 
Asias
