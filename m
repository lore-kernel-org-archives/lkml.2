Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab2JQIbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 04:31:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62850 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2JQIbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 04:31:12 -0400
MIME-Version: 1.0
In-Reply-To: <507D4B2A.6080107@hitachi.com>
References: <1350378135-18919-1-git-send-email-hyc.lee@gmail.com>
	<507D4B2A.6080107@hitachi.com>
Date: Wed, 17 Oct 2012 17:31:11 +0900
Message-ID: <CANFS6baH7eM4RLBA4CsSc=o+msVAS1cT9PkNOiy4cdL1Pe=yJw@mail.gmail.com>
Subject: Re: [PATCH] uprobes tracer: Add stack/memory/retval access support
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/16 Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>:
> (2012/10/16 18:02), Hyeoncheol Lee wrote:
>> Event arguments except @SYM are supported. They are @ADDR,
>> $stack, $stackN, $retval, and offs(arguments).
>>
>> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
>> Signed-off-by: Hyeoncheol Lee <hyc.lee@gmail.com>
>> ---
>
> [...]
>>  #define DEFINE_FETCH_stack(type)                                     \
>>  static __kprobes void FETCH_FUNC_NAME(stack, type)(struct pt_regs *regs,\
>> -                                       void *offset, void *dest)     \
>> +                                       void *offset, void *dest,     \
>> +                                       bool kprobe)                  \
>>  {                                                                    \
>> -     *(type *)dest = (type)regs_get_kernel_stack_nth(regs,           \
>> +     if (kprobe)                                                     \
>> +             *(type *)dest = (type)regs_get_kernel_stack_nth(regs,   \
>>                               (unsigned int)((unsigned long)offset)); \
>> +     else                                                            \
>> +             *(type *)dest = (type)regs_get_user_stack_nth(regs,     \
>> +                             (unsigned int)((unsigned long)offset)); \
>>  }
>
>
> Hmm, I don't think this is a good way to do that.
> If fetching user space objects is different from the kernel one,
> we'd better introduce new fetch handlers for it, instead of checking
> a bool flag every time, because it will be done on every events.
>
> Thank you,
>
>
> --
> Masami HIRAMATSU
> IT Management Research Dept. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
>
>

Yes
Thank you for your comment
