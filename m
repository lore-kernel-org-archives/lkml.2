Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab1EJHWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 03:22:38 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45501 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab1EJHWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 03:22:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DC8E7A6.3010003@jp.fujitsu.com>
Date: Tue, 10 May 2011 16:22:14 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Subject: Re: [patch 06/15] sched: accumulate per-cfs_rq cpu usage and charge
 against bandwidth
References: <20110503092846.022272244@google.com> <20110503092904.985285812@google.com>
In-Reply-To: <20110503092904.985285812@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/03 18:28), Paul Turner wrote:
> Index: tip/include/linux/sched.h
> ===================================================================
> --- tip.orig/include/linux/sched.h
> +++ tip/include/linux/sched.h
> @@ -1958,6 +1958,10 @@ int sched_cfs_consistent_handler(struct 
>  		loff_t *ppos);
>  #endif
>  
> +#ifdef CONFIG_CFS_BANDWIDTH
> +extern unsigned int sysctl_sched_cfs_bandwidth_slice;
> +#endif
> +
>  #ifdef CONFIG_SCHED_AUTOGROUP
>  extern unsigned int sysctl_sched_autogroup_enabled;
>  

Nit: you can reuse ifdef just above here.

+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_consistent;
+
+int sched_cfs_consistent_handler(struct ctl_table *table, int write,
+               void __user *buffer, size_t *lenp,
+               loff_t *ppos);
+#endif
+
+#ifdef CONFIG_CFS_BANDWIDTH
+extern unsigned int sysctl_sched_cfs_bandwidth_slice;
+#endif
+

Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>


Thanks,
H.Seto

