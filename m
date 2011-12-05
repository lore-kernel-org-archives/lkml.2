Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab1LEJa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:30:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26860 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab1LEJa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:30:57 -0500
Message-ID: <4EDC8F4B.7040308@redhat.com>
Date: Mon, 05 Dec 2011 11:30:51 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Liu ping fan <kernelfans@gmail.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, aliguori@us.ibm.com,
        gleb@redhat.com, jan.kiszka@web.de
Subject: Re: [PATCH] kvm: make vcpu life cycle separated from kvm instance
References: <4ED212A1.3060300@redhat.com> <1322807192-14147-1-git-send-email-kernelfans@gmail.com> <4EDB4A0D.1000609@redhat.com> <CAFgQCTujv7Ez23GySc4Bds8x9Pv8Ny59EohpN22de9wicztWrw@mail.gmail.com>
In-Reply-To: <CAFgQCTujv7Ez23GySc4Bds8x9Pv8Ny59EohpN22de9wicztWrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 07:29 AM, Liu ping fan wrote:
> like this,
> #define kvm_for_each_vcpu(idx, cnt, vcpup, kvm) \
> 	for (idx = 0, cnt = 0, vcpup = kvm_get_vcpu(kvm, idx); \
> 	     cnt < atomic_read(&kvm->online_vcpus) && \
> 	     idx < KVM_MAX_VCPUS; \
> 	     idx++, (vcpup == NULL)?:cnt++, vcpup = kvm_get_vcpu(kvm, idx)) \
> 	     if (vcpup == NULL) \
> 	          continue; \
> 	     else
>
>
> A little ugly, but have not thought a better way out :-)
>

#define kvm_for_each_vcpu(vcpu, it) for (vcpu = kvm_fev_init(&it); vcpu;
vcpu = kvm_fev_next(&it, vcpu))

Though that doesn't give a good place for rcu_read_unlock().



-- 
error compiling committee.c: too many arguments to function

