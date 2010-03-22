Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0CVAeE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 20:34:04 -0400
Received: from xenotime.net ([72.52.64.118]:59892 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753554Ab0CVAd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 20:33:58 -0400
Message-ID: <4BA6BAF3.10603@xenotime.net>
Date: Sun, 21 Mar 2010 17:33:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-arm-kernel@lists.infradead.org,
       linux-audit@redhat.com, uclinux-dist-devel@blackfin.uclinux.org,
       linux-cris-kernel@axis.com, linux-ia64@vger.kernel.org,
       linux-mips@linux-mips.org, linux-parisc@vger.kernel.org,
       linux-s390@vger.kernel.org, selinux@tycho.nsa.gov,
       sparclinux@vger.kernel.org, x86@kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Cosmetic:Partially remove deprecated __initcall() and
 change to
References: <1269028291-9103-1-git-send-email-justinmattock@gmail.com> <4BA40115.2000509@xenotime.net> <4BA407AC.5030506@gmail.com>
In-Reply-To: <4BA407AC.5030506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/10 16:24, Justin P. Mattock wrote:
> On 03/19/2010 03:56 PM, Randy Dunlap wrote:
>> On 03/19/10 12:51, Justin P. Mattock wrote:
>>> After doing some things on a small issue,
>>> I noticed through web surfing, that there were patches
>>> submitted pertaining that __initcall is deprecated,
>>> and device_initcall should be used.
>>
>> Where was this discussion?  Do you have any pointers to it?
>>
> 
> The best info on this is scripts/checkpatch.pl
> line #2664
> 
> when I found this I just did a quick search of __initcall
> (which gives hits here and there)
> https://patchwork.kernel.org/patch/23344/
> (also found others at around 2008 or so)

Thanks.  IMO there should be something in the kernel source tree
that says explicitly that __initcall is deprecated and should be
replaced by using <whatever should be used>.  That's missing.


>> I don't see any mention of __initcall being deprecated in
>> Linus' mainline git tree, or in linux-next, or in mmotm.
>> Where are those patches?
>>
> 
> I don't know(I'm out of the social pipeline when it comes to Linux news,
> and updates)..
> like in the explanation part of the patch
> I was looking into something else, then ran into this,
> so as a break(from what I was originally doing)
> decided to do this and submit.
> 
>>
>>> So as a change of subject(since what I was looking at
>>> was frustrating me),I decided to grep the whole tree
>>> and make the change(partially).
>>>
>>> Currently I'm running this patch on my system, kernel compiles
>>> without any errors or warnings.(thought there would be a speed increase
>>> but didn't see much(if any)).
>>
>> No, __initcall(x) is just a shorthand version of typing
>> device_initcall(x).  They do the same thing.
>>
> 
> yep, that's what I found out as well(reason for the cosmetic
> in the subject line).
> 
>>> Biggest problem I have though is testing this on other hardware types
>>> (I only have a macbook,and an iMac).
>>> So please if you have the access to other arch/hardware types please
>>> test.
>>>
>>> Now what I mean by partially is the __initcall function is still
>>> there, so(if any) userspace apps/libs depend on this it's there
>>> so they dont break and/or any other subsystem, that needs time
>>> to make the changes.
>>
>> The only thing that might be affected is building out-of-tree drivers,
>> but those are easy to fix.
>>
> 
> alright..main concern is making sure things don't break in the
> kernel(even though things do).
> 
> I can have a go at the header files, submit
> then if it's something people agree they want to do, then they
> can go from there(if not it's fine as well).
> 
>>> Note:
>>> the remaining files that still have __initcall in them are:
>>> (according to grep)
>>>
>>> arch/um/include/shared/init.h
>>> include/linux/init.h
>>> scripts/checkpatch.pl
>>>
>>> either I or somebody else, can change this(although a bit
>>> concerned about breaking things).
>>>
>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>> ---


-- 
~Randy
