Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932151Ab0GBQ0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 12:26:09 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64404 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932125Ab0GBQ0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 12:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=L8b+bkxeWaF32UdyGHDAxSDMky6bbrn1pjjuOmULFC5Cl1Y+kQPzMxREN/W/RrPQyc
         VgC+huvwDItt5h7m4/dHYfgVxFVf4LtkrFXp6GbyCaxCvSEQeAOJqJ/LzfoHohAWfVxf
         t16bczpWMSbZOrLeGTMkmxYKfcjaTQLkJ9VJE=
Message-ID: <4C2E1319.2050007@gmail.com>
Date: Fri, 02 Jul 2010 18:26:01 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: David Howells <dhowells@redhat.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, torvalds@linux-foundation.org,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
       dwalker@codeaurora.org, florian@mickler.org, andi@firstfloor.org,
       mst@redhat.com, randy.dunlap@oracle.com,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/4] async: use workqueue for worker pool
References: <4C2A2688.1020206@kernel.org> <1277759063-24607-1-git-send-email-tj@kernel.org> <1277759063-24607-35-git-send-email-tj@kernel.org> <20100628225513.GB10104@nowhere> <4C299FD8.7030904@kernel.org> <20100629121855.GA5318@nowhere> <4C2A1558.7060007@kernel.org> <20100629155228.GK5318@nowhere> <4C2A176F.1090101@kernel.org> <4C2A220B.8080006@linux.intel.com> <25085.1277847455@redhat.com> <4C2DAEBB.7090607@kernel.org> <4C2DB084.5040205@gmail.com> <4C2E0147.1090702@s5r6.in-berlin.de>
In-Reply-To: <4C2E0147.1090702@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2010 05:09 PM, Stefan Richter wrote:
> Tejun Heo wrote:
>> Replace private worker pool with system_long_wq.
> 
> system_unbound_wq actually.
> 
>> --- a/kernel/async.c
>> +++ b/kernel/async.c
>> @@ -49,40 +49,32 @@ asynchronous and synchronous parts of the kernel.
>>  */
>>
>>  #include <linux/async.h>
>> -#include <linux/bug.h>
>>  #include <linux/module.h>
>>  #include <linux/wait.h>
>>  #include <linux/sched.h>
>> -#include <linux/init.h>
>> -#include <linux/kthread.h>
>> -#include <linux/delay.h>
>>  #include <linux/slab.h>
>>  #include <asm/atomic.h>
>>
> 
> Shouldn't it include linux/workqueue.h now?

Updated.  Thanks a lot.

-- 
tejun
