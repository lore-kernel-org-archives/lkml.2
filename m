Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2F0Jxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:53:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab2F0Jxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:53:44 -0400
Date: Wed, 27 Jun 2012 12:53:45 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH v2 2/6] kvm: Add missing KVM_IRQFD API documentation
Message-ID: <20120627095345.GI17507@redhat.com>
References: <20120627044758.23698.249.stgit@bling.home>
 <20120627050910.23698.82393.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627050910.23698.82393.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:09:17PM -0600, Alex Williamson wrote:
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> 
>  Documentation/virtual/kvm/api.txt |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 310fe50..ea9edce 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1965,6 +1965,22 @@ return the hash table order in the parameter.  (If the guest is using
>  the virtualized real-mode area (VRMA) facility, the kernel will
>  re-create the VMRA HPTEs on the next KVM_RUN of any vcpu.)
>  
> +4.76 KVM_IRQFD
> +
> +Capability: KVM_CAP_IRQFD
> +Architectures: x86
> +Type: vm ioctl
> +Parameters: struct kvm_irqfd (in)
> +Returns: 0 on success, -1 on error
> +
> +Allows setting an eventfd to directly trigger a guest interrupt.
> +kvm_irqfd.fd specifies the file descriptor to use as the eventfd and
> +kvm_irqfd.gsi specifies the irqchip pin toggled by this event.  When
> +an event is tiggered on the eventfd, an interrupt is injected into
> +the guest using the specified gsi pin.  The irqfd is removed using
> +the KVM_IRQFD_FLAG_DEASSIGN flag, specifying both kvm_irqfd.fd
> +and kvm_irqfd.gsi.
> +
>  
>  5. The kvm_run structure
>  ------------------------
