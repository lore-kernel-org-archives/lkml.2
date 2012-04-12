Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965599Ab2DLQLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:11:06 -0400
Received: from mail1.windriver.com ([147.11.146.13]:45849 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970Ab2DLQLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:11:04 -0400
Message-ID: <4F86FE82.1040007@windriver.com>
Date: Thu, 12 Apr 2012 12:10:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Ingo Molnar <mingo@elte.hu>, Huang Ying <ying.huang@intel.com>,
        David Howells <dhowells@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq_work: fix compile failure on tile from missing include
References: <201204111627.q3BGRJ5m005114@farm-0002.internal.tilera.com>
In-Reply-To: <201204111627.q3BGRJ5m005114@farm-0002.internal.tilera.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-04-11 12:21 PM, Chris Metcalf wrote:
> Building with IRQ_WORK configured results in
> 
> kernel/irq_work.c: In function ‘irq_work_run’:
> kernel/irq_work.c:110: error: implicit declaration of function ‘irqs_disabled’
> 
> The appropriate header just needs to be included.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Hi Chris,

I've got an alpha fix and an itanic fix left wrt. the system.h
fallout to get pulled; I can bundle this system.h fix with those
if you want.

Paul.

> ---
>  kernel/irq_work.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index 0c56d44..1588e3b 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -11,6 +11,7 @@
>  #include <linux/irq_work.h>
>  #include <linux/percpu.h>
>  #include <linux/hardirq.h>
> +#include <linux/irqflags.h>
>  #include <asm/processor.h>
>  
>  /*
