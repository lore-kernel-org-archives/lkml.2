Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab2HBEmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 00:42:11 -0400
Received: from mail1.windriver.com ([147.11.146.13]:39114 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2HBEmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 00:42:10 -0400
Message-ID: <501A05D7.5060005@windriver.com>
Date: Thu, 2 Aug 2012 12:45:11 +0800
From: Fan Du <fan.du@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kevin Cernekee <cernekee@gmail.com>
CC: Fan Du <fdu@windriver.com>, <ralf@linux-mips.org>,
        <linux-mips@linux-mips.org>, <linux-kernel@vger.kernel.org>,
        vincent wen <vincentwenlinux@gmail.com>
Subject: Re: [PATCH] MIPS: oops when show backtrace of all active cpu
References: <1343878276-4108-1-git-send-email-fdu@windriver.com> <CAJiQ=7Abc2sR2E2FXmeTr_Hc+CWH+J25=juB3wL172Tn6-PYuA@mail.gmail.com>
In-Reply-To: <CAJiQ=7Abc2sR2E2FXmeTr_Hc+CWH+J25=juB3wL172Tn6-PYuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.162.155]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2012年08月02日 12:18, Kevin Cernekee wrote:
> On Wed, Aug 1, 2012 at 8:31 PM, Fan Du<fdu@windriver.com>  wrote:
>> show_backtrace must have an valid task when calling unwind_stack,
>> so fix it by checking first.
> [...]
>> --- a/arch/mips/kernel/traps.c
>> +++ b/arch/mips/kernel/traps.c
>> @@ -151,6 +151,10 @@ static void show_backtrace(struct task_struct *task, const struct pt_regs *regs)
>>                  show_raw_backtrace(sp);
>>                  return;
>>          }
>> +
>> +       if (task == NULL)
>> +               task = current;
>> +
>>          printk("Call Trace:\n");
>>          do {
>>                  print_ip_sym(pc);
>
> FYI, a slightly different version of this change was accepted:
>
> https://patchwork.linux-mips.org/patch/3524/
>
>

Oh, Looks like I'm late :)
thanks anyway.


-- 

Love each day!
--fan
