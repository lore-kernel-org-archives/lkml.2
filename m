Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab2DNC0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 22:26:41 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:47084 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860Ab2DNC0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:26:39 -0400
Date: Sat, 14 Apr 2012 11:26:35 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 05/16] KVM: MMU: abstract spte write-protect
Message-Id: <20120414112635.0940cc4628320821a88646fc@gmail.com>
In-Reply-To: <4F87FBE1.200@linux.vnet.ibm.com>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
	<4F87FBE1.200@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 18:11:45 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> +/* Return true if the spte is dropped. */

Return value does not correspond with the function name so it is confusing.

People may think that true means write protection has been done.

> +static bool spte_write_protect(struct kvm *kvm, u64 *sptep, bool large,
> +			       bool *flush)
> +{
> +	u64 spte = *sptep;
> +
> +	if (!is_writable_pte(spte))
> +		return false;
> +
> +	*flush |= true;
> +
> +	if (large) {
> +		pgprintk("rmap_write_protect(large): spte %p %llx\n",
> +			 spte, *spte);
> +		BUG_ON(!is_large_pte(spte));
> +
> +		drop_spte(kvm, sptep);
> +		--kvm->stat.lpages;
> +		return true;
> +	}

This suggests we should use separate functions?

	Takuya
