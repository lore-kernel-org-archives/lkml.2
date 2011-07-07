Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1GGIva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 04:51:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab1GGIv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 04:51:28 -0400
Date: Thu, 7 Jul 2011 05:18:35 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 16/19] KVM: MMU: lockless walking shadow page table
Message-ID: <20110707081835.GC8334@amt.cnet>
References: <4E0C3178.2080603@cn.fujitsu.com>
 <4E0C3337.5040304@cn.fujitsu.com>
 <20110706180859.GB9820@amt.cnet>
 <4E14B6D6.4020902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E14B6D6.4020902@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 03:26:14AM +0800, Xiao Guangrong wrote:
> On 07/07/2011 02:08 AM, Marcelo Tosatti wrote:
> 
> >> +static void free_pages_rcu(struct rcu_head *head)
> >> +{
> >> +	struct kvm_mmu_page *next, *sp;
> >> +
> >> +	sp = container_of(head, struct kvm_mmu_page, rcu);
> >> +	while (sp) {
> >> +		if (!list_empty(&sp->link))
> >> +			next = list_first_entry(&sp->link,
> >> +				      struct kvm_mmu_page, link);
> >> +		else
> >> +			next = NULL;
> >> +		kvm_mmu_free_page(sp);
> >> +		sp = next;
> >> +	}
> >> +}
> > 
> > There is no need for this while loop.
> > 
> 
> The while loop is needed, since many shadow pages can be freed together in
> the rcu context, on commit_zap_page path, we only remove the list head, and
> the shadow page is still listed.

Right.

