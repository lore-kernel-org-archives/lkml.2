Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab2GCQy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:54:29 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42462 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755297Ab2GCQy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:54:27 -0400
Message-Id: <1341334466.32545.140661097365717.3B7276E0@webmail.messagingengine.com>
X-Sasl-Enc: WGnq0zdzcp7vX4RavvvrRTny5TxgiFZrV668i2iHIgzY 1341334466
From: Alexander van Heukelum <heukelum@fastmail.fm>
To: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <20120702201821.510485400@goodmis.org>
References: <20120702200322.573660631@goodmis.org>
 <20120702201821.510485400@goodmis.org>
Subject: Re: [PATCH 5/6] ftrace/x86: Add separate function to save regs
Date: Tue, 03 Jul 2012 18:54:26 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 2, 2012, at 16:03, Steven Rostedt wrote:
> Email had 1 attachment:
> + 0005-ftrace-x86-Add-separate-function-to-save-regs.patch
>   23k (text/plain)

Hi Steven,

One thing that caught my eye...

> diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
> index e3e17a0..acd4963 100644
> --- a/arch/x86/kernel/entry_32.S
> +++ b/arch/x86/kernel/entry_32.S
> @@ -1109,6 +1109,7 @@ ENTRY(ftrace_caller)
>  	pushl %eax
>  	pushl %ecx
>  	pushl %edx
> +	pushl $0	/* Pass NULL as regs pointer */
>  	movl 0xc(%esp), %eax

This should now be changed to "0x10(%esp)", right?

Greetings,
    Alexander

>  	movl 0x4(%ebp), %edx
>  	leal function_trace_op, %ecx
> @@ -1118,6 +1119,7 @@ ENTRY(ftrace_caller)
>  ftrace_call:
>  	call ftrace_stub
>  
> +	addl $4,%esp	/* skip NULL pointer */
>  	popl %edx
>  	popl %ecx
>  	popl %eax

