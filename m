Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab1KTL2E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 06:28:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab1KTL2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 06:28:02 -0500
Message-ID: <4EC8E43E.1040902@redhat.com>
Date: Sun, 20 Nov 2011 13:27:58 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] KVM: sort memslots by its size and use line search
References: <4EC6226B.3080408@linux.vnet.ibm.com> <4EC62336.7040505@linux.vnet.ibm.com> <4EC8E3FB.7020108@redhat.com>
In-Reply-To: <4EC8E3FB.7020108@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2011 01:26 PM, Avi Kivity wrote:
> >
> >  int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id);
> >  void kvm_vcpu_uninit(struct kvm_vcpu *vcpu);
> > @@ -335,7 +340,14 @@ static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
> >  static inline struct kvm_memory_slot *
> >  id_to_memslot(struct kvm_memslots *slots, int id)
> >  {
> > -	return &slots->memslots[id];
> > +	int i;
> > +
> > +	for (i = 0; i < KVM_MEM_SLOTS_NUM; i++)
> > +		if (slots->memslots[i].id == id)
> > +			return &slots->memslots[i];
> > +
>
> Is that in any hot path?  we could make an array for doing this translation.

Never mind, I see patch 6.  I should have known you wouldn't leave it
like that.

-- 
error compiling committee.c: too many arguments to function

