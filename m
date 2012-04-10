Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab2DJBHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:07:53 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58480 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab2DJBHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:07:52 -0400
X-AuditID: 9c930179-b7b2cae000000ca1-6e-4f8387e5bd0c
Message-ID: <4F838870.9030407@kernel.org>
Date: Tue, 10 Apr 2012 10:10:08 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel.mmc,gmane.linux.kernel,gmane.linux.kernel.mm
To: Arnd Bergmann <arnd@arndb.de>
CC: =?UTF-8?B?7KCV7Zqo7KeE?= <syr.jeong@samsung.com>,
        "'Alex Lemberg'" <Alex.Lemberg@sandisk.com>,
        linaro-kernel@lists.linaro.org, "'Rik van Riel'" <riel@redhat.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Luca Porzio (lporzio)'" <lporzio@micron.com>, linux-mm@kvack.org,
        kernel-team@android.com, "'Yejin Moon'" <yejin.moon@samsung.com>,
        "'Hugh Dickins'" <hughd@google.com>,
        "'Yaniv Iarovici'" <Yaniv.Iarovici@sandisk.com>, cpgs@samsung.com
Subject: Re: swap on eMMC and other flash
References: <201203301744.16762.arnd@arndb.de> <006f01cd1623$ac4a2860$04de7920$%jeong@samsung.com> <4F8299B4.5090909@kernel.org> <201204091300.34304.arnd@arndb.de>
In-Reply-To: <201204091300.34304.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-04-09 오후 10:00, Arnd Bergmann 쓴 글:

> On Monday 09 April 2012, Minchan Kim wrote:
>>>
>>> Regarding swap page size:
>>> Actually, I can't guarantee the optimal size of different eMMC in the industry, because it depends on NAND page size an firmware implementation inside eMMC. In case of SAMSUNG eMMC, 8KB page size and 512KB block size(erase unit) is current implementation.
>>> I think that the multiple of 8KB page size align with 512KB is good for SAMSUNG eMMC.
>>> If swap system use 512KB page and issue Discard/Trim align with 512KB, eMMC make best performance as of today. However, large page size in swap partition may not best way in Linux system level.
>>> I'm not sure that the best page size between Swap system and eMMC device.
>>
>>
>> The variety is one of challenges for removing GC generally. ;-(.
>> I don't like manual setting through /sys/block/xxx because it requires
>> that user have to know nand page size and erase block size but it's not
>> easy to know to normal user.
>> Arnd. What's your plan to support various flash storages effectively?
> 
> My preference would be to build the logic to detect the sizes into mkfs
> and mkswap and encode them in the superblock in new fields. I don't think
> we can trust any data that a device reports right now because operating
> systems have ignored it in the past and either someone has forgotten to
> update the fields after moving to new technology (eMMC), or the data can
> not be encoded correctly according to the spec (SD, USB).


I think it's not good approach.
How long does it take to know such parameters?
I guess it's not short so that mkfs/mkswap would be very long
dramatically. If needed, let's maintain it as another tool.

If storage vendors break such fields, it doesn't work well on linux
which is very popular on mobile world today and user will not use such
vendor devices and company will be gone. Let's give such pressure to
them and make vendor keep in promise.


> 
> System builders for embedded systems can then make sure that they get
> it right for the hardware they use, and we can try our best to help
> that process.




> 
> 	Ard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



-- 
Kind regards,
Minchan Kim
