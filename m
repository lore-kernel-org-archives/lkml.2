Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0IQGLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 02:11:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:29968 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab0IQGLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 02:11:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,380,1280732400"; 
   d="scan'208";a="838483047"
Message-ID: <4C9305C8.60609@linux.intel.com>
Date: Fri, 17 Sep 2010 14:08:08 +0800
From: Minskey Guo <chaohong_guo@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100702 Thunderbird/3.0.5
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: minskey guo <chaohong.guo@linux.intel.com>, linux-kernel@vger.kernel.org,
        chaohong.guo@intel.com
Subject: Re: [PATCH]  NULL pointer might be used in ips_monitor()
References: <1284613588-5199-1-git-send-email-chaohong.guo@linux.intel.com> <20100916145355.24a55114@jbarnes-x201>
In-Reply-To: <20100916145355.24a55114@jbarnes-x201>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2010 08:53 PM, Jesse Barnes wrote:
> On Thu, 16 Sep 2010 13:06:28 +0800
> minskey guo<chaohong.guo@linux.intel.com>  wrote:
>
>    
>> From: minskey guo<chaohong_guo@linux.intel.com>
>>
>>   The patch is to enable creating ips_adjust thread before ips_monitor
>>   executes because the latter will kthread_stop() or wake up the former
>>   via ips->adjust pointer. Otherwise, it is possible that ips->adjust
>> is NULL when kthread_stop() or wake_up_process() is called in
>> ips_monitor()
>>
>>   Besides, some trival changes:
>>     a) correct an define of register bits;
>>     b) old_cpu_power sample should not be divided by 65535
>>     c) handling on error path in ips_get_i915_syms()
>>      
> Excellent, thanks for the fixes.  Can you split up the patch into
> individual fixes and send them over to the platform driver list and
> Matthew Garrett?  You can add my acked-by on them.
>
> Thanks,
>    


Ok.  I split it into 4 patches,  and sent to platform driver list:
platform-driver-x86@vger.kernel.org.


-minskey
