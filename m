Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab0EUReM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 13:34:12 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51285 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab0EUReK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 13:34:10 -0400
Date: Fri, 21 May 2010 19:34:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Konstantin Khlebnikov <khlebnikov@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] cfq-iosched: remove dead_key from cfq_io_context
Message-ID: <20100521173408.GH11217@kernel.dk>
References: <20100520192134.19366.88949.stgit@zurg> <20100521094047.GB11217@kernel.dk> <4BF69E82.4060904@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BF69E82.4060904@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21 2010, Konstantin Khlebnikov wrote:
> On 21.05.2010 13:40, Jens Axboe wrote:
>> On Thu, May 20 2010, Konstantin Khlebnikov wrote:
>>> Remove ->dead_key field from cfq_io_context to shrink its size to 128 bytes.
>>> (64 bytes for 32-bit hosts)
>>>
>>> Use lower bit in ->key as dead-mark, instead of moving key to separate field.
>>> After this for dead cfq_io_context we got cic->key != cfqd automatically.
>>> Thus, io_context's last-hit cache should work without changing.
>>>
>>> Now to check ->key for non-dead state compare it with cfqd,
>>> instead of checking ->key for non-null value as it was before.
>>>
>>> Plus remove obsolete race protection in cfq_cic_lookup.
>>> This race gone after v2.6.24-1728-g4ac845a
>>
>> This, and the second patch, look really good. How much testing have you
>> done with it?
>>
>
> I have run multiple fsstress and simultaneously switch io-scheduler in loop
> for several hours, no oopses and leaks detected.

OK, I'll queue it up for later in the 2.6.35 cycle.

-- 
Jens Axboe

