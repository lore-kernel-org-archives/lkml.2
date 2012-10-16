Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2JPIAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:00:14 -0400
Received: from relay.parallels.com ([195.214.232.42]:45421 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab2JPIAJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:00:09 -0400
Message-ID: <507D1406.50307@parallels.com>
Date: Tue, 16 Oct 2012 12:00:06 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [RFC PATCH] posix timers: allocate timer id per task
References: <20121015161559.7806.72762.stgit@localhost.localdomain> <1350320645.2336.38.camel@laptop>
In-Reply-To: <1350320645.2336.38.camel@laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

15.10.2012 21:04, Peter Zijlstra пишет:
> On Mon, 2012-10-15 at 20:17 +0400, Stanislav Kinsbursky wrote:
>> This patch is required CRIU project (www.criu.org).
>> To migrate processes with posix timers we have to make sure, that we can
>> restore posix timer with proper id.
>> Currently, this is not true, because timer ids are allocated globally.
>> So, this is precursor patch and it's purpose is make posix timer id to be
>> allocated per task.
>>
>> Patch replaces global idr with global hash table for posix timers and
>> makes timer ids unique not globally, but per task. Next free timer id is type
>> of integer and stored on signal struct (posix_timer_id). If free timer id
>> reaches negative value on timer creation, it will be dropped to zero and
>> -EAGAIN will be returned to user.
>> Hash table is size of page (4KB).
>> Key is constructed as follows:
>> key = hash_ptr(current->signal) ^ hash_32(posix_timer_id);
>
> but but but.. isn't this what namespaces were invented for to solve? Why
> not use the regular namespace infrastructure?
>

The reason is that CRIU have to support single processes within existent namespaces.

-- 
Best regards,
Stanislav Kinsbursky
