Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1CJKWr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:22:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab1CJKWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:22:45 -0500
Message-ID: <4D78A66E.50209@redhat.com>
Date: Thu, 10 Mar 2011 12:22:38 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] KVM: fix rcu usage in init_rmode_* functions
References: <4D772F10.3020302@cn.fujitsu.com>
In-Reply-To: <4D772F10.3020302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2011 09:41 AM, Xiao Guangrong wrote:
> fix:
> [ 3494.671786] stack backtrace:
> [ 3494.671789] Pid: 10527, comm: qemu-system-x86 Not tainted 2.6.38-rc6+ #23
> [ 3494.671790] Call Trace:
> [ 3494.671796]  [] ? lockdep_rcu_dereference+0x9d/0xa5
> [ 3494.671826]  [] ? kvm_memslots+0x6b/0x73 [kvm]
> [ 3494.671834]  [] ? gfn_to_memslot+0x16/0x4f [kvm]
> [ 3494.671843]  [] ? gfn_to_hva+0x16/0x27 [kvm]
> [ 3494.671851]  [] ? kvm_write_guest_page+0x31/0x83 [kvm]
> [ 3494.671861]  [] ? kvm_clear_guest_page+0x1a/0x1c [kvm]
> [ 3494.671867]  [] ? vmx_set_tss_addr+0x83/0x122 [kvm_intel]
>
> and:
> [ 8328.789599] stack backtrace:
> [ 8328.789601] Pid: 18736, comm: qemu-system-x86 Not tainted 2.6.38-rc6+ #23
> [ 8328.789603] Call Trace:
> [ 8328.789609]  [] ? lockdep_rcu_dereference+0x9d/0xa5
> [ 8328.789621]  [] ? kvm_memslots+0x6b/0x73 [kvm]
> [ 8328.789628]  [] ? gfn_to_memslot+0x16/0x4f [kvm]
> [ 8328.789635]  [] ? gfn_to_hva+0x16/0x27 [kvm]
> [ 8328.789643]  [] ? kvm_write_guest_page+0x31/0x83 [kvm]
> [ 8328.789699]  [] ? kvm_clear_guest_page+0x1a/0x1c [kvm]
> [ 8328.789713]  [] ? vmx_create_vcpu+0x316/0x3c8 [kvm_intel]
>

Applied all four patches, thanks.

-- 
error compiling committee.c: too many arguments to function

