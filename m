Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2DNCAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 22:00:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64051 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2DNCAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:00:38 -0400
Date: Sat, 14 Apr 2012 11:00:31 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 04/16] KVM: MMU: return bool in __rmap_write_protect
Message-Id: <20120414110031.38450bebfe712215f01d529f@gmail.com>
In-Reply-To: <4F87FBC1.5010907@linux.vnet.ibm.com>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
	<4F87FBC1.5010907@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 18:11:13 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> The reture value of __rmap_write_protect is either 1 or 0, use
> true/false instead of these

...

> @@ -1689,7 +1690,7 @@ static void mmu_sync_children(struct kvm_vcpu *vcpu,
> 
>  	kvm_mmu_pages_init(parent, &parents, &pages);
>  	while (mmu_unsync_walk(parent, &pages)) {
> -		int protected = 0;
> +		bool protected = false;
> 
>  		for_each_sp(pages, sp, parents, i)
>  			protected |= rmap_write_protect(vcpu->kvm, sp->gfn);

Isn't this the reason we prefer int to bool?

Not sure people like to use |= with boolean.

	Takuya
