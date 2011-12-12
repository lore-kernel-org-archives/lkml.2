Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1LLIQP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 03:16:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59934 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab1LLIQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 03:16:13 -0500
Date: Mon, 12 Dec 2011 09:16:11 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, "Artem S.Tashkinov" <t.artem@mailcity.com>,
        Dave Jones <davej@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] procfs: do not confuse jiffies with cputime64_t
Message-ID: <20111212081611.GA14720@tiehlicka.suse.cz>
References: <m28vmi7ip3.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m28vmi7ip3.fsf@igel.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-12-11 01:11:04, Andreas Schwab wrote:
> get_{idle,iowait}_time are supposed to return cputime64_t values, not jiffies.
> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>

Ahhh, I have missed that jiffies64_to_cputime64 is doing something for
ia64 and powerpc.
Thanks for noticing and fixing that up.

Acked-by: Michal Hocko <mhocko@suse.cz>

> ---
>  fs/proc/stat.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/stat.c b/fs/proc/stat.c
> index 2a30d67..88f8a55 100644
> --- a/fs/proc/stat.c
> +++ b/fs/proc/stat.c
> @@ -32,7 +32,7 @@ static cputime64_t get_idle_time(int cpu)
>  		idle = kstat_cpu(cpu).cpustat.idle;
>  		idle = cputime64_add(idle, arch_idle_time(cpu));
>  	} else
> -		idle = nsecs_to_jiffies64(1000 * idle_time);
> +		idle = jiffies64_to_cputime64(nsecs_to_jiffies64(1000 * idle_time));
>  
>  	return idle;
>  }
> @@ -46,7 +46,7 @@ static cputime64_t get_iowait_time(int cpu)
>  		/* !NO_HZ so we can rely on cpustat.iowait */
>  		iowait = kstat_cpu(cpu).cpustat.iowait;
>  	else
> -		iowait = nsecs_to_jiffies64(1000 * iowait_time);
> +		iowait = jiffies64_to_cputime64(nsecs_to_jiffies64(1000 * iowait_time));
>  
>  	return iowait;
>  }
> -- 
> 1.7.8
> 
> 
> -- 
> Andreas Schwab, schwab@linux-m68k.org
> GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
> "And now for something completely different."

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
