Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab0HXLkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 07:40:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab0HXLkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 07:40:02 -0400
Message-ID: <4C73AF8E.60603@redhat.com>
Date: Tue, 24 Aug 2010 14:39:58 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: x86@kernel.org, kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: allow kernel exception fixup for divide errors
 (#DE)
References: <1282648229-19575-1-git-send-email-avi@redhat.com>	<1282648229-19575-2-git-send-email-avi@redhat.com> <AANLkTikb1SN6YDsU0dPfTjDkLAZGOX27ccaiEc5OoQHC@mail.gmail.com>
In-Reply-To: <AANLkTikb1SN6YDsU0dPfTjDkLAZGOX27ccaiEc5OoQHC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 08/24/2010 02:22 PM, Brian Gerst wrote:
>
>> +dotraplinkage void do_divide_error(struct pt_regs *regs, long error_code)
>> +{
>> +       if (!user_mode_vm(regs)&&  fixup_exception(regs))
>> +               return;
>> +       do_divide_error_user(regs, error_code);
>> +}
>> +
>>   #ifdef CONFIG_X86_64
>>   /* Runs on IST stack */
>>   dotraplinkage void do_stack_segment(struct pt_regs *regs, long error_code)
> Kernel mode exceptions should already be handled by do_trap().  This
> is unnecessary.

Correct.  Please ignore this patch.  I've verified that the other two 
work without it.

-- 
error compiling committee.c: too many arguments to function

