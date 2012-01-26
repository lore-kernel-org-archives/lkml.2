Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab2AZV0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 16:26:05 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61757 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2AZV0C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 16:26:02 -0500
MIME-Version: 1.0
In-Reply-To: <4F218CF2.4020409@linux.vnet.ibm.com>
References: <CABeCy1ZA1nkWSmbN2LE+V1SxKEHX4XrpN5xfdzY=NSsS8=L0DA@mail.gmail.com>
 <1327447541-3040-1-git-send-email-venki@google.com> <4F218CF2.4020409@linux.vnet.ibm.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 26 Jan 2012 16:25:42 -0500
Message-ID: <CAHGf_=qiNYDKmgs63t2MeSSfTpNdwbqJiyfHRu4sHYTFePjzeA@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus -v4
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Venkatesh Pallipadi <venki@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Travis <travis@sgi.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/26 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>:
> On 01/25/2012 04:55 AM, Venkatesh Pallipadi wrote:
>
>> Kernel's notion of possible cpus (from include/linux/cpumask.h)
>>  *     cpu_possible_mask- has bit 'cpu' set iff cpu is populatable
>>
>>  *  The cpu_possible_mask is fixed at boot time, as the set of CPU id's
>>  *  that it is possible might ever be plugged in at anytime during the
>>  *  life of that system boot.
>>
>>  #define num_possible_cpus()     cpumask_weight(cpu_possible_mask)
>>
>> and on x86 cpumask_weight() calls hweight64 and hweight64 (on older kernels
>> and systems with !X86_FEATURE_POPCNT) or a popcnt based alternative.
>>
>> i.e, We needlessly go through this mask based calculation everytime
>> num_possible_cpus() is called.
>>
>> The problem is there with cpu_online_mask() as well, which is fixed value at
>> boot time in !CONFIG_HOTPLUG_CPU case and should not change that often even
>> in HOTPLUG case.
>>
>> Though most of the callers of these two routines are init time (with few
>> exceptions of runtime calls), it is cleaner to use variables
>> and not go through this repeated mask based calculation.
>>
>> Signed-off-by: Venkatesh Pallipadi <venki@google.com>
>> ---
>
>
> Looks good to me now :-)
>
> Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

I'm ok too.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
