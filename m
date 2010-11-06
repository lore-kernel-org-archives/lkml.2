Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0KFAe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 20:34:59 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29092 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0KFAe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 20:34:56 -0400
Message-ID: <4CD4A272.8000000@oracle.com>
Date: Fri, 05 Nov 2010 17:33:54 -0700
From: Randy Dunlap <randy.dunlap@Oracle.COM>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.37-rc1 (floppy module load: no device found)
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com> <20101103161638.ddc75ace.randy.dunlap@oracle.com> <AANLkTinj2sk==Jw7ZL3RvO_M7iRPW0sQy8dsvabo-V5h@mail.gmail.com> <4CD48D5E.10309@oracle.com> <AANLkTi=3f6f5MoZAX4C4ufYkopn8Z_xrR6nd-GzkoDhg@mail.gmail.com>
In-Reply-To: <AANLkTi=3f6f5MoZAX4C4ufYkopn8Z_xrR6nd-GzkoDhg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/10 16:36, Linus Torvalds wrote:
> On Fri, Nov 5, 2010 at 4:03 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> On 11/05/10 15:10, Linus Torvalds wrote:
>>>
>>> Randy, is this one also related to that ipv6 percpu list corruption?
>>> IOW, does it go away with
>>>
>>>   http://patchwork.ozlabs.org/patch/69939/
>>>
>>> like one of your other reports did?
>>
>> The list_debug.c message goes away, but it still gets the GP fault.
> 
> Ok. I think there's a separate floppy.c bug introduced in commit
> 488211844e0c ("floppy: switch to one queue per drive instead of
> sharing a queue").
> 
> We do "put_disk()" on the disk device _before_ we then clean up the
> queue associated with that disk.
> 
> So maybe this trivial patch is in order?
> 
> Again - UNTESTED. Jens, Vivek?

That survives load/unload 3 times.

Tested-by: Randy Dunlap <randy.dunlap@oracle.com>


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
