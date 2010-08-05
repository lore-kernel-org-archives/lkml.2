Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760294Ab0HEMz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:55:59 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50623 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758925Ab0HEMz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:55:56 -0400
Date: Thu, 5 Aug 2010 18:25:51 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/2] kprobes: Update document about irq disabled state
 in kprobe handler
Message-ID: <20100805125551.GA28884@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <4C5AAFF9.4030103@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C5AAFF9.4030103@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 09:35:05PM +0900, Masami Hiramatsu wrote:
> Update kprobes.txt about interrupts disabled state inside
> kprobes handlers, because optimized probe/boosted kretprobe
> run without disabling interrrupts on x86.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> Cc: linux-kernel@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> ---
> 
>  Documentation/kprobes.txt |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/kprobes.txt b/Documentation/kprobes.txt
> index 6653017..4189f01 100644
> --- a/Documentation/kprobes.txt
> +++ b/Documentation/kprobes.txt
> @@ -541,9 +541,11 @@ Kprobes does not use mutexes or allocate memory except during
>  registration and unregistration.
> 
>  Probe handlers are run with preemption disabled.  Depending on the
> -architecture, handlers may also run with interrupts disabled.  In any
> -case, your handler should not yield the CPU (e.g., by attempting to
> -acquire a semaphore).
> +architecture and optimization state, handlers may also run with
> +interrupts disabled (e.g., kretprobe handlers and optimized kprobe
> +handlers run without interrupt disabled on x86/x86-64).  In any case,
> +your handler should not yield the CPU (e.g., by attempting to acquire
> +a semaphore).
> 
>  Since a return probe is implemented by replacing the return
>  address with the trampoline's address, stack backtraces and calls
> 
