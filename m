Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab1F2K5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:57:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57799 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753037Ab1F2K5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:57:05 -0400
Message-ID: <4E0B0574.4010008@cn.fujitsu.com>
Date: Wed, 29 Jun 2011 18:59:00 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 05/22] KVM: x86: abstract the operation for read/write
 emulation
References: <4E01FBC9.3020009@cn.fujitsu.com> <4E01FC78.6060000@cn.fujitsu.com> <4E0AE457.7010507@redhat.com>
In-Reply-To: <4E0AE457.7010507@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 18:56:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-06-29 18:56:32,
	Serialize complete at 2011-06-29 18:56:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2011 04:37 PM, Avi Kivity wrote:

>> +struct read_write_emulator_ops {
>> +    int (*read_write_prepare)(struct kvm_vcpu *vcpu, void *val,
>> +                  int bytes);
>> +    int (*read_write_emulate)(struct kvm_vcpu *vcpu, gpa_t gpa,
>> +                  void *val, int bytes);
>> +    int (*read_write_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
>> +                   int bytes, void *val);
>> +    int (*read_write_exit_mmio)(struct kvm_vcpu *vcpu, gpa_t gpa,
>> +                    void *val, int bytes);
>> +    bool write;
>> +};
> 
> 
> Interesting!
> 
> This structure combines two unrelated operations, though.  One is the internals of the iteration on a virtual address that is split to various physical addresses.  The other is the interaction with userspace on mmio exits.  They should be split, but I think it's fine to do it in a later patch.  This series is long enough already.
> 
> I was also annoyed by the duplication.  They way I thought of fixing it is having gva_to_gpa() return two gpas, and having the access function accept gpa vectors.  The reason was so that we can implemented locked cross-page operations (which we now emulate as unlocked writes).
> 
> But I think we can do without it, and instead emulated locked cross-page ops by stalling all other vcpus while we write, or by unmapping the pages involved.  It isn't pretty but it doesn't need to be fast since it's a very rare operation.  So I think we can go with your approach.
> 

OK, i'll post it in the separate patchset, thanks, Avi.
