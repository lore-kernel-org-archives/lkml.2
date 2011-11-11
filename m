Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253Ab1KKM2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 07:28:09 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:33338 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab1KKM2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 07:28:07 -0500
X-ASG-Debug-ID: 1321014485-01de2837981273e0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4EBD14D3.5090002@fusionio.com>
Date: Fri, 11 Nov 2011 13:28:03 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        "stable@kernel.org" <stable@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] backing-dev: ensure wakeup_timer is deleted
References: <1320916025-20264-1-git-send-email-linus.walleij@stericsson.com>
X-ASG-Orig-Subj: Re: [PATCH] backing-dev: ensure wakeup_timer is deleted
In-Reply-To: <1320916025-20264-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1321014485
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.79950
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-10 10:07, Linus Walleij wrote:
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index a086064..71034f4 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -724,6 +724,14 @@ void bdi_destroy(struct backing_dev_info *bdi)
>  
>  	bdi_unregister(bdi);
>  
> +	/*
> +	 * If bdi_unregister() had already been called earlier, the
> +	 * wakeup_timer could still be armed because bdi_prune_sb()
> +	 * can race with the bdi_wakeup_thread_delayed() calls from
> +	 * __mark_inode_dirty().
> +	 */
> +	del_timer_sync(&bdi->wb.wakeup_timer);
> +
>  	for (i = 0; i < NR_BDI_STAT_ITEMS; i++)
>  		percpu_counter_destroy(&bdi->bdi_stat[i]);

Thanks, makes sense, applied.

-- 
Jens Axboe

