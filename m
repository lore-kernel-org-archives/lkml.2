Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab1EKQ3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:29:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13392 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757682Ab1EKQ3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:29:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=G3fwiQ+6d6D/0XeqbWxJ0RHreVEgOeuou5edJ3U7DhSxuZRPdm/Df4302BHMQ9d23M
         xj9KZCyLz26+QtIzcb2g==
MIME-Version: 1.0
In-Reply-To: <4DC8E7A6.3010003@jp.fujitsu.com>
References: <20110503092846.022272244@google.com> <20110503092904.985285812@google.com>
 <4DC8E7A6.3010003@jp.fujitsu.com>
From: Paul Turner <pjt@google.com>
Date: Wed, 11 May 2011 02:25:34 -0700
Message-ID: <BANLkTikj=a9LgrazL5GSk3NMYFY741gKUQ@mail.gmail.com>
Subject: Re: [patch 06/15] sched: accumulate per-cfs_rq cpu usage and charge
 against bandwidth
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 10, 2011 at 12:22 AM, Hidetoshi Seto
<seto.hidetoshi@jp.fujitsu.com> wrote:
> (2011/05/03 18:28), Paul Turner wrote:
>> Index: tip/include/linux/sched.h
>> ===================================================================
>> --- tip.orig/include/linux/sched.h
>> +++ tip/include/linux/sched.h
>> @@ -1958,6 +1958,10 @@ int sched_cfs_consistent_handler(struct
>>               loff_t *ppos);
>>  #endif
>>
>> +#ifdef CONFIG_CFS_BANDWIDTH
>> +extern unsigned int sysctl_sched_cfs_bandwidth_slice;
>> +#endif
>> +
>>  #ifdef CONFIG_SCHED_AUTOGROUP
>>  extern unsigned int sysctl_sched_autogroup_enabled;
>>
>
> Nit: you can reuse ifdef just above here.

Thanks!  I think this was actually a quilt-mis-merge when I was
shuffling the order of things around.  Definitely makes sense to
combine them.

>
> +#ifdef CONFIG_CFS_BANDWIDTH
> +extern unsigned int sysctl_sched_cfs_bandwidth_consistent;
> +
> +int sched_cfs_consistent_handler(struct ctl_table *table, int write,
> +               void __user *buffer, size_t *lenp,
> +               loff_t *ppos);
> +#endif
> +
> +#ifdef CONFIG_CFS_BANDWIDTH
> +extern unsigned int sysctl_sched_cfs_bandwidth_slice;
> +#endif
> +
>
> Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
>
>
> Thanks,
> H.Seto
>
>
