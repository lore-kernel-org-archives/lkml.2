Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1F2LTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 07:19:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403Ab1F2LTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 07:19:34 -0400
Message-ID: <4E0B0A40.3020302@redhat.com>
Date: Wed, 29 Jun 2011 14:19:28 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 03/22] KVM: x86: fix broken read emulation spans a
 page boundary
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FC39.2080709@cn.fujitsu.com> <4E0AE088.2070703@redhat.com> <4E0B0447.9030003@cn.fujitsu.com>
In-Reply-To: <4E0B0447.9030003@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 01:53 PM, Xiao Guangrong wrote:
> On 06/29/2011 04:21 PM, Avi Kivity wrote:
>
> >>
> >>  -    if (kvm_read_guest_virt(ctxt, addr, val, bytes, exception)
> >>  -        == X86EMUL_CONTINUE)
> >>  +    if (!kvm_read_guest(vcpu->kvm, gpa, val, bytes))
> >>            return X86EMUL_CONTINUE;
> >
> >  This doesn't perform the cpl check.
> >
>
> Firstly, it calls kvm_mmu_gva_to_gpa_read to translate gva to gpa, and cpl
> is checked in this function, it is not enough?

You are right, it is enough.  I don't know how I missed it.

-- 
error compiling committee.c: too many arguments to function

