Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab2FRKQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 06:16:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab2FRKQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 06:16:41 -0400
Message-ID: <4FDF0005.3050300@redhat.com>
Date: Mon, 18 Jun 2012 13:16:37 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/6] KVM: introduce gfn_to_hva_read/kvm_read_hva/kvm_read_hva_atomic
References: <4FD6ADA6.40008@linux.vnet.ibm.com> <4FD6AE1B.7080501@linux.vnet.ibm.com>
In-Reply-To: <4FD6AE1B.7080501@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2012 05:48 AM, Xiao Guangrong wrote:
> This set of functions is only used to read data from host space, read is
> a special case in the later patch
> 
> 
> +/*
> + * The hva returned by this function is only allowed to be read.
> + * It should pair with kvm_read_hva() or kvm_read_hva_atomic().
> + */
> +static unsigned long gfn_to_hva_read(struct kvm *kvm, gfn_t gfn)
> +{
> +	return gfn_to_hva_many(gfn_to_memslot(kvm, gfn), gfn, NULL);
> +}
> +
> +static int kvm_read_hva(void *data, void *hva, int len)
> +{
> +	return __copy_from_user(data, (void __user *)hva, len);
> +
> +}
> +
> +static int kvm_read_hva_atomic(void *data, void *hva, int len)
> +{
> +	return __copy_from_user_inatomic(data, (void __user *)hva, len);
> +
> +}

Why cast to __user?  Make it __user in the first place.

Also these are just simple wrappers, why to them at all?



-- 
error compiling committee.c: too many arguments to function


