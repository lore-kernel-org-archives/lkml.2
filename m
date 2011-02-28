Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab1B1PRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:17:40 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37271 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab1B1PRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:17:38 -0500
Date: Mon, 28 Feb 2011 16:17:36 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>, kernel@pengutronix.de,
        Arjan van de Ven <arjan@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 5/6] mm: add some KERN_CONT markers to continuation
 lines
Message-ID: <20110228151736.GO22310@pengutronix.de>
References: <20101124085645.GW4693@pengutronix.de>
 <1290589070-854-5-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290589070-854-5-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


On Wed, Nov 24, 2010 at 09:57:49AM +0100, Uwe Kleine-König wrote:
> Cc: linux-mm@kvack.org
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  mm/percpu.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index efe8168..3356646 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -1117,20 +1117,20 @@ static void pcpu_dump_alloc_info(const char *lvl,
>  		for (alloc_end += gi->nr_units / upa;
>  		     alloc < alloc_end; alloc++) {
>  			if (!(alloc % apl)) {
> -				printk("\n");
> -				printk("%spcpu-alloc: ", lvl);
> +				printk(KERN_CONT "\n");
> +				printk("%spcpu-alloc:", lvl);
>  			}
> -			printk("[%0*d] ", group_width, group);
> +			printk(KERN_CONT " [%0*d]", group_width, group);
>  
>  			for (unit_end += upa; unit < unit_end; unit++)
>  				if (gi->cpu_map[unit] != NR_CPUS)
> -					printk("%0*d ", cpu_width,
> +					printk(KERN_CONT " %0*d", cpu_width,
>  					       gi->cpu_map[unit]);
>  				else
> -					printk("%s ", empty_str);
> +					printk(KERN_CONT " %s", empty_str);
>  		}
>  	}
> -	printk("\n");
> +	printk(KERN_CONT "\n");
>  }
>  
>  /**
ping

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
