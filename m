Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab0LZMUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 07:20:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab0LZMUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 07:20:51 -0500
Message-ID: <4D17331A.6090802@redhat.com>
Date: Sun, 26 Dec 2010 14:20:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: MMU: handle 'map_writable' in set_spte() function
References: <4D130383.30406@cn.fujitsu.com> <4D1303B9.3080801@cn.fujitsu.com>
In-Reply-To: <4D1303B9.3080801@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2010 10:09 AM, Xiao Guangrong wrote:
> Move the operation of 'writable' to set_spte() to clean up code
>

Thanks, applied.
> @@ -809,12 +806,8 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>
>   		nr_present++;
>   		pte_access = sp->role.access&  FNAME(gpte_access)(vcpu, gpte);
> -		if (!(sp->spt[i]&  SPTE_HOST_WRITEABLE)) {
> -			pte_access&= ~ACC_WRITE_MASK;
> -			host_writable = 0;
> -		} else {
> -			host_writable = 1;
> -		}
> +		host_writable = !!(sp->spt[i]&  SPTE_HOST_WRITEABLE);
> + 		

Note, !! is unneeded when assigning to a boolean variable.  I removed it.

-- 
error compiling committee.c: too many arguments to function

