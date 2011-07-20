Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1GTLtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 07:49:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab1GTLte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 07:49:34 -0400
Date: Wed, 20 Jul 2011 13:49:33 +0200
From: Marcus Meissner <meissner@suse.de>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: quintela@redhat.com, Marcus Meissner <meissner@novell.com>, avi@redhat.com,
        mtosatti@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: Initialize all struct members to avoid stack information leak
Message-ID: <20110720114933.GD4856@suse.de>
References: <1311081438-1731-1-git-send-email-meissner@novell.com> <m3livutl3p.fsf@neno.neno> <4E25C113.9080500@siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E25C113.9080500@siemens.com>
Organization: SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendoerffer, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 07:38:27PM +0200, Jan Kiszka wrote:
> On 2011-07-19 16:12, Juan Quintela wrote:
> > Marcus Meissner <meissner@novell.com> wrote:
> >> Hi,
> >>
> >> Reported to us by Stephan Mueller of atsec.
> >>
> >> Several .pad struct members are not set to something, so they
> >> will leak stack content back to user space.
> >>
> >> Ciao, Marcus
> >>
> >> Reported-by: Stephan Mueller <smueller@atsec.com>
> >> Signed-off-by: Marcus Meissner <meissner@suse.de>
> >> ---
> >>  arch/x86/kvm/x86.c |    1 +
> >>  1 files changed, 1 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index 77c9d86..621ffb6 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -3002,6 +3002,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> >>  	case KVM_GET_VCPU_EVENTS: {
> >>  		struct kvm_vcpu_events events;
> >>  
> >> +		memset(&events, 0, sizeof(events));
> >>  		kvm_vcpu_ioctl_x86_get_vcpu_events(vcpu, &events);
> >>  
> >>  		r = -EFAULT;
> > 
> > Looking at arch/x86/include/asm/kvm.h & arch/x86/kvm/x86.c I can't see
> > what pad fields are not initialized.  My reading is that everything is
> > initialized in kvm_vcpu_ioctl_x86_get_vcpu_events().  What field are you
> > refering to?
> 
> Good question. Information leaks were once addressed by 97e69aa62f, and
> kvm_vcpu_events was not changed since then.

I was looking at old code, did not cross check if it is fixed in mainline.

Sorry for the noise.

Ciao, Marcus
