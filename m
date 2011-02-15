Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab1BODN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 22:13:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58991 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751192Ab1BODNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 22:13:55 -0500
Message-ID: <4D59EF6C.2090303@cn.fujitsu.com>
Date: Tue, 15 Feb 2011 11:13:48 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Chad Talbott <ctalbott@google.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 0/6 v4] cfq-iosched: Introduce CFQ group hierarchical
 scheduling and "use_hierarchy" interface
References: <4D5397A9.6040404@cn.fujitsu.com> <20110210183053.GD2524@redhat.com> <4D5623F6.7020101@cn.fujitsu.com> <20110214180612.GG13097@redhat.com>
In-Reply-To: <20110214180612.GG13097@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-15 11:12:58,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-15 11:12:58,
	Serialize complete at 2011-02-15 11:12:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Sat, Feb 12, 2011 at 02:08:54PM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> On Thu, Feb 10, 2011 at 03:45:45PM +0800, Gui Jianfeng wrote:
>>>> Hi
>>>>
>>>> Previously, I posted a patchset to add support of CFQ group hierarchical scheduling
>>>> in the way that it puts all CFQ queues in a hidden group and schedules with other 
>>>> CFQ group under their parent. The patchset is available here,
>>>> http://lkml.org/lkml/2010/8/30/30
>>>>
>>>> Vivek think this approach isn't so instinct that we should treat CFQ queues
>>>> and groups at the same level. Here is the new approach for hierarchical 
>>>> scheduling based on Vivek's suggestion. The most big change of CFQ is that
>>>> it gets rid of cfq_slice_offset logic, and makes use of vdisktime for CFQ
>>>> queue scheduling just like CFQ group does. But I still give cfqq some jump 
>>>> in vdisktime based on ioprio, thanks for Vivek to point out this. Now CFQ 
>>>> queue and CFQ group use the same scheduling algorithm. 
>>>>
>>>> "use_hierarchy" interface is now added to switch between hierarchical mode
>>>> and flat mode. It works as memcg.
>>>>
>>>> --
>>>> V3 -> V4 Changes:
>>>> - Take io class into account when calculating the boost value.
>>>> - Refine the vtime boosting logic as Vivek's Suggestion.
>>> Hi Gui,
>>>
>>> What testing did you do to make sure that this vtime boosting logic is working
>>> and is good replacement for slice_offset() logic for cfqq?
>>>
>>> Secondly, did you get a chance to look at chad's patch of keeping track
>>> of previous assigned vdisktime and keeping track of genrations. I think
>>> his patch is going to coflict with yours, so one of you will have to
>>> make adjustments. I think both the boost logic and keeping track of generation
>>> logic can be combined.
>> Hi Vivek,
>>
>> For the time being, boosting logic only works for cfq queue, and keepinging track of
>> generation works for cfq group.
>> I think when we introduce boosting logic for cfq group, we can combine these two logic
>> together.
> 
> Ok, I am assuming that now you are introducing another patch in the series
> to get boosting logic working for groups also.
> 
> Also, it might be easier to test it with group_idle=0, as right now groups
> don't preempt each other.

Vivek,

If you don't object, I'd like to introduce this in a seperate patch when this series
gets merged. For I don't want to add more complexity for this seires. ;) 
I'll post v5.

Thanks,
Gui

> 
> Thanks
> Vivek
> 
