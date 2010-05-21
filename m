Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470Ab0EUOyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:54:00 -0400
Received: from relay.parallels.com ([195.214.232.42]:41430 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755325Ab0EUOx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:53:58 -0400
Message-ID: <4BF69E82.4060904@parallels.com>
Date: Fri, 21 May 2010 18:53:54 +0400
From: Konstantin Khlebnikov <khlebnikov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH 1/2] cfq-iosched: remove dead_key from cfq_io_context
References: <20100520192134.19366.88949.stgit@zurg> <20100521094047.GB11217@kernel.dk>
In-Reply-To: <20100521094047.GB11217@kernel.dk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.05.2010 13:40, Jens Axboe wrote:
> On Thu, May 20 2010, Konstantin Khlebnikov wrote:
>> Remove ->dead_key field from cfq_io_context to shrink its size to 128 bytes.
>> (64 bytes for 32-bit hosts)
>>
>> Use lower bit in ->key as dead-mark, instead of moving key to separate field.
>> After this for dead cfq_io_context we got cic->key != cfqd automatically.
>> Thus, io_context's last-hit cache should work without changing.
>>
>> Now to check ->key for non-dead state compare it with cfqd,
>> instead of checking ->key for non-null value as it was before.
>>
>> Plus remove obsolete race protection in cfq_cic_lookup.
>> This race gone after v2.6.24-1728-g4ac845a
>
> This, and the second patch, look really good. How much testing have you
> done with it?
>

I have run multiple fsstress and simultaneously switch io-scheduler in loop
for several hours, no oopses and leaks detected.
