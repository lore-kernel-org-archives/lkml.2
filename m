Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab1CEHVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 02:21:32 -0500
Received: from gwu.lbox.cz ([62.245.111.132]:40031 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1CEHVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 02:21:30 -0500
Date: Sat, 5 Mar 2011 08:21:15 +0100
From: Nikola Ciprich <extmaillist@linuxbox.cz>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Glauber Costa <glommer@redhat.com>, Avi Kivity <avi@redhat.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        KVM list <kvm@vger.kernel.org>,
        Linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: regression - 2.6.36 -> 2.6.37 - kvm - 32bit SMP guests don't
	boot
Message-ID: <20110305072115.GA2166@nik-comp.lan>
References: <20110303210647.GA27691@nik-comp.lan> <4D700F09.9000002@redhat.com> <20110303220155.GB27691@nik-comp.lan> <4D7101AF.6060009@redhat.com> <20110304182733.GA2867@nik-comp.lan> <1299265762.11618.140.camel@mothafucka.localdomain> <20110304205512.GB2867@nik-comp.lan> <1299274906.11618.157.camel@mothafucka.localdomain> <20110304223640.GC2867@nik-comp.lan> <4D718F2D.6080105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D718F2D.6080105@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Antivirus: on lbxovapx by Kaspersky antivirus, 4722857 records (last update: 20110305)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> Can you try this patch to see if it fixes the problem?
You haven't read my replies, did you? ;-)
kvm_request_guest_time_update seems to have been
removed, and kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu)
seems to be used instead, adding it fixes the problem.
That's what I was going to use in the patch... :)

>
> Thanks,
>
> Zach

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 468fafa..ba05303 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1866,6 +1866,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	}
>  
>  	kvm_x86_ops->vcpu_load(vcpu, cpu);
> +	kvm_request_guest_time_update(vcpu);
>  	if (unlikely(vcpu->cpu != cpu)) {
>  		/* Make sure TSC doesn't go backwards */
>  		s64 tsc_delta = !vcpu->arch.last_host_tsc ? 0 :


-- 
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------
