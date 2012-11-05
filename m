Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab2KEI6j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:58:39 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33051 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab2KEI6i convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Mon, 5 Nov 2012 03:58:38 -0500
Message-Id: <50978DC902000078000A64AB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 05 Nov 2012 08:58:33 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Salman Qazi" <sqazi@google.com>, "Ingo Molnar" <mingo@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][GIT PULL][3.8] x86: Don't clobber top of pt_regs
 in nested NMI
References: <1351883953.4004.144.camel@gandalf.local.home>
In-Reply-To: <1351883953.4004.144.camel@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.11.12 at 20:19, Steven Rostedt <rostedt@goodmis.org> wrote:
> @@ -1842,8 +1851,12 @@ nmi_swapgs:
>  	SWAPGS_UNSAFE_STACK
>  nmi_restore:
>  	RESTORE_ALL 8
> +
> +	/* Pop the extra iret frame */
> +	addq $(5*8), %rsp

This could (for code efficiency) and should (for CFI annotation
correctness) be folded into the RESTORE_ALL above (by
converting "8" to "6*8").

Jan

> +
>  	/* Clear the NMI executing stack variable */
> -	movq $0, 10*8(%rsp)
> +	movq $0, 5*8(%rsp)
>  	jmp irq_return
>  	CFI_ENDPROC
>  END(nmi)


