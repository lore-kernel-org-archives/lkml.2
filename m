Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756206Ab2ENPBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 11:01:48 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:24705 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664Ab2ENPBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 11:01:47 -0400
Message-ID: <1337007700.2476.1.camel@lorien2>
Subject: Re: [PATCH RESEND] x86: kernel/check.c simple_strtoul cleanup
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: mingo@redhat.com
Cc: shuahkhan@gmail.com, hpa@zytor.com, tglx@linutronix.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 May 2012 09:01:40 -0600
In-Reply-To: <1336326908.2897.12.camel@lorien2>
References: <1336326908.2897.12.camel@lorien2>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-06 at 11:55 -0600, Shuah Khan wrote:
> Change set_corruption_check() and set_corruption_check_period()
> in kernel/check.c to call kstrtoul() instead of calling
> obsoleted simple_strtoul().

How about this patch? Are you not interested in this type of cleanup
patches? Looking for some feedback so I can spend my energies on
something that would be worth while in the future :)

-- Shuah
> 
> 
> Signed-off-by: Shuah Khan <shuahkhan@gmail.com>
> ---
>  arch/x86/kernel/check.c |   20 ++++++++++++++------
>  1 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
> index 5da1269..e2dbcb7 100644
> --- a/arch/x86/kernel/check.c
> +++ b/arch/x86/kernel/check.c
> @@ -27,21 +27,29 @@ static int num_scan_areas;
>  
>  static __init int set_corruption_check(char *arg)
>  {
> -	char *end;
> +	ssize_t ret;
> +	unsigned long val;
>  
> -	memory_corruption_check = simple_strtol(arg, &end, 10);
> +	ret = kstrtoul(arg, 10, &val);
> +	if (ret)
> +		return ret;
>  
> -	return (*end == 0) ? 0 : -EINVAL;
> +	memory_corruption_check = val;
> +	return 0;
>  }
>  early_param("memory_corruption_check", set_corruption_check);
>  
>  static __init int set_corruption_check_period(char *arg)
>  {
> -	char *end;
> +	ssize_t ret;
> +	unsigned long val;
>  
> -	corruption_check_period = simple_strtoul(arg, &end, 10);
> +	ret = kstrtoul(arg, 10, &val);
> +	if (ret)
> +		return ret;
>  
> -	return (*end == 0) ? 0 : -EINVAL;
> +	corruption_check_period = val;
> +	return 0;
>  }
>  early_param("memory_corruption_check_period", set_corruption_check_period);
>  


