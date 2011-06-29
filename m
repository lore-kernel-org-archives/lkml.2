Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1F2Ky5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:54:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56437 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab1F2Kyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:54:53 -0400
Message-ID: <4E0B04F1.1010807@cn.fujitsu.com>
Date: Wed, 29 Jun 2011 18:56:49 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 04/22] KVM: x86: introduce vcpu_gva_to_gpa to cleanup
 the code
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FC5B.9040809@cn.fujitsu.com> <4E0AE129.1070200@redhat.com>
In-Reply-To: <4E0AE129.1070200@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 18:54:20,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 18:54:20,
	Serialize complete at 2011-06-29 18:54:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 04:24 PM, Avi Kivity wrote:

>> +static int vcpu_gva_to_gpa(struct kvm_vcpu *vcpu, unsigned long gva,
>> +               gpa_t *gpa, struct x86_exception *exception,
>> +               bool write)
>> +{
>> +    u32 access = (kvm_x86_ops->get_cpl(vcpu) == 3) ? PFERR_USER_MASK : 0;
>> +
>> +    if (write)
>> +        access |= PFERR_WRITE_MASK;
> 
> Needs fetch as well so NX/SMEP can work.
> 

This function is only used by read/write emulator, execute permission is
not needed for read/write, no?
