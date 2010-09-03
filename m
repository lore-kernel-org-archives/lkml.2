Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab0ICJgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 05:36:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36520 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0ICJgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 05:36:08 -0400
Date: Fri, 3 Sep 2010 11:35:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Len Brown <lenb@kernel.org>,
        Jin Dongming <jin.dongming@np.css.fujitsu.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Jean Delvare <khali@linux-fr.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] therm_throt.c: Fix error handling in
 thermal_throttle_add_dev
Message-ID: <20100903093553.GA6821@elte.hu>
References: <1283474726-20109-1-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283474726-20109-1-git-send-email-fenghua.yu@intel.com>
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


* Fenghua Yu <fenghua.yu@intel.com> wrote:

> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Warn when sysfs_add_file_to_group fails.
> 
> Also add missing curly braces.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/kernel/cpu/mcheck/therm_throt.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)

> +               WARN_ON(err);

Hm, we tend to use WARN_ON_ONCE(), to avoid repeat spamming of the 
syslog. Also, and perhaps more importantly, WARN_ON() is not a 
particularly smart way to handle errors. How do other drivers handle 
sysfs registration failures?

Also, that's not the only thing the patch does:

> @@ -211,20 +211,26 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)

> -	return err;
> +	return 0;

How is the ignoring of an error and turning it into a WARN_ON() a fix? 
Either it makes no sense to return errors - in which case the whole 
add_dev method needs to be fixed in all drivers - or it makes sense, in 
which case the behavior here is inconsistent.

At minimum more explanation is needed in the changelog.

Thanks,

	Ingo
