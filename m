Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab1CFMOZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 07:14:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab1CFMOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 07:14:23 -0500
Message-ID: <4D737A96.6040409@redhat.com>
Date: Sun, 06 Mar 2011 14:14:14 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/10] KVM: MMU: don not record gfn in kvm_mmu_pte_write
References: <4D70C569.1030107@cn.fujitsu.com> <4D70C630.1080100@cn.fujitsu.com>
In-Reply-To: <4D70C630.1080100@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 01:00 PM, Xiao Guangrong wrote:
> No need to record the gfn to verifier the pte has the same mode as
> current vcpu, it's because we only speculatively update the pte only
> if the pte and vcpu have the same mode

True.  We can, as an additional cleanup, change mmu_pte_write_new_pte() 
to just do vcpu->arch.mmu.update_spte(...) instead of the if ().

-- 
error compiling committee.c: too many arguments to function

