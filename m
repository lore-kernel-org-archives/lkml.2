Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1ATDDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 22:03:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52998 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752071Ab1ATDDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 22:03:09 -0500
Message-ID: <4D37A603.4040602@cn.fujitsu.com>
Date: Thu, 20 Jan 2011 11:03:31 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 1/3] KVM: fix rcu usage warning in kvm_arch_vcpu_ioctl_set_sregs()
References: <4D2D5AA6.9080804@cn.fujitsu.com> <4D3673A7.4090402@cn.fujitsu.com> <20110119181347.GA13142@amt.cnet>
In-Reply-To: <20110119181347.GA13142@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-20 11:02:34,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-01-20 11:02:35,
	Serialize complete at 2011-01-20 11:02:35
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 02:13 AM, Marcelo Tosatti wrote:
> On Wed, Jan 19, 2011 at 01:16:23PM +0800, Xiao Guangrong wrote:
>> On 01/12/2011 03:39 PM, Xiao Guangrong wrote:
>>> Fix:
>>>
>>> [ 1001.499596] ===================================================
>>> [ 1001.499599] [ INFO: suspicious rcu_dereference_check() usage. ]
>>> [ 1001.499601] ---------------------------------------------------
>>> [ 1001.499604] include/linux/kvm_host.h:301 invoked rcu_dereference_check() without protection!
>>> 	......
>>> [ 1001.499636] Pid: 6035, comm: qemu-system-x86 Not tainted 2.6.37-rc6+ #62
>>> [ 1001.499638] Call Trace:
>>> [ 1001.499644]  [] lockdep_rcu_dereference+0x9d/0xa5
>>> [ 1001.499653]  [] gfn_to_memslot+0x8d/0xc8 [kvm]
>>> [ 1001.499661]  [] gfn_to_hva+0x16/0x3f [kvm]
>>> [ 1001.499669]  [] kvm_read_guest_page+0x1e/0x5e [kvm]
>>> [ 1001.499681]  [] kvm_read_guest_page_mmu+0x53/0x5e [kvm]
>>> [ 1001.499699]  [] load_pdptrs+0x3f/0x9c [kvm]
>>> [ 1001.499705]  [] ? vmx_set_cr0+0x507/0x517 [kvm_intel]
>>> [ 1001.499717]  [] kvm_arch_vcpu_ioctl_set_sregs+0x1f3/0x3c0 [kvm]
>>> [ 1001.499727]  [] kvm_vcpu_ioctl+0x6a5/0xbc5 [kvm]
>>>
>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>>
>> Ping ...?
> 
> Applied this fix. For the make_all_cpus_request optimization, can you
> show numbers with this new version? Because now there is LOCK# similarly
> to the spinlock.

Marcelo,

Sure :-), there is the simply test result of kernbench:

Before patch:

real    5m6.493s                                                                
user    3m57.847s                                                               
sys     9m7.115s 

real    5m1.750s                                                                
user    4m0.109s                                                                
sys     9m10.192s       


After patch:
real    5m0.140s                                                                
user    3m57.956s                                                               
sys     8m58.339s  

real    4m56.314s                                                               
user    4m0.303s                                                                
sys     8m55.774s  

 

