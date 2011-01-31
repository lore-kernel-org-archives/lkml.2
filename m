Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1AaTYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 14:24:05 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48475 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab1AaTYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 14:24:03 -0500
Message-ID: <4D470C50.6010701@kernel.dk>
Date: Mon, 31 Jan 2011 20:24:00 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] blkio-throttle: Avoid calling blkiocg_lookup_group()
 for root group
References: <20110117215606.GI5624@redhat.com>	<20110126185729.GD6713@redhat.com> <x49ei7sq3qe.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ei7sq3qe.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-01-31 20:20, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
>> On Mon, Jan 17, 2011 at 04:56:06PM -0500, Vivek Goyal wrote:
>>> o Jeff Moyer was doing some testing on a RAM backed disk and
>>>   blkiocg_lookup_group() showed up high overhead after memcpy(). Similarly
>>>   somebody else reported that blkiocg_lookup_group() is eating 6% extra
>>>   cpu. Though looking at the code I can't think why the overhead of
>>>   this function is so high. One thing is that it is called with very high
>>>   frequency (once for every IO).
>>>
>>> o For lot of folks blkio controller will be compiled in but they might
>>>   not have actually created cgroups. Hence optimize the case of root
>>>   cgroup where we can avoid calling blkiocg_lookup_group() if IO is happening
>>>   in root group (common case).
>>>
>>> Reported-by: Jeff Moyer <jmoyer@redhat.com>
>>> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>
>> Hi Jens,
>>
>> Do you have any concerns regarding this patch?
> 
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> 
> Jens, this is a pretty easy performance regression fixup.  I think it
> should be pulled in sooner rather than later.  We've also witnessed this
> slowdown on big performance testing rigs, so it's not just a ramdisk
> issue.

Yep, will fold it into 2.6.38, thanks!


-- 
Jens Axboe

