Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab1CJGen (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:34:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:9967 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab1CJGem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:34:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,294,1297065600"; 
   d="scan'208";a="895754139"
Message-ID: <4D7870EC.3080105@linux.intel.com>
Date: Wed, 09 Mar 2011 22:34:20 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional assignment
 of CC and AR"
References: <1299715137-22768-1-git-send-email-dhsharp@google.com>	 <1299715137-22768-3-git-send-email-dhsharp@google.com>	 <4D7828F9.7000906@linux.intel.com>	 <1299720997.15854.276.camel@gandalf.stny.rr.com>	 <4D783038.8080103@linux.intel.com>	 <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com> <1299725486.15854.281.camel@gandalf.stny.rr.com>
In-Reply-To: <1299725486.15854.281.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 06:51 PM, Steven Rostedt wrote:
> On Wed, 2011-03-09 at 18:27 -0800, David Sharp wrote:
>> On Wed, Mar 9, 2011 at 5:58 PM, Darren Hart<dvhart@linux.intel.com>  wrote:
>
>>> dvhart@doubt:templates$ cat Makefile
>>> ifdef CROSS_COMPILE
>>> CC = $(CROSS_COMPILE)gcc
>>> AR = $(CROSS_COMPILE)ar
>>> endif
>>>
>>> all:
>>>         echo "CC: $(CC)"
>>>
>>> dvhart@doubt:templates$ make -s
>>> CC: cc
>>>
>>> dvhart@doubt:templates$ CC=gcc-4.5.1 make -s
>>> CC: gcc-4.5.1
>>>
>>> dvhart@doubt:templates$ CROSS_COMPILE=my-cross- make -s
>>> CC: my-cross-gcc
>>>
>>>
>>> Seems to meet everyone's needs without changing any tools/scripts/etc that
>>> have used trace-cmd before or after the CC ?= wreckage.
>>
>> It's a little odd that the default CC is "cc" unless you supply
>> CROSS_COMPILE, then it's "gcc". I'd probably be okay with this, but I
>> would think it's weird.
>>
>> I don't know the answers, but if we take the kernel Makefile as a
>> template, then setting CC doesn't work.
>>
>
> I really don't care much for this either. But I'm trying to make it work
> for everyone. Honestly, I think the BUILD_CC version is the cleanest,
> but I understand that this will add a burden onto Darren to fix his
> tools to handle it, whereas, I would like to avoid that.

This is a very minor issue and will take me less time to fix than 
another half-dozen emails arguing for a different solution :-) However, 
being able to specify CC on the command line _is_ a very common thing, 
and preventing it from working will likely cause this to come up again 
in the future.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
