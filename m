Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2AUBB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 20:01:26 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:37243 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2AUBBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 20:01:25 -0500
MIME-Version: 1.0
In-Reply-To: <4F187FA1.9090006@jp.fujitsu.com>
References: <4F171B6B.2040303@gmail.com>
	<1327003271-11730-1-git-send-email-venki@google.com>
	<4F187FA1.9090006@jp.fujitsu.com>
Date: Fri, 20 Jan 2012 17:01:24 -0800
Message-ID: <CABeCy1ZQmqEGPWZqCcw_oAufGaQe1NcPsn49DafgGfo+K7HGuA@mail.gmail.com>
Subject: Re: [PATCH] Avoid mask based num_possible_cpus and num_online_cpus
From: Venki Pallipadi <venki@google.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@gmail.com, akpm@linux-foundation.org, travis@sgi.com,
        srivatsa.bhat@linux.vnet.ibm.com, paul.mckenney@linaro.org,
        rjw@sisk.pl, paul.gortmaker@windriver.com,
        linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 12:40 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> On 1/19/2012 3:01 PM, Venkatesh Pallipadi wrote:
>> Does this look better? Will send separate patch to fix code
>> using num_possible_cpus() when they actually need nr_cpu_ids.
>
> Sound ok to me. but I have two requests.
>
>  - Please mesure how much time (or cycle) spented by cpumask_weight(cpu_possible_mask).

On two of the recentish x86 server CPUs, __sw_hweight64() base
mask_weight() takes ~300 cycles. popcnt instruction based weight takes
<10 cycles.

>  - After your patch, nr_possible_cpus() return different value from before.

Yes. I have tested this on x86 and haven't seen any problem.

>   Please verify this change doesn't makes any side effect.
>
>
