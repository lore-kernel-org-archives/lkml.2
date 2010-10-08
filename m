Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab0JHWBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 18:01:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54384 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab0JHWBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 18:01:20 -0400
Message-ID: <4CAF9448.7070906@zytor.com>
Date: Fri, 08 Oct 2010 14:59:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andreas Gruenbacher <agruen@suse.de>
CC: David Daney <ddaney@caviumnetworks.com>, Eric Paris <eparis@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.36-rc7
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <201010081406.10190.agruen@suse.de> <4CAF47F3.3070800@caviumnetworks.com> <201010082350.01135.agruen@suse.de>
In-Reply-To: <201010082350.01135.agruen@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 02:50 PM, Andreas Gruenbacher wrote:
> On Friday 08 October 2010 18:33:55 David Daney wrote:
>> On 10/08/2010 05:06 AM, Andreas Gruenbacher wrote:
>>> On Thursday 07 October 2010 19:49:28 Eric Paris wrote:
>>>> The safest thing would probably be to punt the syscalls to 2.6.37.
>>>> Which is sad since I know a number of people are already working against
>>>> them, but maybe that proves it's the best approach?
>>>
>>> I agree with removing the syscalls from 2.6.36 because of the following
>>> reasons:
>>
>> How would the mechanics of this be achieved?
>>
>> Is it enough to just unconditionally return -ENOSYS from the sys_*() 
>> functions?  Or should all the patches be reverted?
> 
> Whatever works I guess ... they would get reactivated pretty soon, anyway.
> 

Returning -ENOSYS should be sufficient (that's what a non-system-call
does); it would *also* be good to block any headers from getting
exported to userspace so people don't end up with compiling against the
wrong version of the kernel headers and then wonder why their code
doesn't work in the future.

	-hpa
