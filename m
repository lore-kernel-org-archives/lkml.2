Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab2IZDoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 23:44:03 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:58310 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2IZDoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 23:44:01 -0400
Message-ID: <506279F8.10704@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2012 11:43:52 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Michael Wang <wangyun@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, kjwinchester@gmail.com,
        borislav.petkov@amd.com, ak@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH] x86: remove the useless branch in c_start()
References: <1348033343-23658-1-git-send-email-wangyun@linux.vnet.ibm.com>
In-Reply-To: <1348033343-23658-1-git-send-email-wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092603-2674-0000-0000-0000061CE381
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 01:42 PM, Michael Wang wrote:
> Since 'cpu == -1' in cpumask_next() is legal, no need to handle '*pos == 0'
> specially.
> 
> About the comments:
> 	/* just in case, cpu 0 is not the first */
> A test with a cpumask in which cpu 0 is not the first has been done, and it
> works well.

Could I get some comments on this patch?

Regards,
Michael Wang

> 
> This patch will remove that useless branch to clean the code.
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  arch/x86/kernel/cpu/proc.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
> index 8022c66..fbd8955 100644
> --- a/arch/x86/kernel/cpu/proc.c
> +++ b/arch/x86/kernel/cpu/proc.c
> @@ -140,10 +140,7 @@ static int show_cpuinfo(struct seq_file *m, void *v)
> 
>  static void *c_start(struct seq_file *m, loff_t *pos)
>  {
> -	if (*pos == 0)	/* just in case, cpu 0 is not the first */
> -		*pos = cpumask_first(cpu_online_mask);
> -	else
> -		*pos = cpumask_next(*pos - 1, cpu_online_mask);
> +	*pos = cpumask_next(*pos - 1, cpu_online_mask);
>  	if ((*pos) < nr_cpu_ids)
>  		return &cpu_data(*pos);
>  	return NULL;
> 

