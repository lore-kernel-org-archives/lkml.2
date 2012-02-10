Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766Ab2BJSXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:23:07 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41057 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759724Ab2BJSXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:23:04 -0500
Message-ID: <4F356055.2000203@linux.vnet.ibm.com>
Date: Fri, 10 Feb 2012 12:22:13 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: Re: linux-next: build failure after merge of the staging tree
References: <20120210155800.ccef418fd5c2f2b87a5d6315@canb.auug.org.au> <20120210052947.GA2068@kroah.com> <80f07411-179e-4fe9-b591-32fbcaac414b@default> <20120210174359.GB5128@kroah.com>
In-Reply-To: <20120210174359.GB5128@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021018-9360-0000-0000-0000035B8A16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2012 11:43 AM, Greg KH wrote:
> On Fri, Feb 10, 2012 at 09:21:46AM -0800, Dan Magenheimer wrote:
>>> From: Greg KH [mailto:greg@kroah.com]
>>> Subject: Re: linux-next: build failure after merge of the staging tree
>>>
>>> On Fri, Feb 10, 2012 at 03:58:00PM +1100, Stephen Rothwell wrote:
>>>> Hi Greg,
>>>>
>>>> After merging the staging tree, today's linux-next build (x86_64
>>>> allmodconfig) failed like this:
>>>>
>>>> drivers/staging/ramster/ramster_o2net.c: In function 'ramster_remote_async_get_request_handler':
>>>> drivers/staging/ramster/ramster_o2net.c:91:2: error: implicit declaration of function
>>> 'o2net_force_data_magic' [-Werror=implicit-function-declaration]
>>>> drivers/staging/ramster/ramster_o2net.c: In function 'ramster_remote_put':
>>>> drivers/staging/ramster/ramster_o2net.c:250:2: error: implicit declaration of function
>>> 'o2net_nn_from_num' [-Werror=implicit-function-declaration]
>>>> drivers/staging/ramster/zcache-main.c:40:64: fatal error: ../zram/xvmalloc.h: No such file or
>>> directory
>>>>
>>>> Caused by commits ba351b02ab11 ("staging: ramster: local compression +
>>>> tmem") and 14a3cd58dd4f ("staging: ramster: ramster-specific new files").
>>>>
>>>> I have used the version of the staging tree from next-20120209 for today.
>>>
>>> Ugh, I wonder why it builds here, very odd.
>>>
>>> Dan, care to send me a patch to fix this?
>>
>>>> drivers/staging/ramster/zcache-main.c:40:64: fatal error: ../zram/xvmalloc.h: No such
>>
>> Hmmm... it appears that Seth's zsmalloc patch for drivers/staging/zcache
>> removed xvmalloc.[ch] from drivers/staging/zram while drivers/staging/ramster
>> is still depending on it. :-(  I hadn't planned for both ramster
>> and zsmalloc-replacing-xvmalloc to be merged at the same time... I guess
>> this is exactly the kind of problem linux-next is designed to wring out!
>>
>> Greg, FOR NOW, PLEASE JUST REVERT the ramster patchset from staging-next.
>> I am working on a v5 anyway and will roll in a copy of the xvmalloc.[ch]
>> code into it for now and, since Seth's patch should be in linux-next
>> by the time I am done (hopefully next week), I can test build ramster v5
>> with linux-next to ensure all the above problems are resolved before
>> resubmitting.
>>
>> (Seth, I could also switch ramster v5 to depend on zsmalloc instead of
>> xvmalloc, but since I've done all my ramster testing on xvmalloc,
>> I think I would prefer to make that transition later.)
>>
>> Sorry, Stephen and Greg, for the hassle!
> 
> Ok, now reverted, what a mess...

Sounds like the ramster has been reverted already, but the removal
of xvmalloc was done in its own commit (from staging-next):

b154ff05e1b0d749231a71896c90e38657f8e675 staging: zram: remove xvmalloc

If you revert just this commit, that should restore the xvmalloc files.

Of course this doesn't resolve the "implicit declaration of function"
errors.

--
Seth

