Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab1LMLhD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 06:37:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135Ab1LMLhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 06:37:00 -0500
Date: Tue, 13 Dec 2011 09:36:28 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Liu Ping Fan <kernelfans@gmail.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com,
        aliguori@us.ibm.com, gleb@redhat.com, jan.kiszka@web.de
Subject: Re: [PATCH v3] kvm: make vcpu life cycle separated from kvm instance
Message-ID: <20111213113628.GB31138@amt.cnet>
References: <20111209142303.GC31323@redhat.com>
 <1323657683-13934-1-git-send-email-kernelfans@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323657683-13934-1-git-send-email-kernelfans@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 10:41:23AM +0800, Liu Ping Fan wrote:
> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> 
> Currently, vcpu can be destructed only when kvm instance destroyed.
> Change this to vcpu's destruction taken when its refcnt is zero,
> and then vcpu MUST and CAN be destroyed before kvm's destroy.
> 
> Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/i8254.c     |   10 ++++--
>  arch/x86/kvm/i8259.c     |   12 +++++--
>  arch/x86/kvm/mmu.c       |    7 ++--
>  arch/x86/kvm/x86.c       |   54 +++++++++++++++++++----------------
>  include/linux/kvm_host.h |   71 ++++++++++++++++++++++++++++++++++++++++++----
>  virt/kvm/irq_comm.c      |    7 +++-
>  virt/kvm/kvm_main.c      |   62 +++++++++++++++++++++++++++++++++------
>  7 files changed, 170 insertions(+), 53 deletions(-)

This needs a full audit of paths that access vcpus. See for one example
bsp_vcpu pointer.


