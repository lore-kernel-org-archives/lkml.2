Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1BJBRG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 20:17:06 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63401 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1BJBRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 20:17:05 -0500
Message-ID: <4D533CB5.6060807@vflare.org>
Date: Wed, 09 Feb 2011 20:17:41 -0500
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>, gregkh@suse.de,
        Chris Mason <chris.mason@oracle.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, matthew@wil.cx,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au,
        wfg@mail.ustc.edu.cn, tytso@mit.edu, viro@zeniv.linux.org.uk,
        hughd@google.com, hannes@cmpxchg.org
Subject: Re: [PATCH V2 2/3] drivers/staging: zcache: host services and PAM
 services
References: <AANLkTi=CEXiOdqPZgQZmQwatHqZ_nsnmnVhwpdt=7q3f@mail.gmail.com>	<5c529b08-cf36-43c7-b368-f3f602faf358@default>	<4D52D091.1000504@vflare.org> <AANLkTimuivx6kroZ0v0J8GZQmBngHHDTfztGamnp2UJk@mail.gmail.com>
In-Reply-To: <AANLkTimuivx6kroZ0v0J8GZQmBngHHDTfztGamnp2UJk@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 06:46 PM, Minchan Kim wrote:
> Hi Nitin,
>
> Sorry for late response.
>
> On Thu, Feb 10, 2011 at 2:36 AM, Nitin Gupta<ngupta@vflare.org>  wrote:
>> On 02/09/2011 11:39 AM, Dan Magenheimer wrote:
>>>
>>>
>>>> From: Minchan Kim [mailto:minchan.kim@gmail.com]
>>>
>>>> As I read your comment, I can't find the benefit of zram compared to
>>>> frontswap.
>>>
>>> Well, I am biased, but I agree that frontswap is a better technical
>>> solution than zram. ;-)  But "dynamic-ity" is very important to
>>> me and may be less important to others.
>>>
>>
>>
>> I agree that frontswap is better than zram when considering swap as the use
>> case - no bio overhead, dynamic resizing. However, zram being a *generic*
>> block-device has some unique cases too like hosting files on /tmp, various
>> caches under /var or any place where a compressed in-memory block device can
>> help.
>
> Yes. I mentioned that benefit but I am not sure the reason is enough.
> What I had in mind long time ago is that zram's functionality into brd.
> So someone who want to compress contents could use it with some mount
> option to enable compression.
> By such way, many ramdisk user can turn it on easily.
> If many user begin using the brd, we can see many report about
> performance then solve brd performance s as well as zcache world-wide
> usage.
>
> Hmm,  the idea is too late?
>
>>
>> So, frontswap and zram have overlapping use case of swap but are not the
>> same.
>
> If we can insert zram's functionality into brd, maybe there is no
> reason to coexist.
>
>
>>

I thought about this before starting with zram development but thought 
adding compression (and in future, defrag) and use of custom allocator 
is just too much of a hassle and thus dropped the idea. If someone is 
anyhow interested in merging brd and zram I would be glad to help but I 
still think that is simply not worth the effort.

Thanks,
Nitin
