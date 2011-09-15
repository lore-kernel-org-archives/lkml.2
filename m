Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1IOExt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 00:53:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63553 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1IOExs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 00:53:48 -0400
Message-ID: <4E718567.9080702@cn.fujitsu.com>
Date: Thu, 15 Sep 2011 12:56:07 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 03/11] KVM: x86: retry non-page-table writing instruction
References: <4E5C4C20.3000403@cn.fujitsu.com> <4E5C4C5C.8030602@cn.fujitsu.com> <4E6F34CF.1060302@redhat.com> <4E6F9FD2.4010407@cn.fujitsu.com> <4E707991.10705@redhat.com> <4E707FBB.5030809@cn.fujitsu.com>
In-Reply-To: <4E707FBB.5030809@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-15 12:52:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-09-15 12:52:27,
	Serialize complete at 2011-09-15 12:52:27
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2011 06:19 PM, Xiao Guangrong wrote:
> On 09/14/2011 05:53 PM, Avi Kivity wrote:
>> On 09/13/2011 09:24 PM, Xiao Guangrong wrote:
>>>>>
>>>>>  +static bool retry_instruction(struct x86_emulate_ctxt *ctxt,
>>>>>  +                  unsigned long cr2,  int emulation_type)
>>>>>  +{
>>>>>  +    if (!vcpu->arch.mmu.direct_map&&   !mmu_is_nested(vcpu))
>>>>>  +        gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2, NULL);
>>>>
>>>>  If mmu_is_nested() cr2 is an ngpa, we have to translate it to a gpa, no?
>>>>
>>>
>>> Yeah, will fix it.
>>>
>>> And this bug also exists in the current code: it always uses L2 gpa to emulate
>>> write operation.
>>
>> Can you please send this fix separately, so it can be backported if needed?
>>
> 
> Sure, i will do it as soon as possible. :-)

I am so sorry, the current code is good, it has already translated L2 gpa to
L1 gpa:

vcpu->arch.nested_mmu.translate_gpa = translate_nested_gpa;

Please ignore it.
