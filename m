Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0DLQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 12:09:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab0DLQJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 12:09:55 -0400
Message-ID: <4BC345CE.9070501@redhat.com>
Date: Mon, 12 Apr 2010 19:09:50 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: wzt.wzt@gmail.com
CC: linux-kernel@vger.kernel.org, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: remove unused code in kvm_coalesced_mmio_init()
References: <20100412093452.GB2707@localhost.localdomain>
In-Reply-To: <20100412093452.GB2707@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2010 12:34 PM, wzt.wzt@gmail.com wrote:
> ret is already set as ENOMEM before, so the second ret = -ENOMEM; can be removed.
>
>
> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
> index 5169736..c0dcfb7 100644
> --- a/virt/kvm/coalesced_mmio.c
> +++ b/virt/kvm/coalesced_mmio.c
> @@ -101,7 +101,6 @@ int kvm_coalesced_mmio_init(struct kvm *kvm)
>   		goto out_err;
>   	kvm->coalesced_mmio_ring = page_address(page);
>
> -	ret = -ENOMEM;
>   	dev = kzalloc(sizeof(struct kvm_coalesced_mmio_dev), GFP_KERNEL);
>   	if (!dev)
>   		goto out_free_page;
>    

I prefer to keep it there and let the compiler do the elimination.  
Otherwise inserting any code in the middle may cause a bug (the 
assignment is logically part of the code block, it only matches the 
previous one by accident).

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

