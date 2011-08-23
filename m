Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1HWTP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:15:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18320 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533Ab1HWTPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:15:52 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6447"; a="112381901"
Message-ID: <4E53FC67.7090108@codeaurora.org>
Date: Tue, 23 Aug 2011 12:15:51 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nohz: remove "Switched to NOHz mode" debugging messages
References: <20110823112046.GB2540@osiris.boeblingen.de.ibm.com> <1314126777.1659.2.camel@Joe-Laptop>
In-Reply-To: <1314126777.1659.2.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2011 12:12 PM, Joe Perches wrote:
> On Tue, 2011-08-23 at 13:20 +0200, Heiko Carstens wrote:
>> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>>
>> When performing cpu hotplug tests the kernel printk log buffer gets flooded
>> with pointless "Switched to NOHz mode..." messages. Especially when afterwards
>> analyzing a dump this might have removed more interesting stuff out of the
>> buffer.
>> Assuming that switching to NOHz mode simply works just remove the printk.
>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> []
>> -
>> -	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
> Though I don't know if these are actually particularly
> useful messages, perhaps pr_info_ratelimited() might
> be appropriate instead.

Or perhaps a printk_once() would be good. Presumably the second switch
to NOHz mode wouldn't be as dangerous as the first.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

