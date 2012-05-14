Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab2ENIv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:51:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47970 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107Ab2ENIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:51:27 -0400
Message-ID: <4FB0C789.6010107@gmail.com>
Date: Mon, 14 May 2012 16:51:21 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: raise MemFree by reverting percpu_pagelist_fraction
 to 0
References: <alpine.LSU.2.00.1205110054520.2801@eggly.anvils> <CA+1xoqcChazS=TRt6-7GjJAzQNFLFXmO623rWwjRkdD5x3k=iw@mail.gmail.com> <4FACD00D.4060003@kernel.org> <4FACD573.4060103@kernel.org> <CA+55aFxsZqU4bXRz61ngnR2ozH=AAhwGHR+PqzdTRfnCxJY0oQ@mail.gmail.com> <CA+1xoqc15HY1rECsJ6Aj1WMzwT12z4DByJhFopyBAiKawEFh3Q@mail.gmail.com>
In-Reply-To: <CA+1xoqc15HY1rECsJ6Aj1WMzwT12z4DByJhFopyBAiKawEFh3Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2012 12:35 AM, Sasha Levin wrote:
> On Fri, May 11, 2012 at 6:27 PM, Linus Torvalds
> <torvalds@linux-foundation.org>  wrote:
>> On Fri, May 11, 2012 at 2:01 AM, Minchan Kim<minchan@kernel.org>  wrote:
>>>
>>> I didn't have a time so made quick patch to show just concept.
>>> Not tested and Not consider carefully.
>>> If anyone doesn't oppose, I will send formal patch which will have more beauty code.
>>
>> What's so magical about that '8' *anyway*? We do we have that minimum at all?
>>
>> At the very least, the 8-vs-0 thing needs to be explained.
>
> The '0' acts as an "off" switch.
>
> Once it's on, we reserve 1/x of the pages for the pagelists. I'm not
> sure why 8 was selected in the first place, but I guess it made sense
> that you don't want to reserve 15%+ of your memory for the pagelists.

1/x is not user-friendly, other vm sysctl's use percentage (x%), for 
example, overcommit_ratio.
