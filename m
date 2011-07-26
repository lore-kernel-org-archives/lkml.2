Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1GZRc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 13:32:59 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:36874 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab1GZRcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 13:32:51 -0400
Date: Tue, 26 Jul 2011 21:28:09 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Alexander Graf <agraf@suse.de>
Cc: Jan Kiszka <jan.kiszka@web.de>, kernel-janitors@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v2] x86: kvm: x86: fix information leak to userland
Message-ID: <20110726172809.GA23970@albatros>
References: <1288447871-7715-1-git-send-email-segooon@gmail.com>
 <4CCC2D11.7090109@web.de>
 <20101030153147.GA14169@albatros>
 <4CCC3DC2.6090505@web.de>
 <20101030185447.GA7629@albatros>
 <ABD7343A-6440-4CC0-B8B0-9D27EF0291B0@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ABD7343A-6440-4CC0-B8B0-9D27EF0291B0@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander,

On Tue, Jul 26, 2011 at 19:05 +0200, Alexander Graf wrote:
> > @@ -2623,6 +2626,7 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
> > 	dbgregs->dr6 = vcpu->arch.dr6;
> > 	dbgregs->dr7 = vcpu->arch.dr7;
> > 	dbgregs->flags = 0;
> > +	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
> > }
> > 
> > static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
> > @@ -3106,6 +3110,7 @@ static int kvm_vm_ioctl_get_pit2(struct kvm *kvm, struct kvm_pit_state2 *ps)
> > 		sizeof(ps->channels));
> > 	ps->flags = kvm->arch.vpit->pit_state.flags;
> > 	mutex_unlock(&kvm->arch.vpit->pit_state.lock);
> > +	memset(&ps->reserved, 0, sizeof(ps->reserved));
> 
> struct kvm_pit_state2 {
>         struct kvm_pit_channel_state channels[3];
>         __u32 flags;
>         __u32 reserved[9];
> };
> 
> So memset(&ps->reserved) would give you the a __u32 **, no? Same goes for all the other array sets in here. Or am I understanding some C logic wrong? :)

No, the array name and an address of the array give the same address.  I
could use ps->reserved instead of &ps->reserved, but it is a question of
coding style.  I got opposite opinions on this question from different
maintainers.

Another thing is that sizeof() of the array name and the pointer to the
first array element differ.  But I used sizeof(array) here, so it should
be correct.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
