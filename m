Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1HOJYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 05:24:10 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:34843 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab1HOJYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 05:24:06 -0400
X-ASG-Debug-ID: 1313400244-082d21a20001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
Message-ID: <4E48E641.6030708@marvell.com>
Date: Mon, 15 Aug 2011 17:26:25 +0800
From: Leo Yan <leoy@marvell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <hzhuang1@marvell.com>
X-ASG-Orig-Subj: Re: [PATCH 1/3] ARM: mmp: add sram allocator
Subject: Re: [PATCH 1/3] ARM: mmp: add sram allocator
References: <1313377794-26721-1-git-send-email-leoy@marvell.com> <1313377794-26721-2-git-send-email-leoy@marvell.com> <1403041.Yj2MdIhcZO@wuerfel>
X-ASG-Orig-Subj: Re: [PATCH 1/3] ARM: mmp: add sram allocator
In-Reply-To: <1403041.Yj2MdIhcZO@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1313400244
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/15/2011 04:59 PM, Arnd Bergmann wrote:
> On Monday 15 August 2011 11:09:52 Leo Yan wrote:
>> On mmp platform, there have two sram banks:
>> audio sram and internal sram. The audio sram is mainly for audio;
>> the internal sram is for video, wtm and power management.
>> So add the sram allocator using genalloc to manage them.
>>
>> Every sram bank will register its own platform device
>> info, after the sram allocator create the generic pool
>> for the sram bank, the user module can use the pool's
>> name to get the pool handler; then it can use the handler
>> to alloc/free memory with genalloc APIs.
>>
>> Signed-off-by: Leo Yan<leoy@marvell.com>
>> ---
>>   arch/arm/Kconfig                      |    1 +
>>   arch/arm/mach-mmp/Makefile            |    2 +-
>>   arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
>>   arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
>>   4 files changed, 205 insertions(+), 1 deletions(-)
>>   create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
>>   create mode 100644 arch/arm/mach-mmp/sram.c
>
> Some time ago, there was talk of merging the existing sram drivers
> and creating a common driver that is easy to hook into.
>
> What has happened with that? My feeling is that we should stop adding
> more drivers like this in the platform code but rather put an
> authoritative copy into arch/arm/mm/ or even the top-level mm/ directory
> and change over the existing drivers to hook into that one.
>
> 	Arnd

I think this is the mail thread for merging sram drivers: Consolidate 
SRAM support;
Here is the latest status for this topic:
http://lists.arm.linux.org.uk/lurker/message/20110710.121939.129161bf.en.html

For JC's genalloc patches has been merged,
in genalloc lib there has maintained the mapping for phys/virt address;
so now just need to create a gen pool, and use this pool handler to 
alloc/free buffer, get the phys address, etc.

My patches has refined the code with the new genalloc APIs.
So you can see now the sram management is pretty simple, just
create the gen pool, then later can directly access genalloc APIs.
