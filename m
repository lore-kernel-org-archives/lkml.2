Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2A3TzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:55:09 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab2A3TzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:55:08 -0500
Message-ID: <4F26F640.2050602@nod.at>
Date: Mon, 30 Jan 2012 20:57:52 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] um: Use generic io.h
References: <1327512234-22578-1-git-send-email-richard@nod.at> <20120130182333.GK23916@ZenIV.linux.org.uk> <20120130192552.GL23916@ZenIV.linux.org.uk> <20120130193238.GM23916@ZenIV.linux.org.uk>
In-Reply-To: <20120130193238.GM23916@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.01.2012 20:32, schrieb Al Viro:
> On Mon, Jan 30, 2012 at 07:25:52PM +0000, Al Viro wrote:
>
>> While we are at it, param.h and pci.h appear to be candidates for the
>> same treatment, along with delay.h and auxvec.h.  mutex.h as well...
>> BTW, we probably can kill arch/um/include/asm/asm-offsets.h - everything
>> in there is using generated/asm-offsets.h directly.
>>
>> FWIW, I'd probably kill current.h as well - replace get_current() in
>> arch/um/kernel/process.c with get_current_pid() (i.e. task_pid_nr(current)),
>> kill HOST_TASK_PID and switch arch/x86/um/bugs_32.c to use of get_current_pid()
>> and we can switch to asm-generic/current.h just fine.
>
> BTW, while looking at those headers - why do we need asm/user.h pulled from
> arch/um/include/asm/ptrace-generic.h?

Hmmm, looks like a relict.
Let's remove it.

Thanks,
//richard

