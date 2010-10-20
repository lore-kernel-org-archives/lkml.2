Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0JTVmd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:42:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41080 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0JTVmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:42:32 -0400
Message-ID: <4CBF6234.9090402@zytor.com>
Date: Wed, 20 Oct 2010 14:42:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [PATCH 1/2]percpu: introduce read mostly percpu API
References: <1287544022.4571.7.camel@sli10-conroe.sh.intel.com>	 <1287551880.2700.79.camel@edumazet-laptop>	 <20101020073511.GC20124@basil.fritz.box> <1287561234.2328.1.camel@edumazet-laptop> <4CBF616E.1080501@zytor.com>
In-Reply-To: <4CBF616E.1080501@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 02:38 PM, H. Peter Anvin wrote:
> On 10/20/2010 12:53 AM, Eric Dumazet wrote:
>>
>> My question was more a rethoric one. I understand for sure the intent.
>>
>> All this should be explained in changelog, so that people know
>> when/where use this new class of per_cpu variables ;)
>>
> 
> Changelog really isn't the best place for this, a Documentation file
> would be better.
> 
> I'm trying to grok the intended semantic of the shared_aligned section
> right now... I'm not sure if there is a significant difference between
> the read mostly and the shared aligned section?
> 

>From the looks of it, it's a manual way to do what the linker would,
quite frankly, do better with SORT_BY_ALIGNMENT() -- although by
separating it out it might still be a win to avoid lots of "N+1"-sized
sections aligned to N.

	-hpa

