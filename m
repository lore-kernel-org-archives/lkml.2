Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758951Ab2C2Agm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 20:36:42 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:44033 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757930Ab2C2Agj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 20:36:39 -0400
Message-ID: <4F73AE95.1060402@tao.ma>
Date: Thu, 29 Mar 2012 08:36:37 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] block: Make cfq_target_latency tunable through sysfs.
References: <1332836213-5266-1-git-send-email-tm@tao.ma> <20120329003228.GA18424@kroah.com>
In-Reply-To: <20120329003228.GA18424@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 69.198.183.141 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 08:32 AM, Greg KH wrote:
> On Tue, Mar 27, 2012 at 04:16:53PM +0800, Tao Ma wrote:
>> From: Tao Ma <boyu.mt@taobao.com>
>>
>> In cfq, when we calculate a time slice for a process(or a cfqq to
>> be precise), we have to consider the cfq_target_latency so that all the
>> sync request have an estimated latency(300ms) and it is controlled by
>> cfq_target_latency. But in some hadoop test, we have found that if
>> there are many processes doing sequential read(24 for example), the
>> throughput is bad because every process can only work for about 25ms
>> and the cfqq is switched. That leads to a higher disk seek. We can
>> achive the good throughput by setting low_latency=0, but then some
>> read's latency is too much for the application.
>>
>> So this patch makes cfq_target_latency tunable through sysfs so that
>> we can tune it and find some magic number which is not bad for both
>> the throughput and the read latency.
> 
> If you add/modify sysfs files, you HAVE to also have a matching change
> to Documentation/ABI.
OK, I will add it in the next round. Great thanks.

Tao
> 
> Please do so.
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

