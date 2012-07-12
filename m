Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2GLF65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:58:57 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:53637 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab2GLF6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:58:55 -0400
X-AuditID: b753bd60-a3089ba000000655-7f-4ffe679cc5c8
X-AuditID: b753bd60-a3089ba000000655-7f-4ffe679cc5c8
Message-ID: <4FFE6785.80201@hitachi.com>
Date: Thu, 12 Jul 2012 14:58:29 +0900
From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: hanwen@xs4all.nl, Han-Wen Nienhuys <hanwenn@gmail.com>,
        Liu Yuan <namei.unix@gmail.com>
Cc: fuse-devel@lists.sourceforge.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [fuse-devel] [RFC PATCH 0/5] fuse: make maximum read/write request
 size tunable
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp> <4FF67D6A.8060707@gmail.com> <CAOw_e7ZGdSVrNfPe8iE8BtmNWU+BrvbaMFVsUP+g+3MR0Pegqw@mail.gmail.com>
In-Reply-To: <CAOw_e7ZGdSVrNfPe8iE8BtmNWU+BrvbaMFVsUP+g+3MR0Pegqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yuan and Han-Wen,

Thank you for your comments.

(2012/07/06 22:58), Han-Wen Nienhuys wrote:
> On Fri, Jul 6, 2012 at 2:53 AM, Liu Yuan<namei.unix@gmail.com>  wrote:
>> On 07/05/2012 06:50 PM, Mitsuo Hayasaka wrote:
>>> One of the ways to solve this is to make them tunable.
>>> In this series, the new sysfs parameter max_pages_per_req is introduced.
>>> It limits the maximum read/write size in fuse request and it can be
>>> changed from 32 to 256 pages in current implementations. When the
>>> max_read/max_write mount option is specified, FUSE request size is set
>>> per mount. (The size is rounded-up to page size and limited up to
>>> max_pages_per_req.)
>>
>> Why maxim 256 pages? If we are here, we can go further: most of object
>> storage system has object size of multiple to dozens of megabytes. So I
>> think probably 1M is too small. Our distribution storage system has 4M
>> per object, so I think at least maxim size could be bigger than 4M.
>
> The maximum pipe size on my system is 1M, so if you go beyond that,
> splicing from the FD won't work.
>
> Also, the userspace client must reserve a buffer this size so it can
> receive a write, which is a waste since most requests are much
> smaller.
>

I checked the maximum pipe size can be changed using fcntl(2) or
/proc/sys/fs/pipe-max-size. It is clear that it is not a fixed value.

Also, it seems that there is a request for setting the maximum number
of pages per fuse request to 4M (1024 pages). One of the reasons to
introduce the sysfs max_pages_per_req parameter is to set a threshold
of the maximum number of pages dynamically according to the
administrator's demand, and root can only change it.

So, when the maximum value is required to be set to not more than the
pipe-max-size, the max_pages_per_req should be changed considering it.
It seems that the upper limit of this parameter does not have to be
not more than it.

I'm planning to limit max_pages_per_req up to 1024 pages and add the
document to /Documentation/filesystems/fuse.txt, as follows.

"the sysfs max_pages_per_req parameter can be changed from 32 to 1024.
The default is 32 pages. Generally, the pipe-max-size is 1M (256 pages)
and it is better to set it to not more than the pipe-max-size."

This is just a plan and any comments are appreciated.

Thanks,
