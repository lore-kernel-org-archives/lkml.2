Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab2GLGNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 02:13:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41436 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2GLGNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 02:13:19 -0400
Message-ID: <4FFE6AF1.8010802@gmail.com>
Date: Thu, 12 Jul 2012 14:13:05 +0800
From: Liu Yuan <namei.unix@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
CC: hanwen@xs4all.nl, Han-Wen Nienhuys <hanwenn@gmail.com>,
        fuse-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [fuse-devel] [RFC PATCH 0/5] fuse: make maximum read/write request
 size tunable
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp> <4FF67D6A.8060707@gmail.com> <CAOw_e7ZGdSVrNfPe8iE8BtmNWU+BrvbaMFVsUP+g+3MR0Pegqw@mail.gmail.com> <4FFE6785.80201@hitachi.com>
In-Reply-To: <4FFE6785.80201@hitachi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 01:58 PM, HAYASAKA Mitsuo wrote:
> Hi Yuan and Han-Wen,
> 
> Thank you for your comments.
> 
> (2012/07/06 22:58), Han-Wen Nienhuys wrote:
>> On Fri, Jul 6, 2012 at 2:53 AM, Liu Yuan<namei.unix@gmail.com>  wrote:
>>> On 07/05/2012 06:50 PM, Mitsuo Hayasaka wrote:
>>>> One of the ways to solve this is to make them tunable.
>>>> In this series, the new sysfs parameter max_pages_per_req is
>>>> introduced.
>>>> It limits the maximum read/write size in fuse request and it can be
>>>> changed from 32 to 256 pages in current implementations. When the
>>>> max_read/max_write mount option is specified, FUSE request size is set
>>>> per mount. (The size is rounded-up to page size and limited up to
>>>> max_pages_per_req.)
>>>
>>> Why maxim 256 pages? If we are here, we can go further: most of object
>>> storage system has object size of multiple to dozens of megabytes. So I
>>> think probably 1M is too small. Our distribution storage system has 4M
>>> per object, so I think at least maxim size could be bigger than 4M.
>>
>> The maximum pipe size on my system is 1M, so if you go beyond that,
>> splicing from the FD won't work.
>>
>> Also, the userspace client must reserve a buffer this size so it can
>> receive a write, which is a waste since most requests are much
>> smaller.
>>
> 
> I checked the maximum pipe size can be changed using fcntl(2) or
> /proc/sys/fs/pipe-max-size. It is clear that it is not a fixed value.
> 
> Also, it seems that there is a request for setting the maximum number
> of pages per fuse request to 4M (1024 pages). One of the reasons to
> introduce the sysfs max_pages_per_req parameter is to set a threshold
> of the maximum number of pages dynamically according to the
> administrator's demand, and root can only change it.
> 
> So, when the maximum value is required to be set to not more than the
> pipe-max-size, the max_pages_per_req should be changed considering it.
> It seems that the upper limit of this parameter does not have to be
> not more than it.
> 
> I'm planning to limit max_pages_per_req up to 1024 pages and add the
> document to /Documentation/filesystems/fuse.txt, as follows.
> 
> "the sysfs max_pages_per_req parameter can be changed from 32 to 1024.
> The default is 32 pages. Generally, the pipe-max-size is 1M (256 pages)
> and it is better to set it to not more than the pipe-max-size."
> 
> This is just a plan and any comments are appreciated.

This looks reasonable to me, we should try our best to maximize the
upper ceiling to deal with various of kinds of demands.

Thanks for your work, Mitsuo, as a user of FUSE, I'd vote +1 for your
patch set.

Thanks,
Yuan
