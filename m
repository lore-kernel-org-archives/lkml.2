Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759966Ab0FKANB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 20:13:01 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:7495 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab0FKAM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 20:12:59 -0400
Message-ID: <4C117F86.5090408@caviumnetworks.com>
Date: Thu, 10 Jun 2010 17:12:54 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Himanshu Chauhan <hschauhan@nulltrace.org>
CC: ralf@linux-mips.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH] MIPS: KProbes support v0.1
References: <1275928440-21052-1-git-send-email-hschauhan@nulltrace.org> <1275928440-21052-2-git-send-email-hschauhan@nulltrace.org> <4C0D4B82.6020002@caviumnetworks.com> <20100608175118.GA2262@hschauhan-desktop>
In-Reply-To: <20100608175118.GA2262@hschauhan-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2010 00:12:59.0516 (UTC) FILETIME=[D99073C0:01CB08FA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/2010 10:51 AM, Himanshu Chauhan wrote:
> Hi David,
>
> Thanks for taking a look.
>
[...]
>>> +
>>> +#define BREAKPOINT_INSTRUCTION		0x0000000d
>>> +
>>> +/*
>>> + * We do not have hardware single-stepping on MIPS.
>>> + * So we implement software single-stepping with breakpoint
>>> + * trap 'break 5'.
>>> + */
>>> +#define BREAKPOINT_INSTRUCTION_2	0x0000014d
>>
>> The BREAK codes are defined in asm/break.h  This should be added
>> there instead.
>>
>> Why do you use codes (0 and 5) that are already kind of reserved for
>> user space debuggers?
>
> As said ealier, this patch was based on some very older patch of 2.6.16 from
> Sony Corp, I didn't make much changes like this. But anyways, I wan't aware of
> this either. What would be the best code then?
>

How about allocating them after BRK_MEMU?  Say 515 and 516 or something 
like that.

David Daney
