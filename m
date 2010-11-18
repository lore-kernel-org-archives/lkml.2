Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab0KRHIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:08:41 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60538 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab0KRHIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:08:39 -0500
Message-ID: <4CE4D1F8.7090701@cn.fujitsu.com>
Date: Thu, 18 Nov 2010 15:12:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] KVM: MMU: don't drop spte if overwrite it from
 W to RO
References: <4CE355A0.6020907@cn.fujitsu.com> <4CE355CA.80106@cn.fujitsu.com> <20101117154241.GB18959@amt.cnet> <4CE3FB74.8050705@redhat.com>
In-Reply-To: <4CE3FB74.8050705@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-18 15:08:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-18 15:08:59,
	Serialize complete at 2010-11-18 15:08:59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 11:57 PM, Avi Kivity wrote:

>>>   set_pte:
>>>       update_spte(sptep, spte);
>>> +    /*
>>> +     * If we overwrite a writable spte with a read-only one we
>>> +     * should flush remote TLBs. Otherwise rmap_write_protect
>>> +     * will find a read-only spte, even though the writable spte
>>> +     * might be cached on a CPU's TLB.
>>> +     */
>>> +    if (is_writable_pte(entry)&&  !is_writable_pte(*sptep))
>>> +        kvm_flush_remote_tlbs(vcpu->kvm);
>> There is no need to flush on sync_page path since the guest is
>> responsible for it.
>>
> 
>  If we don't, the next rmap_write_protect() will incorrectly decide that
> there's no need to flush tlbs.
> 

Maybe it's not a problem if guest can flush all tlbs after overwrite it?
Marcelo, what's your comment about this?
