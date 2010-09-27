Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab0I0GZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 02:25:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43053 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753591Ab0I0GZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 02:25:52 -0400
Date: Mon, 27 Sep 2010 08:25:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, Fenghua Yu <fenghua.yu@intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] hwmon (coretemp): Fix build breakage if SMP is undefined
Message-ID: <20100927062510.GA17825@elte.hu>
References: <1285530603-2510-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285530603-2510-1-git-send-email-guenter.roeck@ericsson.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Guenter Roeck <guenter.roeck@ericsson.com> wrote:

> Commit e40cc4bdfd4b89813f072f72bd9c7055814d3f0f introduced
> a build breakage if CONFIG_SMP is undefined. This patch
> fixes the problem.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: Jean Delvare <khali@linux-fr.org>
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> 
> ---
>  drivers/hwmon/coretemp.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index baa842a..58a3c2d 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -503,9 +503,11 @@ static void coretemp_device_remove(unsigned int cpu)
>  		list_del(&p->list);
>  		mutex_unlock(&pdev_list_mutex);
>  		kfree(p);
> +#ifdef CONFIG_SMP
>  		for_each_cpu(i, cpu_sibling_mask(cpu))
>  			if (i != cpu && !coretemp_device_add(i))
>  				break;
> +#endif

Wont this result in an 'unused variable i' compiler warning?

Thanks,

	Ingo
