Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433Ab0GBRWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 13:22:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759382Ab0GBRWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 13:22:37 -0400
Date: Fri, 2 Jul 2010 14:03:03 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] KVM: MMU: combine guest pte read between walk and
 pte prefetch
Message-ID: <20100702170303.GC25969@amt.cnet>
References: <4C2C9DC0.8050607@cn.fujitsu.com>
 <4C2C9E6C.2040803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2C9E6C.2040803@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 09:55:56PM +0800, Xiao Guangrong wrote:
> Combine guest pte read between guest pte walk and pte prefetch
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  arch/x86/kvm/paging_tmpl.h |   48 ++++++++++++++++++++++++++++++-------------
>  1 files changed, 33 insertions(+), 15 deletions(-)

Can't do this, it can miss invlpg:

vcpu0			vcpu1
read guest ptes
			modify guest pte
			invlpg
instantiate stale 
guest pte

See how the pte is reread inside fetch with mmu_lock held.

Otherwise the patchset looks fine to me.

