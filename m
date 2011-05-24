Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab1EXXxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:53:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37262 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1EXXxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:53:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDC44F0.6090809@jp.fujitsu.com>
Date: Wed, 25 May 2011 08:53:20 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: mgorman@suse.de
CC: minchan.kim@gmail.com, abarry@cray.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, riel@redhat.com, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org
Subject: Re: Unending loop in __alloc_pages_slowpath following OOM-kill; rfc:
 patch.
References: <4DD2991B.5040707@cray.com> <BANLkTimYEs315jjY9OZsL6--mRq3O_zbDA@mail.gmail.com> <20110520164924.GB2386@barrios-desktop> <4DDB3A1E.6090206@jp.fujitsu.com> <20110524083008.GA5279@suse.de> <4DDB6DF6.2050700@jp.fujitsu.com> <20110524084915.GC5279@suse.de> <4DDB74F7.9020109@jp.fujitsu.com> <20110524091611.GD5279@suse.de> <4DDB7D0F.3060204@jp.fujitsu.com> <20110524105746.GF5279@suse.de>
In-Reply-To: <20110524105746.GF5279@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> In old days, we always call drain_all_pages() if did_some_progress!=0. But
>> current kernel only call it when get_page_from_freelist() fail. So,
>> wait_iff_congested() may help but no guarantee to help us.
>>
>> If you still strongly worry about IPI cost, I'm concern to move drain_all_pages()
>> to more unfrequently point. but to ignore pcp makes less sense, IMHO.
>>
> 
> Yes, I'm worried about it because excessive time
> spent in drain_all_pages() has come up on the past
> http://lkml.org/lkml/2010/8/23/81 . The PCP lists are not being
> ignored at the moment. They are drained when direct reclaim makes
> forward progress but still fails to allocate a page.

Well, it's no priority==0 case. that's my point.


