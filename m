Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2DQCS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 22:18:57 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51519 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2DQCSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 22:18:55 -0400
X-AuditID: 9c93016f-b7c47ae000007299-f1-4f8cd30dcb90
Message-ID: <4F8CD310.4010609@kernel.org>
Date: Tue, 17 Apr 2012 11:18:56 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mmc,gmane.comp.handhelds.android.kernel,gmane.linux.kernel.mm,gmane.linux.kernel
To: Stephan Uphoff <ups@google.com>
CC: Arnd Bergmann <arnd@arndb.de>, linaro-kernel@lists.linaro.org,
        android-kernel@googlegroups.com, linux-mm@kvack.org,
        "Luca Porzio (lporzio)" <lporzio@micron.com>,
        Alex Lemberg <alex.lemberg@sandisk.com>, linux-kernel@vger.kernel.org,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: swap on eMMC and other flash
References: <201203301744.16762.arnd@arndb.de> <201204111557.14153.arnd@arndb.de> <CAKL-ytsXbe4=u94PjqvhZo=ZLiChQ0FmZC84GNrFHa0N1mDjFw@mail.gmail.com> <201204161859.32436.arnd@arndb.de> <CAKL-ytvC3dw6p=R1G3GOCst_6B=uOqRK2kWOH9jso_=bgtNOXA@mail.gmail.com>
In-Reply-To: <CAKL-ytvC3dw6p=R1G3GOCst_6B=uOqRK2kWOH9jso_=bgtNOXA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 06:12 AM, Stephan Uphoff wrote:
> Hi Arnd,
>
> On Mon, Apr 16, 2012 at 12:59 PM, Arnd Bergmann<arnd@arndb.de>  wrote:
>> On Monday 16 April 2012, Stephan Uphoff wrote:
>>> opportunity to plant a few ideas.
>>>
>>> In contrast to rotational disks read/write operation overhead and
>>> costs are not symmetric.
>>> While random reads are much faster on flash - the number of write
>>> operations is limited by wearout and garbage collection overhead.
>>> To further improve swapping on eMMC or similar flash media I believe
>>> that the following issues need to be addressed:
>>>
>>> 1) Limit average write bandwidth to eMMC to a configurable level to
>>> guarantee a minimum device lifetime
>>> 2) Aim for a low write amplification factor to maximize useable write bandwidth
>>> 3) Strongly favor read over write operations
>>>
>>> Lowering write amplification (2) has been discussed in this email
>>> thread - and the only observation I would like to add is that
>>> over-provisioning the internal swap space compared to the exported
>>> swap space significantly can guarantee a lower write amplification
>>> factor with the indirection and GC techniques discussed.
>>
>> Yes, good point.
>>
>>> I believe the swap functionality is currently optimized for storage
>>> media where read and write costs are nearly identical.
>>> As this is not the case on flash I propose splitting the anonymous
>>> inactive queue (at least conceptually) - keeping clean anonymous pages
>>> with swap slots on a separate queue as the cost of swapping them
>>> out/in is only an inexpensive read operation. A variable similar to
>>> swapiness (or a more dynamic algorithmn) could determine the
>>> preference for swapping out clean pages or dirty pages. ( A similar
>>> argument could be made for splitting up the file inactive queue )
>>
>> I'm not sure I understand yet how this would be different from swappiness.
>
> As I see it swappiness determines the ratio for paging out file backed
> as compared to anonymous, swap backed pages.
> I would like to further be able to set the ratio for throwing away
> clean anonymous pages with swap slots ( that are easy to read back in)
> as compared to writing out dirty anonymous pages to swap.

We can apply the rule in file-lru list too and we already have 
ISOLATE_CLEAN mode to select victim pages in LRU list so it should work.

For selecting clean anon pages with swap slot, we need more looking.
Recent, Dan had a question about it and Hugh answered it.
Look at the http://marc.info/?l=linux-mm&m=133462346928786&w=2

-- 
Kind regards,
Minchan Kim
