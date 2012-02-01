Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab2BADCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 22:02:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57589 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2BADCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 22:02:06 -0500
Message-ID: <4F28AB24.8050600@gmail.com>
Date: Wed, 01 Feb 2012 11:01:56 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [Patch] lkdtm: avoid calling lkdtm_do_action() with spin lock
 held
References: <1327755168-12240-1-git-send-email-xiyou.wangcong@gmail.com> <20120130125429.56f6f7d0.akpm@linux-foundation.org> <4F27EBBF.6040103@gmail.com> <201201311535.53526.arnd@arndb.de>
In-Reply-To: <201201311535.53526.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 11:35 PM, Arnd Bergmann wrote:
> On Tuesday 31 January 2012, Cong Wang wrote:
>> @@ -323,14 +323,16 @@ static void lkdtm_do_action(enum ctype which)
>>          }
>>          case CT_WRITE_AFTER_FREE: {
>>                  size_t len = 1024;
>> -               u32 *data = kmalloc(len, GFP_KERNEL);
>> +               u32 *data = kmalloc(len, GFP_ATOMIC);
>>
>>                  kfree(data);
>> -               schedule();
>> +               udelay(100);
>>                  memset(data, 0x78, len);
>>                  break;
>>          }
>
> I can't think of why the udelay would have any positive effect here,
> if the idea of the schedule was to let some other process allocate and
> use the memory.


Hmm, on SMP udelay on this CPU will give a chance to other CPU's to use 
that memory, right?

>
> Can't you just get rid of the count_lock if you use an atomic_t for the
> count and use appropriate accesses on it?
>

Good idea, will do.

