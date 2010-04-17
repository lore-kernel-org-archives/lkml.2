Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab0DQTFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:05:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab0DQTFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:05:01 -0400
Message-ID: <4BCA0646.1000603@redhat.com>
Date: Sat, 17 Apr 2010 22:04:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Srivatsa Vaddagiri <vatsa.ml@gmail.com>,
       "Zhang, Xiantao" <xiantao.zhang@intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       "Yang, Xiaowei" <xiaowei.yang@intel.com>,
       "Dong, Eddie" <eddie.dong@intel.com>, "Li, Xin" <xin.li@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       vatsa@linux.vnet.ibm.com
Subject: Re: VM performance issue in KVM guests.
References: <EB8593BCECAB3D40A8248BE0B6400A3846903F4C@shzsmsx502.ccr.corp.intel.com>	 <4BC0D125.9050108@redhat.com>	 <EB8593BCECAB3D40A8248BE0B6400A384690419B@shzsmsx502.ccr.corp.intel.com>	 <4BC2C07B.4040607@redhat.com>	 <p2o2eae271004142158xaa5da968ueff0c2afe6894f9d@mail.gmail.com>	 <4BC6CBE3.8020207@redhat.com> <1271338398.1674.13.camel@laptop>
In-Reply-To: <1271338398.1674.13.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2010 04:33 PM, Peter Zijlstra wrote:
> On Thu, 2010-04-15 at 11:18 +0300, Avi Kivity wrote:
>    
>> Certainly that has even greater potential for Linux guests.  Note that
>> we spin on mutexes now, so we need to prevent preemption while the lock
>> owner is running.
>>      
> either that, or disable spinning on (para) virt kernels.

What would you do instead?

Note we can't disable spinning on Windows or pre 2.6.36 kernels.

> Para virt
> kernels could possibly extend the thing by also checking to see if the
> owner's vcpu is running.
>    

Certainly that's worth doing.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

