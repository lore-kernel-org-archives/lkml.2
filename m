Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288Ab1JEShj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:37:39 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37883 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933573Ab1JEShj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:37:39 -0400
Message-ID: <4E8CA3EA.3080706@linux.vnet.ibm.com>
Date: Thu, 06 Oct 2011 00:07:30 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, srivatsa.bhat@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>, H Peter Anvin <hpa@zytor.com>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Len Brown <lenb@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/8] kernel/power/main.c: Not suspend/resume if CPU0 is
 offlined
References: <1317832759-10223-1-git-send-email-fenghua.yu@intel.com> <1317832759-10223-8-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1317832759-10223-8-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/05/2011 10:09 PM, Fenghua Yu wrote:
> 
> @@ -178,6 +179,14 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>  	int len;
>  	int error = -EINVAL;
> 
> +#ifdef CONFIG_HOTPLUG_CPU
> +	if (bsp_hotpluggable && cpumask_first(cpu_online_mask) != 0) {
> +		printk(KERN_WARNING "Because CPU0 is offlined, system can't suspend/resume.\n");
> +
> +		return -ENODEV;
> +	}
> +#endif

There is a possible race condition here. What if CPU0 gets offlined
AFTER this point(due to a CPU hotplug operation)?
We will probably have to prevent CPU0 from being taken offline from
this point onwards, and remove that restriction later on.

> +
>  	p = memchr(buf, '\n', n);
>  	len = p ? p - buf : n;
> 


-- 
Regards,
Srivatsa S. Bhat  <srivatsa.bhat@linux.vnet.ibm.com>
Linux Technology Center,
IBM India Systems and Technology Lab
