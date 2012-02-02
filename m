Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2BBO1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:27:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33879 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960Ab2BBO1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:27:45 -0500
Message-ID: <4F2A9D56.3080102@gmail.com>
Date: Thu, 02 Feb 2012 22:27:34 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>, Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/2] lkdtm: use atomic_t to replace count_lock
References: <1328079501-24746-1-git-send-email-xiyou.wangcong@gmail.com> <201202011527.35366.arnd@arndb.de> <4F2A90B4.1050709@gmail.com> <201202021344.19455.arnd@arndb.de>
In-Reply-To: <201202021344.19455.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 09:44 PM, Arnd Bergmann wrote:
> On Thursday 02 February 2012, Cong Wang wrote:
>>> In order to have an atomic here, you have to use a loop around
>>> atomic_cmpxchg, like
>>>
>>>
>>>        int old, new;
>>>        old = atomic_read(&count);
>>>        do {
>>>                new = old ? old - 1 : cpoint_count;
>>>                old = cmpxchg(&count, old, new);
>>>        } while (old != new);
>>>
>>> I suppose you could also just keep the spinlock and move lkdtm_do_action()
>>> outside of it?
>>
>> If we still need spinlock, I think we don't need to bother atomic_t at all.
>
> Yes, it's one or the other: If you use the cmpxchg loop, you don't need a
> spinlock and vice versa.
>

The cmpxchg loop is for comparing and assigning to 'count', but still 
there is a printk() above that needs to read 'count'. Combining these 
two operations means we have to use a spinlock, correct? Because there 
is a chance that another process could change 'count' in between.

Thanks.
