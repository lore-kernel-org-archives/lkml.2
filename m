Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2GaDtq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 23:49:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3117 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab2GaDtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 23:49:45 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=yIyBo7O4uL8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VnNF1IyMAAAA:8 a=f3xNMp6A29MOF49DiD0A:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343706583.27983.28.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] preempt/hardirq.h: Fix comment about PREEMPT_ACTIVE bit
 location
From: Steven Rostedt <rostedt@goodmis.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, mingo@kernel.org, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org, linux-kernel@vger.kernel.org
Date: Mon, 30 Jul 2012 23:49:43 -0400
In-Reply-To: <20120720192459.6149.14821.stgit@srivatsabhat.in.ibm.com>
References: <20120720192459.6149.14821.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-21 at 00:54 +0530, Srivatsa S. Bhat wrote:
> PREEMPT_ACTIVE flag is bit 27, not 28. Fix the comment.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
> 
>  include/linux/hardirq.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
> index bb7f309..305f23c 100644
> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -22,7 +22,7 @@
>   *
>   * - bits 16-25 are the hardirq count (max # of nested hardirqs: 1024)
>   * - bit 26 is the NMI_MASK
> - * - bit 28 is the PREEMPT_ACTIVE flag
> + * - bit 27 is the PREEMPT_ACTIVE flag

Sorry but in arch/x86/include/asm/thread_info.h we have:

#define PREEMPT_ACTIVE		0x10000000

Which happens to be the 28th bit, not 27th. Although, if an arch did not
define PREEMPT_ACTIVE it would be 27th.

Perhaps the correct thing to do is to say:

  By default the following bits are defined as:
	[...]
  Different architectures may modify these.

And then add your change.

-- Steve

>   *
>   * PREEMPT_MASK: 0x000000ff
>   * SOFTIRQ_MASK: 0x0000ff00


