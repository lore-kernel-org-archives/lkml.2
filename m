Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2FXIee (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 04:34:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab2FXIed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 04:34:33 -0400
Date: Sun, 24 Jun 2012 11:34:34 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        jan.kiszka@siemens.com
Subject: Re: [PATCH 2/4] kvm: Add missing KVM_IRQFD API documentation
Message-ID: <20120624083434.GC1712@redhat.com>
References: <20120622220040.9858.43665.stgit@bling.home>
 <20120622221541.9858.37619.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120622221541.9858.37619.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 04:15:50PM -0600, Alex Williamson wrote:
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  Documentation/virtual/kvm/api.txt |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 310fe50..9b4cb2b 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -1965,6 +1965,23 @@ return the hash table order in the parameter.  (If the guest is using
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
> +Allows setting an eventfd to directly trigger a guest interrupt
> +kvm_irqfd.fd specifies the file descriptor to use as the eventfd and
> +kvm_irqfd.gsi specifies the irqchip pin toggled by this event.  By
> +default this interface only supports edge triggered interrupts,
> +meaning the specified gsi is asserted and immediately de-asserted
> +when the eventfd is triggered.

That's a bit confusing. This assert/deassert only has effect for level.
Do we or do we not want to maintain this assert/deassert behaviour
for level irqfds? If yes we shouldn't say it's unsupported if
no we should not document it.

Gleb, Avi, any thoughts?

>  Specifying KVM_IRQFD_FLAG_DEASSIGN
> +removes the previously set irqfd matching both kvm_irqfd.fd and
> +kvm_irqfd.gsi.
> +
>  
>  5. The kvm_run structure
>  ------------------------
