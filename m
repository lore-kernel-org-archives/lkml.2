Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212Ab2BZLnz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 06:43:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51468 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab2BZLnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 06:43:52 -0500
Subject: Re: Current kernel fails to compile with KVM on PowerPC
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=windows-1252
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <20120225145115.GB22460@alea.gnuu.de>
Date: Sun, 26 Feb 2012 12:43:49 +0100
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm list <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <3E36BEF4-E15F-410A-82C1-A8EB17AEF0DA@suse.de>
References: <20111107194838.GA23558@alea.gnuu.de> <20111122200414.GA28205@alea.gnuu.de> <E687C074-57CC-41AD-BA0E-0C957679E900@suse.de> <20120220173844.GA2546@alea.gnuu.de> <8F6910F4-7F2E-44FE-B0C2-1A2FF95888D2@suse.de> <20120221083213.GA19059@alea.gnuu.de> <20120225145115.GB22460@alea.gnuu.de>
To: =?iso-8859-1?Q?J=F6rg_Sommer?= <joerg@alea.gnuu.de>
X-Mailer: Apple Mail (2.1257)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 25.02.2012, at 15:51, Jörg Sommer wrote:

> Jörg Sommer hat am Tue 21. Feb, 09:32 (+0100) geschrieben:
>> Alexander Graf hat am Mon 20. Feb, 22:27 (+0100) geschrieben:
>>> On 20.02.2012, at 18:38, Jörg Sommer wrote:
>>>> Alexander Graf hat am Tue 22. Nov, 22:29 (+0100) geschrieben:
>>>>> On 22.11.2011, at 21:04, Jörg Sommer wrote:
>>>>>> [1] »kernel BUG at include/linux/kvm_host.h:603!«
>>>>>> http://www.mail-archive.com/kvm@vger.kernel.org/msg61433.html
>>>>> 
>>>>> This is unfortunately still there. It's because of preemption being
>>>>> enabled. Please just use CONFIG_PREEMPT_NONE for the time being
>>>> 
>>>> This doesn't help. I've build with CONFIG_PREEMPT_NONE, but I'm getting
>>>> this Oops, when I start qemu.
>>> 
>>> Could you please try git://git.kernel.org/pub/scm/virt/kvm/kvm.git? I
>>> fixed a bunch of things with preemption since then and it definitely
>>> worked for me. If it still fails in that tree, I can try again to
>>> reproduce it :).
>> 
>> This kernel (e9badff4b38a3f8b2c20aa8a30db210caf85a497) fails to build:
>> 
>>  CC [M]  arch/powerpc/kvm/book3s_pr.o
>> arch/powerpc/kvm/book3s_pr.c: In function ‘kvm_vcpu_ioctl_get_one_reg’:
>> arch/powerpc/kvm/book3s_pr.c:883:45: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:883:80: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:883:284: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:883:327: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:883:459: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:883:748: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:883:1112: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:883:1476: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:883:1867: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c: In function ‘kvm_vcpu_ioctl_set_one_reg’:
>> arch/powerpc/kvm/book3s_pr.c:898:79: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:898:114: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:898:319: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:898:364: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:898:502: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:898:591: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> arch/powerpc/kvm/book3s_pr.c:898:2061: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
>> cc1: all warnings being treated as errors
>> make[3]: *** [arch/powerpc/kvm/book3s_pr.o] Fehler 1
>> make[2]: *** [arch/powerpc/kvm] Fehler 2
>> make[2]: *** Warte auf noch nicht beendete Prozesse...
> 
> The culprit is this patch:
> 
> commit 784f1782e3c9cab310d6c513df966c547c3f17aa
> Author: Alexander Graf <agraf@suse.de>
> Date:   Wed Sep 14 21:45:23 2011 +0200
> 
>    KVM: PPC: Add support for explicit HIOR setting
> 
>    Until now, we always set HIOR based on the PVR, but this is just wrong.
>    Instead, we should be setting HIOR explicitly, so user space can decide
>    what the initial HIOR value is - just like on real hardware.
> 
>    We keep the old PVR based way around for backwards compatibility, but
>    once user space uses the SET_ONE_REG based method, we drop the PVR logic.
> 
>    Signed-off-by: Alexander Graf <agraf@suse.de>
> 
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 089c61b..5985209 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -212,6 +212,7 @@ int kvm_dev_ioctl_check_extension(long ext)
>        case KVM_CAP_PPC_BOOKE_SREGS:
> #else
>        case KVM_CAP_PPC_SEGSTATE:
> +       case KVM_CAP_PPC_HIOR:
>        case KVM_CAP_PPC_PAPR:
> #endif
>        case KVM_CAP_PPC_UNSET_IRQ:
> @@ -652,6 +653,11 @@ static int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu,
>        int r = -EINVAL;
> 
>        switch (reg->id) {
> +#ifdef CONFIG_PPC_BOOK3S
> +       case KVM_REG_PPC_HIOR:
> +               r = put_user(to_book3s(vcpu)->hior, (u64 __user *)reg->addr);
> +               break;
> +#endif
>        default:
>                break;
>        }
> @@ -665,6 +671,13 @@ static int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu,
>        int r = -EINVAL;
> 
>        switch (reg->id) {
> +#ifdef CONFIG_PPC_BOOK3S
> +       case KVM_ONE_REG_PPC_HIOR:
> +               r = get_user(to_book3s(vcpu)->hior, (u64 __user *)reg->addr);
> +               if (!r)
> +                       to_book3s(vcpu)->hior_explicit = true;
> +               break;
> +#endif
>        default:
>                break;
>        }
> 
> Later, this code was moved to arch/powerpc/kvm/book3s_pr.c by
> 
> commit c6afb78d175ae6cf99f4191fbb258e54478b0371
> Author: Paul Mackerras <paulus@samba.org>
> Date:   Mon Dec 12 12:26:50 2011 +0000
> 
>    KVM: PPC: Move kvm_vcpu_ioctl_[gs]et_one_reg down to platform-specific code

Yikes. Does this patch work for you?



diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index ee222ec..f329eae 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -880,7 +880,8 @@ int kvm_vcpu_ioctl_get_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
 
        switch (reg->id) {
        case KVM_REG_PPC_HIOR:
-               r = put_user(to_book3s(vcpu)->hior, (u64 __user *)reg->addr);
+               r = put_user(to_book3s(vcpu)->hior,
+                            (u64 __user *)(long)reg->addr);
                break;
        default:
                break;
@@ -895,7 +896,8 @@ int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu *vcpu, struct kvm_one_reg *reg)
 
        switch (reg->id) {
        case KVM_REG_PPC_HIOR:
-               r = get_user(to_book3s(vcpu)->hior, (u64 __user *)reg->addr);
+               r = get_user(to_book3s(vcpu)->hior,
+                            (u64 __user *)(long)reg->addr);
                if (!r)
                        to_book3s(vcpu)->hior_explicit = true;
                break;

