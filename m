Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab1GSOPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 10:15:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001Ab1GSOPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 10:15:12 -0400
From: Juan Quintela <quintela@redhat.com>
To: Marcus Meissner <meissner@novell.com>
Cc: avi@redhat.com, mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marcus Meissner <meissner@suse.de>
Subject: Re: [PATCH] kvm: Initialize all struct members to avoid stack information leak
In-Reply-To: <1311081438-1731-1-git-send-email-meissner@novell.com> (Marcus
	Meissner's message of "Tue, 19 Jul 2011 15:17:18 +0200")
References: <1311081438-1731-1-git-send-email-meissner@novell.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date: Tue, 19 Jul 2011 16:12:58 +0200
Message-ID: <m3livutl3p.fsf@neno.neno>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcus Meissner <meissner@novell.com> wrote:
> Hi,
>
> Reported to us by Stephan Mueller of atsec.
>
> Several .pad struct members are not set to something, so they
> will leak stack content back to user space.
>
> Ciao, Marcus
>
> Reported-by: Stephan Mueller <smueller@atsec.com>
> Signed-off-by: Marcus Meissner <meissner@suse.de>
> ---
>  arch/x86/kvm/x86.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 77c9d86..621ffb6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3002,6 +3002,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>  	case KVM_GET_VCPU_EVENTS: {
>  		struct kvm_vcpu_events events;
>  
> +		memset(&events, 0, sizeof(events));
>  		kvm_vcpu_ioctl_x86_get_vcpu_events(vcpu, &events);
>  
>  		r = -EFAULT;

Looking at arch/x86/include/asm/kvm.h & arch/x86/kvm/x86.c I can't see
what pad fields are not initialized.  My reading is that everything is
initialized in kvm_vcpu_ioctl_x86_get_vcpu_events().  What field are you
refering to?

Later, Juan.
