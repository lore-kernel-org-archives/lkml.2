Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666Ab1HOKXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:23:18 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:35082 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab1HOKXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:23:16 -0400
X-ASG-Debug-ID: 1313403795-082d21b80001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
Message-ID: <4E48F420.3030101@marvell.com>
Date: Mon, 15 Aug 2011 18:25:36 +0800
From: Leo Yan <leoy@marvell.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Haojian Zhuang <hzhuang1@marvell.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-ASG-Orig-Subj: Re: [PATCH V4 0/3] ARM: mmp: add audio sram support
Subject: Re: [PATCH V4 0/3] ARM: mmp: add audio sram support
References: <1313377794-26721-1-git-send-email-leoy@marvell.com> <1313377893.14434.5.camel@Lily> <CAMPhdO8rkct4H74zXBzaDa183u5vrPArerXgiNXwvQWzZT67Ng@mail.gmail.com> <20110815091245.GC32705@game.jcrosoft.org> <CAMPhdO_StSa9fsYLNjJDd0KDkUyg6ep3gN2n5Gx-WmZ8t=bTFw@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH V4 0/3] ARM: mmp: add audio sram support
In-Reply-To: <CAMPhdO_StSa9fsYLNjJDd0KDkUyg6ep3gN2n5Gx-WmZ8t=bTFw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1313403795
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/15/2011 05:35 PM, Eric Miao wrote:
> On Mon, Aug 15, 2011 at 5:12 PM, Jean-Christophe PLAGNIOL-VILLARD
> <plagnioj@jcrosoft.com>  wrote:
>> On 16:43 Mon 15 Aug     , Eric Miao wrote:
>>> On Mon, Aug 15, 2011 at 11:11 AM, Haojian Zhuang
>>> <haojian.zhuang@marvell.com>  wrote:
>>>> On Sun, 2011-08-14 at 20:09 -0700, Leo Yan wrote:
>>>>> On mmp platform, there have two sram banks:
>>>>> audio sram bank, and internal sram bank for video and PM.
>>>>> So add the sram module to manage these sram banks.
>>>>>
>>>>> And register the sram banks so can dynamically alloc/free
>>>>> the buffer.
>>>>>
>>>>> Leo Yan (3):
>>>>>    ARM: mmp: add sram allocator
>>>>>    ARM: mmp: register audio sram bank
>>>>>    ARM: mmp: register internal sram bank
>>>>>
>>>>>   arch/arm/Kconfig                      |    1 +
>>>>>   arch/arm/mach-mmp/Makefile            |    2 +-
>>>>>   arch/arm/mach-mmp/brownstone.c        |   11 ++
>>>>>   arch/arm/mach-mmp/include/mach/mmp2.h |   13 +++
>>>>>   arch/arm/mach-mmp/include/mach/sram.h |   35 +++++++
>>>>>   arch/arm/mach-mmp/mmp2.c              |    3 +
>>>>>   arch/arm/mach-mmp/sram.c              |  168 +++++++++++++++++++++++++++++++++
>>>>>   7 files changed, 232 insertions(+), 1 deletions(-)
>>>>>   create mode 100644 arch/arm/mach-mmp/include/mach/sram.h
>>>>>   create mode 100644 arch/arm/mach-mmp/sram.c
>>>>>
>>>> Acked-by: Haojian Zhuang<haojian.zhuang@gmail.com>
>>>
>>> Looks good to me. Thanks Haojian. Applied to -devel.
>> I've some reserve on the named pool they need to be managed at generic level
>> not here
>
> What are their names? And your suggestions to fix this?
>

For MMP platform have not only one bank, so now named the audio sram 
bank as "asram", and another sram bank as "isram" which is used by 
video/secure processor/pm.
If other modules want to use the sram, just use the name string to
get the gen pool handler, and then just call genalloc APIs.

I just wander if maintain the name in genalloc, then the name string
we should maintain in the pool's structure or chunk's structure?

>>
>> Best Regards,
>> J.
>>
