Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2LVDlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 22:41:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2LVDlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 22:41:00 -0500
Message-ID: <50D52C9F.9030808@redhat.com>
Date: Fri, 21 Dec 2012 22:44:31 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, aquini@redhat.com, walken@google.com,
        lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3 -v2] x86,smp: auto tune spinlock backoff delay
 factor
References: <20121221184940.103c31ad@annuminas.surriel.com>  <20121221185147.4ae48ab5@annuminas.surriel.com>  <20121221185613.1f4c9523@annuminas.surriel.com> <1356146982.21834.8321.camel@edumazet-glaptop>
In-Reply-To: <1356146982.21834.8321.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 10:29 PM, Eric Dumazet wrote:
> On Fri, 2012-12-21 at 18:56 -0500, Rik van Riel wrote:
>> +	int *delay_ptr = &per_cpu(spinlock_delay, smp_processor_id());
>> +	int delay = *delay_ptr;
>
> int delay = __this_cpu_read(spinlock_delay);
>
>>   	}
>> +	*delay_ptr = delay;
>
> __this_cpu_write(spinlock_delay, delay);

Thanks for that cleanup. I have applied it to my code.

