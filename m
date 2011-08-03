Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab1HCJCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 05:02:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51214 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab1HCJCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 05:02:38 -0400
Message-ID: <4E390EBA.7060507@cn.fujitsu.com>
Date: Wed, 03 Aug 2011 17:02:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Xiaotian Feng <xtfeng@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel BUG at mm/vmscan.c:1114
References: <CAJn8CcE20-co4xNOD8c+0jMeABrc1mjmGzju3xT34QwHHHFsUA@mail.gmail.com> <CAJn8CcG-pNbg88+HLB=tRr26_R+A0RxZEWsJQg4iGe4eY2noXA@mail.gmail.com> <20110802002226.3ff0b342.akpm@linux-foundation.org> <CAJn8CcGTwhAaqghqWOYN9mGvRZDzyd9UJbYARz7NGA-7NvFg9Q@mail.gmail.com> <20110803085437.GB19099@suse.de>
In-Reply-To: <20110803085437.GB19099@suse.de>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 17:01:37,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-03 17:01:38,
	Serialize complete at 2011-08-03 17:01:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

16:54, Mel Gorman wrote:
> On Wed, Aug 03, 2011 at 02:44:20PM +0800, Xiaotian Feng wrote:
>> On Tue, Aug 2, 2011 at 3:22 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> On Tue, 2 Aug 2011 15:09:57 +0800 Xiaotian Feng <xtfeng@gmail.com> wrote:
>>>
>>>> __ __I'm hitting the kernel BUG at mm/vmscan.c:1114 twice, each time I
>>>> was trying to build my kernel. The photo of crash screen and my config
>>>> is attached.
>>>
>>> hm, now why has that started happening?
>>>
>>> Perhaps you could apply this debug patch, see if we can narrow it down?
>>>
>>
>> I will try it then, but it isn't very reproducible :(
>> But my system hung after some list corruption warnings... I hit the
>> corruption 4 times...
>>
> 
> That is very unexpected but if lists are being corrupted, it could
> explain the previously reported bug as that bug looked like an active
> page on an inactive list.
> 
> What was the last working kernel? Can you bisect?
> 

I just triggered the same BUG_ON() while running xfstests to test btrfs,
but I forgot to remember which test case was running when it happaned,
case 134 or around.

--
Li Zefan
