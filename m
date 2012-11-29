Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab2K3Ubf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 15:31:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512Ab2K3UbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 15:31:16 -0500
Date: Thu, 29 Nov 2012 21:15:39 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: VMX: fix memory order between loading vmcs and
 clearing vmcs
Message-ID: <20121129231539.GA7409@amt.cnet>
References: <50B6093B.7040404@linux.vnet.ibm.com>
 <50B60976.7020905@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B60976.7020905@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 08:54:14PM +0800, Xiao Guangrong wrote:
> vmcs->cpu indicates whether it exists on the target cpu, -1 means the vmcs
> does not exist on any vcpu
> 
> If vcpu load vmcs with vmcs.cpu = -1, it can be directly added to cpu's percpu
> list. The list can be corrupted if the cpu prefetch the vmcs's list before
> reading vmcs->cpu. Meanwhile, we should remove vmcs from the list before
> making vmcs->vcpu == -1 be visible
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/vmx.c |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)

Applied, thanks.

