Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab1F2LKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:10:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753929Ab1F2LJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:09:59 -0400
Message-ID: <4E0B0800.6030609@redhat.com>
Date: Wed, 29 Jun 2011 14:09:52 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 04/22] KVM: x86: introduce vcpu_gva_to_gpa to cleanup
 the code
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FC5B.9040809@cn.fujitsu.com> <4E0AE129.1070200@redhat.com> <4E0B04F1.1010807@cn.fujitsu.com>
In-Reply-To: <4E0B04F1.1010807@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 01:56 PM, Xiao Guangrong wrote:
> On 06/29/2011 04:24 PM, Avi Kivity wrote:
>
> >>  +static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
> >>  +               gpa_t *gpa, struct x86_exception *exception,
> >>  +               bool write)
> >>  +{
> >>  +    u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
> >>  +
> >>  +    if (write)
> >>  +        access |= PFERR_WRITE_MASK;
> >
> >  Needs fetch as well so NX/SMEP can work.
> >
>
> This function is only used by read/write emulator, execute permission is
> not needed for read/write, no?

It's not good to have a function which only implements the functionality 
partially.  It can later be misused.

You can pass the page-fault-error-code instead of the write parameter, I 
think it will be simpler.

-- 
error compiling committee.c: too many arguments to function

