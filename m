Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070Ab1BRBPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 20:15:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62732 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab1BRBO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 20:14:58 -0500
Message-ID: <4D5DC805.1020302@cn.fujitsu.com>
Date: Fri, 18 Feb 2011 09:14:45 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 5/6 v4] cfq-iosched: CFQ group hierarchical scheduling
 and use_hierarchy interface
References: <4D51ED26.8050809@cn.fujitsu.com> <4D539821.1090703@cn.fujitsu.com> <AANLkTi=L5gingbYVDZfuDdkCyUKXNhjz8zFg4FLBN+7L@mail.gmail.com> <4D5C782C.4050201@cn.fujitsu.com> <AANLkTikFDUVNsHUTy62rFXCbnN9MHX1875-aL3WFMvyb@mail.gmail.com>
In-Reply-To: <AANLkTikFDUVNsHUTy62rFXCbnN9MHX1875-aL3WFMvyb@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-18 09:13:56,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-18 09:14:00,
	Serialize complete at 2011-02-18 09:14:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin TerAvest wrote:
> On Wed, Feb 16, 2011 at 5:21 PM, Gui Jianfeng
> <guijianfeng@cn.fujitsu.com> wrote:
>> Justin TerAvest wrote:
>>> After a quick read,
>>>
>>> It's sad that we have to have so many use_hierarchy checks; it seems
>>> like we're asking for bugs, especially in the future when one codepath
>>> gets updated but not the other.
>>>
>>> CodingStyle says we should only have one declaration per line.
>>>
>>> I feel like there is an implicit assumption that groups and tasks
>>> should not be children of the same parent; that is, a group should
>>> contain only groups, or only tasks, but I don't see this enforced;
>>> there's just and assumption that BE:SYNC is "good enough" for that
>>> comparison. This smells like something that will be tweaked/tuned for
>>> fairness later. :( Why don't we just prevent this from happening?
>> Hi Justin,
>>
>> Thanks for reviewing.
>>
>> Previously, I posted very first version that makes a group containing only
>> groups or only tasks. But I think it's more flexible to treat groups and
>> tasks at the same level. I think Vivek and Jens have the same opinion.
>> We had discussed in this thread http://lkml.org/lkml/2010/8/30/30
> 
> Hi Gui,
> Thanks for pointing me at the earlier discussion, the decisions make a
> lot more sense now.
> 
>>> The clean_up label in chain_alloc() is strange; I don't think the goto
>>> is necessary at all. I found that method generally hard to understand.
>>> It's doing a lot.
>> I don't understand why clean_up isn't needed.
>> When we fail to allocate a cfq group at some level, we have to clean up
>> all groups in the chain that we have already allocated.
> 
> Cleaning up is necessary, but the label is only used from one place.
> Why add the goto and the label when the code below "clean_up" can just
> be moved inside the condition
> +                       if (!cfqg)

It's common in kernel to put error processing at the end of a function. ;)

Thanks,
Gui

