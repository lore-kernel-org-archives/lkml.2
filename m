Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab1BVRru (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:47:50 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:29430 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784Ab1BVRrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:47:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAM6CY0120uZw/2dsb2JhbACEIKF2dK1PkFyBJ4NBdgSRaA
Message-ID: <4D63F6C0.7060204@internode.on.net>
Date: Wed, 23 Feb 2011 04:17:44 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-AU; rv:1.9.2.13) Gecko/20101213 Icedove/3.1.7
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Clemens Ladisch <cladisch@googlemail.com>, alsa-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified
 - 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd
 for GFP_ATOMIC order > 0
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net> <4D6367B3.9050306@googlemail.com> <20110222134047.GT13092@random.random> <20110222161513.GC13092@random.random>
In-Reply-To: <20110222161513.GC13092@random.random>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrea Arcangeli wrote, on 23/02/11 02:45:
> On Tue, Feb 22, 2011 at 02:40:47PM +0100, Andrea Arcangeli wrote:
>>   	spin_lock_irq(&zone->lru_lock);
>>   	for (; low_pfn<  end_pfn; low_pfn++) {
>>   		struct page *page;
>> +
>> +		cond_resched();
>> +
>
> my bad, see the above spin_lock_irq oops...
>
> I attached two replacement patches to apply in order (both of them
> should be applied at the same time on top of git upstream, and they
> shouldn't lockup this time).

OK, these patches applied together against upstream didn't cause a crash 
but I did observe:

significant slowdowns of MIDI playback (moreso than in previous cases, 
and with less than 20 Meg of swap file in use);

kswapd0 sharing equal top place in CPU usage at times (e.g. 20 percent).

If I should try only one of the patches or something else entirely, 
please let me know.

Regards,

Arthur.
