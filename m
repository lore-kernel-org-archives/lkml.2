Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab0GNBM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 21:12:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63992 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751137Ab0GNBMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 21:12:54 -0400
Message-ID: <4C3D0E27.6050905@cn.fujitsu.com>
Date: Wed, 14 Jul 2010 09:08:55 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/4] KVM: MMU: fix forgot reserved bits check in speculative
 path
References: <4C3C3518.7080505@cn.fujitsu.com> <20100713212801.GA6370@amt.cnet>
In-Reply-To: <20100713212801.GA6370@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Marcelo Tosatti wrote:
		entry = *spte;
>>  			mmu_pte_write_zap_pte(vcpu, sp, spte);
>> +
>> +			if (!!is_pae(vcpu) != sp->role.cr4_pae ||
>> +			      is_nx(vcpu) != sp->role.nxe)
>> +				continue;
>> +
> 
> This breaks remote_flush assignment below.

Ah, Oops, will fix
