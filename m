Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469Ab0HUQMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 12:12:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0HUQMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 12:12:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Glauber Costa <glommer@redhat.com>
Subject: Re: [KVM timekeeping 30/35] IOCTL for setting TSC rate
Date: Sat, 21 Aug 2010 18:11:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.5.0; x86_64; ; )
Cc: Zachary Amsden <zamsden@redhat.com>, kvm@vger.kernel.org,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
References: <1282291669-25709-1-git-send-email-zamsden@redhat.com> <1282291669-25709-31-git-send-email-zamsden@redhat.com> <20100820175620.GJ2937@mothafucka.localdomain>
In-Reply-To: <20100820175620.GJ2937@mothafucka.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008211811.50962.arnd@arndb.de>
X-Provags-ID: V02:K0:V9Ce77I44vrvJswAEdf+K2zoJpLnd/EAw/wCFeykUkY
 lTThA3yEcV18C70+CcBMtnM2fkhPbU7i0CqT09+hwqGEjwLdeg
 40lI66CvuOv1F6qN4xlrO0RzfEr/AI7mndyFptOD5TKM20EjfS
 2EJuPyde2i1+ZdKcSup6bCpUy2DgOpLxjr6NnveBpxNH37BPsw
 uiohDuxQnaScdqh2A+Dog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 August 2010 19:56:20 Glauber Costa wrote:
> > @@ -675,6 +676,9 @@ struct kvm_clock_data {
> >  #define KVM_SET_PIT2              _IOW(KVMIO,  0xa0, struct kvm_pit_state2)
> >  /* Available with KVM_CAP_PPC_GET_PVINFO */
> >  #define KVM_PPC_GET_PVINFO     _IOW(KVMIO,  0xa1, struct kvm_ppc_pvinfo)
> > +/* Available with KVM_CAP_SET_TSC_RATE */
> > +#define KVM_X86_GET_TSC_RATE      _IOR(KVMIO,  0xa2, __u32)
> > +#define KVM_X86_SET_TSC_RATE      _IOW(KVMIO,  0xa3, __u32)
> 
> wrap this into a struct?

I don't think that would improve the code. Generally, we try to *avoid* using
structs in ioctl arguments, although KVM does have a precedent of using structs
there.

In fact, the code here could be simplified by using get_user/put_user on the
simple argument, which would not be possibly with a struct.

	Arnd
