Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1B1T3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 14:29:01 -0500
Received: from relay1.sgi.com ([192.48.179.29]:38782 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab1B1T3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 14:29:00 -0500
Message-ID: <4D6BF77E.2030107@sgi.com>
Date: Mon, 28 Feb 2011 11:29:02 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] printk: Allocate kernel log buffer earlier
References: <20110225180633.857892225@gulag1.americas.sgi.com> <20110225180634.017570095@gulag1.americas.sgi.com> <20110227120949.GF16453@elte.hu> <20110227121518.GA19165@elte.hu> <4D6AFBB0.70401@kernel.org> <20110228080642.GC1600@elte.hu>
In-Reply-To: <20110228080642.GC1600@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> +	new_addr = memblock_alloc(new_log_buf_len, PAGE_SIZE);
>> +	if (new_addr != MEMBLOCK_ERROR)
>> +		new_log_buf = __va(new_addr);
>> +	else
>> +		new_log_buf = alloc_bootmem(new_log_buf_len);
> 
> alloc_bootmem() can fail, especially if someone uses a too large boot parameter 
> value - and your code does not check for failure.

alloc_bootmem does panic when it can't allocate memory.

Ingo, we have a "uvconfig" script that sets up the boot parameters (there
are many that are needed to be very specific).  It sets up the log_buf_len
to be 8M.  We will never overflow memory with that.

And if someone is stupid enough to try and allocate a log buffer that
consumes more memory than they have, then they have a different kind of
problem.

> 
> Thanks,
> 
> 	Ingo
