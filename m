Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab2GLCIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 22:08:43 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37606 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab2GLCIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 22:08:41 -0400
X-AuditID: b753bd60-9ea82ba000000655-71-4ffe31a79631
X-AuditID: b753bd60-9ea82ba000000655-71-4ffe31a79631
Message-ID: <4FFE31A5.2030806@hitachi.com>
Date: Thu, 12 Jul 2012 11:08:37 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 5/6] ftrace/x86: Add separate function to save regs
References: <20120702200322.573660631@goodmis.org>  <20120702201821.510485400@goodmis.org> <4FF2AD59.6080006@hitachi.com>  <1342023754.14828.43.camel@gandalf.stny.rr.com> <1342024090.14828.45.camel@gandalf.stny.rr.com>
In-Reply-To: <1342024090.14828.45.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/07/12 1:28), Steven Rostedt wrote:
> On Wed, 2012-07-11 at 12:22 -0400, Steven Rostedt wrote:
>> On Tue, 2012-07-03 at 17:29 +0900, Masami Hiramatsu wrote:
>>
>>
>>>
>>>> +	/* Restore flags */
>>>> +	pushq EFLAGS(%rsp)
>>>> +	popfq
>>>> +
>>>> +	MCOUNT_RESTORE_FRAME
>>>
>>> Here, if MCOUNT_RESTORE_FRAME has skip too, I think you don't
>>> need to restore flags before restoring other registers, like
>>> below;
>>>
>>> 	MCOUNT_RESTORE_FRAME 8
>>> 	popfq
>>>
>>> And also, this will prevent to modify flags before return by
>>> addq in MCOUNT_RESTORE_FRAME.
>>
>> Ah, because the addq will modify flags :-/
>>
>> Grumble, I guess I should implement this, even though it will make it a
>> little more complex. I thought it was better to restore flags
>> explicitly, but that's not the case.
>>
> 
> I know why I did this. Do you want kprobes to be able to modify flags?
> If so, then I need to add, before the restore:
> 
> 	movq EFLAGS(%rsp), %rax
> 	movq %rax, SS(%rsp)

Yes, kprobes might be used for modifying flags, so, please :)

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


