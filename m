Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612Ab2C2Kj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 06:39:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41330 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab2C2KjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 06:39:21 -0400
Message-ID: <4F743B8E.6070807@kernel.dk>
Date: Thu, 29 Mar 2012 12:38:06 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tao Ma <tm@tao.ma>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Make cfq_target_latency tunable through sysfs.
References: <1332836213-5266-1-git-send-email-tm@tao.ma> <20120329003228.GA18424@kroah.com> <4F73AE95.1060402@tao.ma>
In-Reply-To: <4F73AE95.1060402@tao.ma>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 02:36 AM, Tao Ma wrote:
> On 03/29/2012 08:32 AM, Greg KH wrote:
>> On Tue, Mar 27, 2012 at 04:16:53PM +0800, Tao Ma wrote:
>>> From: Tao Ma <boyu.mt@taobao.com>
>>>
>>> In cfq, when we calculate a time slice for a process(or a cfqq to
>>> be precise), we have to consider the cfq_target_latency so that all the
>>> sync request have an estimated latency(300ms) and it is controlled by
>>> cfq_target_latency. But in some hadoop test, we have found that if
>>> there are many processes doing sequential read(24 for example), the
>>> throughput is bad because every process can only work for about 25ms
>>> and the cfqq is switched. That leads to a higher disk seek. We can
>>> achive the good throughput by setting low_latency=0, but then some
>>> read's latency is too much for the application.
>>>
>>> So this patch makes cfq_target_latency tunable through sysfs so that
>>> we can tune it and find some magic number which is not bad for both
>>> the throughput and the read latency.
>>
>> If you add/modify sysfs files, you HAVE to also have a matching change
>> to Documentation/ABI.
> OK, I will add it in the next round. Great thanks.

If you do that, we can queue up the patch. I'm also a bit nervous about
adding new sysfs files, but target latency is generic enough that it
definitely makes sense to add.

-- 
Jens Axboe

