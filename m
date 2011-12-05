Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab1LEJmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 04:42:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab1LEJmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 04:42:44 -0500
Date: Mon, 5 Dec 2011 11:42:40 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Liu ping fan <kernelfans@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aliguori@us.ibm.com, jan.kiszka@web.de
Subject: Re: [PATCH] kvm: make vcpu life cycle separated from kvm instance
Message-ID: <20111205094240.GE12507@redhat.com>
References: <4ED212A1.3060300@redhat.com>
 <1322807192-14147-1-git-send-email-kernelfans@gmail.com>
 <4EDB4A0D.1000609@redhat.com>
 <CAFgQCTujv7Ez23GySc4Bds8x9Pv8Ny59EohpN22de9wicztWrw@mail.gmail.com>
 <4EDC8F4B.7040308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDC8F4B.7040308@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 11:30:51AM +0200, Avi Kivity wrote:
> On 12/05/2011 07:29 AM, Liu ping fan wrote:
> > like this,
> > #define kvm_for_each_vcpu(idx, cnt, vcpup, kvm) \
> > 	for (idx = 0, cnt = 0, vcpup = kvm_get_vcpu(kvm, idx); \
> > 	     cnt < atomic_read(&kvm->online_vcpus) && \
> > 	     idx < KVM_MAX_VCPUS; \
> > 	     idx++, (vcpup == NULL)?:cnt++, vcpup = kvm_get_vcpu(kvm, idx)) \
> > 	     if (vcpup == NULL) \
> > 	          continue; \
> > 	     else
> >
> >
> > A little ugly, but have not thought a better way out :-)
> >
> 
> #define kvm_for_each_vcpu(vcpu, it) for (vcpu = kvm_fev_init(&it); vcpu;
> vcpu = kvm_fev_next(&it, vcpu))
> 
> Though that doesn't give a good place for rcu_read_unlock().
> 
> 
Why not use rculist to store vcpus and use list_for_each_entry_rcu()?

--
			Gleb.
