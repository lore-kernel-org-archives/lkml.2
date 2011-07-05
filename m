Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1GEVIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 17:08:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab1GEVIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 17:08:50 -0400
Date: Tue, 5 Jul 2011 16:27:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 05/19] KVM: MMU: optimize to handle dirty bit
Message-ID: <20110705192703.GB24417@amt.cnet>
References: <4E0C3178.2080603@cn.fujitsu.com>
 <4E0C320A.8080104@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0C320A.8080104@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 04:21:30PM +0800, Xiao Guangrong wrote:
> If dirty bit is not set, we can make the pte access read-only to avoid handing
> dirty bit everywhere
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

> -static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
> +static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte,
> +				   bool last)
>  {
>  	unsigned access;
>  
>  	access = (gpte & (PT_WRITABLE_MASK | PT_USER_MASK)) | ACC_EXEC_MASK;
> +	if (last && !is_dirty_gpte(gpte))
> +		access &= ~ACC_WRITE_MASK;
> +

What if the walker marks the dirty bit on the gpte?

