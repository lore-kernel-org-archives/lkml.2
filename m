Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993263Ab2KOKYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:24:20 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:39017 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423250Ab2KOKYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:24:18 -0500
Message-ID: <50A4C2C5.90306@synopsys.com>
Date: Thu, 15 Nov 2012 15:54:05 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>
Subject: Re: [RFC Patch v1 33/55] ARC: ptrace support
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-3-git-send-email-vgupta@synopsys.com> <201211121351.06023.arnd@arndb.de>
In-Reply-To: <201211121351.06023.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012 07:21 PM, Arnd Bergmann wrote:
> On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
>> +       case PTRACE_PEEKUSR:
>> +               pos = addr;     /* offset in struct user_regs_struct */
>> +               count = 4;      /* 1 register only */
>> +               u_addr = (unsigned int __user *)data;
>> +               kbuf = NULL;
>> +               ret = genregs_get(child, NULL, pos, count, kbuf, u_addr);
>> +               break;
>> +
>> +       case PTRACE_POKEUSR:
>> +               pos = addr;     /* offset in struct user_regs_struct */
>> +               count = 4;      /* 1 register only */
>> +
>> +               /* Ideally @data would have abeen a user space buffer, from
>> +                * where, we do a copy_from_user.
>> +                * However this request only involves one word, which courtesy
>> +                * our ABI can be passed in a reg.
>> +                * regset interface however expects some buffer to copyin from
>> +                */
>> +               kbuf = &data;
>> +               u_addr = NULL;
>> +
>> +               ret = genregs_set(child, NULL, pos, count, kbuf, u_addr);
>> +               break;
>> +
> I think these should be moved into regsets, as we have done for all
> other new architectures. Your arch_ptrace then becomes a trivial wrapper
> around ptrace_request.

The regset stuff is already complete - and even this code uses the reget
callbacks. It's just that we need to carry on this dual ABI for some
time for our legacy gdbserver.

>
> 	Arnd

