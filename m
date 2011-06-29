Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab1F2LtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:49:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439Ab1F2Lsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:48:55 -0400
Date: Wed, 29 Jun 2011 14:48:50 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 04/22] KVM: x86: introduce vcpu_gva_to_gpa to cleanup
 the code
Message-ID: <20110629114850.GS491@redhat.com>
References: <4E01FBC9.3020009@cn.fujitsu.com>
 <4E01FC5B.9040809@cn.fujitsu.com>
 <4E0AE129.1070200@redhat.com>
 <4E0B04F1.1010807@cn.fujitsu.com>
 <4E0B0800.6030609@redhat.com>
 <4E0B0BCA.5050103@cn.fujitsu.com>
 <4E0B0BD6.4030609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0B0BD6.4030609@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 02:26:14PM +0300, Avi Kivity wrote:
> On 06/29/2011 02:26 PM, Xiao Guangrong wrote:
> >On 06/29/2011 07:09 PM, Avi Kivity wrote:
> >>  On 06/29/2011 01:56 PM, Xiao Guangrong wrote:
> >>>  On 06/29/2011 04:24 PM, Avi Kivity wrote:
> >>>
> >>>  >>   +static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
> >>>  >>   +               gpa_t *gpa, struct x86_exception *exception,
> >>>  >>   +               bool write)
> >>>  >>   +{
> >>>  >>   +    u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> >>>  >>   +
> >>>  >>   +    if (write)
> >>>  >>   +        access |= PFERR_WRITE_MASK;
> >>>  >
> >>>  >   Needs fetch as well so NX/SMEP can work.
> >>>  >
> >>>
> >>>  This function is only used by read/write emulator, execute permission is
> >>>  not needed for read/write, no?
> >>
> >>  It's not good to have a function which only implements the functionality partially.  It can later be misused.
> >>
> >>  You can pass the page-fault-error-code instead of the write parameter, I think it will be simpler.
> >>
> >
> >Actually, we will get the cache mmio info in this function, i think it is pure waste for other
> >access execpt mmio, what about change the function name to vcpu_gva_to_gpa_mmio?
> 
> Not too happy, but ok.
> 
I do plan to add fetching from MMIO.

--
			Gleb.
