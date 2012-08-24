Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820Ab2HXCV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:21:26 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:59069 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2HXCVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:21:19 -0400
Message-ID: <5036E514.1090509@linux.vnet.ibm.com>
Date: Fri, 24 Aug 2012 10:21:08 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/2] revert changes to zcache_do_preload()
References: <1345735991-6995-1-git-send-email-sjenning@linux.vnet.ibm.com> <20120823205648.GA2066@barrios> <5036AA38.6010400@linux.vnet.ibm.com> <20120823232845.GE5369@bbox>
In-Reply-To: <20120823232845.GE5369@bbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12082402-2000-0000-0000-000008D3DF2A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2012 07:28 AM, Minchan Kim wrote:
> On Thu, Aug 23, 2012 at 05:10:00PM -0500, Seth Jennings wrote:
>> On 08/23/2012 03:56 PM, Minchan Kim wrote:
>>> Hi Seth,
>>>
>>> On Thu, Aug 23, 2012 at 10:33:09AM -0500, Seth Jennings wrote:
>>>> This patchset fixes a regression in 3.6 by reverting two dependent
>>>> commits that made changes to zcache_do_preload().
>>>>
>>>> The commits undermine an assumption made by tmem_put() in
>>>> the cleancache path that preemption is disabled.  This change
>>>> introduces a race condition that can result in the wrong page
>>>> being returned by tmem_get(), causing assorted errors (segfaults,
>>>> apparent file corruption, etc) in userspace.
>>>>
>>>> The corruption was discussed in this thread:
>>>> https://lkml.org/lkml/2012/8/17/494
>>>
>>> I think changelog isn't enough to explain what's the race.
>>> Could you write it down in detail?
>>
>> I didn't come upon this solution via code inspection, but
>> rather through discovering that the issue didn't exist in
>> v3.5 and just looking at the changes since then.
> 
> Okay, then, why do you think the patchsets are culprit?
> I didn't look the cleanup patch series of Xiao at that time
> so I can be wrong but as I just look through patch of
> "zcache: optimize zcache_do_preload", I can't find any fault
> because zcache_put_page checks irq_disable so we don't need
> to disable preemption so it seems that patch is correct to me.
> If the race happens by preemption, BUG_ON in zcache_put_page
> should catch it.

Confused me too!

And the first patch just do the cleanup, it is not different
before the patch and after the patch, what i missed?

