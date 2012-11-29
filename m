Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab2K2AW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:22:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745Ab2K2AW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:22:26 -0500
Date: Wed, 28 Nov 2012 22:06:02 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: VMX: fix invalid cpu passed to
 smp_call_function_single
Message-ID: <20121129000602.GB17264@amt.cnet>
References: <50B6093B.7040404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B6093B.7040404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 08:53:15PM +0800, Xiao Guangrong wrote:
> In loaded_vmcs_clear, loaded_vmcs->cpu is the fist parameter passed to
> smp_call_function_single, if the target cpu is downing (doing cpu hot remove),
> loaded_vmcs->cpu can become -1 then -1 is passed to smp_call_function_single
> 
> It can be triggered when vcpu is being destroyed, loaded_vmcs_clear is called
> in the preemptionable context
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/vmx.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)

Applied, thanks.

