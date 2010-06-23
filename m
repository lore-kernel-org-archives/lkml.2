Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab0FWIJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:09:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab0FWIJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:09:46 -0400
Message-ID: <4C21C136.9070708@redhat.com>
Date: Wed, 23 Jun 2010 11:09:26 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Gleb Natapov <gleb@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, oerg Roedel <joro@8bytes.org>,
       Jes Sorensen <Jes.Sorensen@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       tim.c.chen@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH V2 3/5] ara virt interface of perf to support kvm guest
 os statistics collection in guest os
References: <1277112703.2096.511.camel@ymzhang.sh.intel.com>	 <20100621135659.GL4689@redhat.com>	 <1277185636.2096.675.camel@ymzhang.sh.intel.com>	 <4C206EA0.3060101@redhat.com> <1277257421.2096.758.camel@ymzhang.sh.intel.com>
In-Reply-To: <1277257421.2096.758.camel@ymzhang.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2010 04:43 AM, Zhang, Yanmin wrote:
>
>> A reset does not involve destroying a vm; you have to clean up as part
>> of the rest process.
>>      
> What does 'reset' here mean? Is it a reboot or halt? If it's a halt, it involves
> destroying a vm. If a host user just kills the qemu process, is it a reset involving
> destroying a vm?
>    

'reset' is either a complete reset ('system_reset' on the qemu monitor, 
cycles through the bios etc.) or just an INIT signal to one vcpu.  
Neither involves destroying a vm.

>> You aren't guaranteed a reboot notifier will be called.  On the other
>> hand, we need a kexec handler.
>>      
> ordinary kexec calls all reboot notifiers. Only crash kexec doesn't call them.
> I will implement a machine_ops.crash_shutdown callback.
>    

Thanks.

-- 
error compiling committee.c: too many arguments to function

