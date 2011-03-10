Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752348Ab1CJGcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:32:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:30162 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215Ab1CJGch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:32:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,294,1297065600"; 
   d="scan'208";a="895753786"
Message-ID: <4D787084.3000402@linux.intel.com>
Date: Wed, 09 Mar 2011 22:32:36 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Sharp <dhsharp@google.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mrubin@google.com
Subject: Re: [PATCH trace-cmd 3/3] Revert "trace-cmd: Use conditional assignment
 of CC and AR"
References: <1299715137-22768-1-git-send-email-dhsharp@google.com> <1299715137-22768-3-git-send-email-dhsharp@google.com> <4D7828F9.7000906@linux.intel.com> <1299720997.15854.276.camel@gandalf.stny.rr.com> <4D783038.8080103@linux.intel.com> <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>
In-Reply-To: <AANLkTikHy1pZP0=cpmSD_HG-jeJvgne3u2ivOif6DHP8@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 06:27 PM, David Sharp wrote:
> On Wed, Mar 9, 2011 at 5:58 PM, Darren Hart<dvhart@linux.intel.com>  wrote:
>> On 03/09/2011 05:36 PM, Steven Rostedt wrote:
>>> On Wed, 2011-03-09 at 17:27 -0800, Darren Hart wrote:
>>>> On 03/09/2011 03:58 PM, David Sharp wrote:
>>>>>
>>>>> This reverts commit 6c696cec3f264a9399241b6e648f58bc97117d49.
>>>>>
>>>>> Make has default values CC and AR of 'cc' and 'ar' respectively. This
>>>>> means
>>>>> that "CC ?= anything" will never have effect, because CC is always
>>>>> already set.
>>>>> Because of this, 6c696cec makes setting CROSS_COMPILE from the command
>>>>> line or
>>>>> environment useless.
>>>>
>>>> The problem with this approach is it prevents the user from setting CC
>>>> explicitly with the environment which is a very common way of using a
>>>> specific version of gcc (for example). It also places restrictions on
>>>> the filename of the compiler (it must end in gcc - so gcc-4.5.1 cannot
>>>> work), this isn't acceptable.
>>>>
>>>> You could use CC=your-cross-compiler, and if that doesn't work for you,
>>>> you could prepare a patch that conditionally sets CC only if
>>>> CROSS_COMPILE is set, but please do not simply revert this patch which
>>>> solved a real problem with the Makefile.
>>>
>>> Hmm, but the thing is, the change did not work,
>>
>> It did work for me as I was setting CC= on the command line.
>>
>> unless your environment
>>>
>>> for some reason does not supply a 'cc'. Or that 'cc' defaulted to the
>>> compiler that you wanted, where 'gcc' would not.
>>>
>>> Thus, would you be fine with something like:
>>>
>>>         BUILD_CC ?=     $(CROSS_COMPILE)gcc
>>>         CC       =      $(BUILD_CC)
>>
>> This would also work, but what is wrong with:
>>
>> dvhart@doubt:templates$ cat Makefile
>> ifdef CROSS_COMPILE
>> CC = $(CROSS_COMPILE)gcc
>> AR = $(CROSS_COMPILE)ar
>> endif
>>
>> all:
>>         echo "CC: $(CC)"
>>
>> dvhart@doubt:templates$ make -s
>> CC: cc
>>
>> dvhart@doubt:templates$ CC=gcc-4.5.1 make -s
>> CC: gcc-4.5.1
>>
>> dvhart@doubt:templates$ CROSS_COMPILE=my-cross- make -s
>> CC: my-cross-gcc
>>
>>
>> Seems to meet everyone's needs without changing any tools/scripts/etc that
>> have used trace-cmd before or after the CC ?= wreckage.
>
> It's a little odd that the default CC is "cc" unless you supply
> CROSS_COMPILE, then it's "gcc". I'd probably be okay with this, but I
> would think it's weird.

Note that I don't specify cc anywhere, that is what Make uses as the 
default CC, and at least on Ubuntu 10.10 /usr/bin/cc is in the path and 
points to gcc (eventually). So this seems pretty no

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
