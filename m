Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab1EQHVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:21:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34568 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1EQHV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=cO7G5tl61QjsGHPl0qO3RJKgJ8mKdXEGCSpw3kJcTuDVPMz2MjoTzNVmbRVgRfCAOI
         ETFVtDe2t8GTKa2Vd/aAeszam7iFIZojLP6/zSeVfZMhxBLYfwZkgeQiBeUrgaFmbuIy
         Y9JeTv7VP63/B0HKwlKFYhscCzg18iVIaFhLQ=
Message-ID: <4DD221F4.5030708@gmail.com>
Date: Tue, 17 May 2011 09:21:24 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
References: <1305580757-13175-1-git-send-email-john.stultz@linaro.org>	 <1305580757-13175-3-git-send-email-john.stultz@linaro.org>	 <4DD19D10.3000201@gmail.com>  <1305587432.2915.57.camel@work-vm> <1305590200.2503.48.camel@Joe-Laptop>
In-Reply-To: <1305590200.2503.48.camel@Joe-Laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 01:56 AM, Joe Perches wrote:
> On Mon, 2011-05-16 at 16:10 -0700, John Stultz wrote:
>> On Mon, 2011-05-16 at 23:54 +0200, Jiri Slaby wrote:
>>>> In my attempt to clean up unprotected comm access, I've noticed
>>>> most comm access is done for printk output. To simplify correct
>>>> locking in these cases, I've introduced a new %ptc format,
>>>> which will print the corresponding task's comm.
>>>> Example use:
>>>> printk("%ptc: unaligned epc - sending SIGBUS.\n", current);
>>>> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
>>>> +static noinline_for_stack
>>> Actually, why noinline? Did your previous version have there some
>>> TASK_COMM_LEN buffer or anything on stack which is not there anymore?
>> No, I was just following how almost all of the pointer() called
>> functions were declared.
>> But with two pointers and a long, I add more then ip6_string() has on
>> the stack, which uses the same notation.
>> But I can drop that bit if there's really no need for it.
> 
> vsprintf can be recursive, I think you should keep it.

Why? pointer is marked as noinline. The others in pointer are marked as
noinline because they really have buffers on stack. There is no reason
to have noinline for task_comm_string though. I guess all tsk, ret and
flags will be optimized that way so they will be in registers, not on
stack at all.

thanks,
-- 
js
