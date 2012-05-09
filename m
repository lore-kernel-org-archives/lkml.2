Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759740Ab2EIPXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:23:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab2EIPXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:23:40 -0400
Message-ID: <4FAA8BCC.5000704@redhat.com>
Date: Wed, 09 May 2012 17:22:52 +0200
From: Igor Mammedov <imammedo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: shuahkhan@gmail.com
CC: linux-kernel@vger.kernel.org, rob@landley.net, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org, luto@mit.edu,
        suresh.b.siddha@intel.com, avi@redhat.com, a.p.zijlstra@chello.nl,
        johnstul@us.ibm.com, arjan@linux.intel.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/5] Fix soft-lookup in stop machine on secondary cpu
 bring up
References: <1336559102-28103-1-git-send-email-imammedo@redhat.com>  <1336559102-28103-2-git-send-email-imammedo@redhat.com> <1336575858.2498.7.camel@lorien2>
In-Reply-To: <1336575858.2498.7.camel@lorien2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2012 05:04 PM, Shuah Khan wrote:
> On Wed, 2012-05-09 at 12:24 +0200, Igor Mammedov wrote:
>> When bringing up cpuX1, it could stall in start_secondary
>> before setting cpu_callin_mask for more than 5 sec. That forces
>> do_boot_cpu() to give up on waiting and go to error return path
>> printing messages:
>>    pr_err("CPU%d: Stuck ??\n", cpuX1);
>
> I am seeing this with the linux-next May 7th build on my laptop HP
> EliteBook 8440p during boot. Could this problem be not specific to virt
> envs.? Anybody else seeing it?

I could only guess that on bare metal SMI or other firmware issue may interfere with AP boot.
Could you test if this patch-set fixes issue for you?
And do you see the same problem during suspend/resume (assuming that it's booted without problem)?

-- 
-----
  Igor
