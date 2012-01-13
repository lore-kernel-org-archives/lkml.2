Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab2AMNsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 08:48:38 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35947 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab2AMNsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 08:48:36 -0500
Message-ID: <4F103620.8070504@arm.com>
Date: Fri, 13 Jan 2012 13:48:16 +0000
From: Javi Merino <javi.merino@arm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Mans Rullgard <mans.rullgard@linaro.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Boojin Kim <boojin.kim@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] ARM: pl330: fix null pointer dereference in pl330_chan_ctrl()
References: <1326458191-23492-1-git-send-email-mans.rullgard@linaro.org>
In-Reply-To: <1326458191-23492-1-git-send-email-mans.rullgard@linaro.org>
X-OriginalArrivalTime: 13 Jan 2012 13:48:27.0055 (UTC) FILETIME=[06A72BF0:01CCD1FA]
X-MC-Unique: 112011313482904701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/12 12:36, Mans Rullgard wrote:
> This fixes the thrd->req_running field being accessed before thrd
> is checked for null.  The error was introduced in abb959f.
> 
> Signed-off-by: Mans Rullgard <mans.rullgard@linaro.org>
> ---
>  arch/arm/common/pl330.c |    3 ++-

As Russell points out, the s5p tree has merged this file with
drivers/dma/pl330.c so this bug is now in that file.  Please rebase the
patch on top of linux-next.

Other than that, yes, that's my fault.

Acked-by: Javi Merino <javi.merino@arm.com>

>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/common/pl330.c b/arch/arm/common/pl330.c
> index 8d8df74..67abef5 100644
> --- a/arch/arm/common/pl330.c
> +++ b/arch/arm/common/pl330.c
> @@ -1496,12 +1496,13 @@ int pl330_chan_ctrl(void *ch_id, enum pl330_chan_op op)
>  	struct pl330_thread *thrd = ch_id;
>  	struct pl330_dmac *pl330;
>  	unsigned long flags;
> -	int ret = 0, active = thrd->req_running;
> +	int ret = 0, active;
>  
>  	if (!thrd || thrd->free || thrd->dmac->state == DYING)
>  		return -EINVAL;
>  
>  	pl330 = thrd->dmac;
> +	active = thrd->req_running;
>  
>  	spin_lock_irqsave(&pl330->lock, flags);
>  


