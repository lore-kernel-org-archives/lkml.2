Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab1CJB3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 20:29:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:23291 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752971Ab1CJB3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 20:29:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,293,1297065600"; 
   d="scan'208";a="611071155"
Message-ID: <4D782986.5040500@linux.intel.com>
Date: Wed, 09 Mar 2011 17:29:42 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional assignment
 of CC and AR"
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>	 <1299715137-22768-3-git-send-email-dhsharp@google.com>	 <1299720102.15854.269.camel@gandalf.stny.rr.com> <1299720486.15854.271.camel@gandalf.stny.rr.com>
In-Reply-To: <1299720486.15854.271.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 05:28 PM, Steven Rostedt wrote:
> On Wed, 2011-03-09 at 20:21 -0500, Steven Rostedt wrote:
>> On Wed, 2011-03-09 at 15:58 -0800, David Sharp wrote:
>>> This reverts commit 6c696cec3f264a9399241b6e648f58bc97117d49.
>>>
>>> Make has default values CC and AR of 'cc' and 'ar' respectively. This means
>>> that "CC ?= anything" will never have effect, because CC is always already set.
>>> Because of this, 6c696cec makes setting CROSS_COMPILE from the command line or
>>> environment useless.
>>
>> Darren, can you verify this, as you were the one to make the original
>> change. I never had to cross compile it, I always did it natively.
>
> OK, I just proved that David is correct, with the following make file:
>
> ---
> CC ?= foo
> AR ?= bar
> all:
> 	echo what is $(CC) $(AR)

> ---
>
> $ make
> what is cc ar
>
>
> Darren, can you just give an Acked-by anyway. I hate to apply a revert
> of your patch without you doing so.

I really thought I tested that - clearly not :/ Sorry about that. Please 
see my response to David for an alternate proposal.

--
Darren

>
> Thanks,
>
> -- Steve
>
>


-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
