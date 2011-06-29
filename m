Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab1F2KwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:52:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63361 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754812Ab1F2KwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:52:04 -0400
Message-ID: <4E0B0447.9030003@cn.fujitsu.com>
Date: Wed, 29 Jun 2011 18:53:59 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 03/22] KVM: x86: fix broken read emulation spans a
 page boundary
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FC39.2080709@cn.fujitsu.com> <4E0AE088.2070703@redhat.com>
In-Reply-To: <4E0AE088.2070703@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 18:51:30,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 18:51:30,
	Serialize complete at 2011-06-29 18:51:30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 04:21 PM, Avi Kivity wrote:

>>
>> -    if (kvm_read_guest_virt(ctxt, addr, val, bytes, exception)
>> -        == X86EMUL_CONTINUE)
>> +    if (!kvm_read_guest(vcpu->kvm, gpa, val, bytes))
>>           return X86EMUL_CONTINUE;
> 
> This doesn't perform the cpl check.
> 

Firstly, it calls kvm_mmu_gva_to_gpa_read to translate gva to gpa, and cpl
is checked in this function, it is not enough?

> I suggest dropping this part for now and doing it later.
> 

OK, i will post this part in the separate patchset. :-)
