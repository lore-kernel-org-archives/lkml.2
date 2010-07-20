Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab0GTM6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 08:58:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab0GTM6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 08:58:39 -0400
Message-ID: <4C459CB1.8060800@redhat.com>
Date: Tue, 20 Jul 2010 08:55:13 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] cpufreq: fix memory leak in cpufreq_add_dev
References: <1279627862-4107-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1279627862-4107-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/20/2010 08:11 AM, Xiaotian Feng wrote:
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 063b218..12263b4 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1077,6 +1077,7 @@ err_out_unregister:
>  
>  err_unlock_policy:
>  	unlock_policy_rwsem_write(cpu);
> +	free_cpumask_var(policy->related_cpus);
>  err_free_cpumask:
>  	free_cpumask_var(policy->cpus);
>  err_free_policy:
>   

Seems right to me ...

P.
