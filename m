Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab1CGDXI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 22:23:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51651 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755131Ab1CGDXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 22:23:06 -0500
Message-ID: <4D744E27.2090609@cn.fujitsu.com>
Date: Mon, 07 Mar 2011 11:16:55 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 6/10] KVM: MMU: don not record gfn in kvm_mmu_pte_write
References: <4D70C569.1030107@cn.fujitsu.com> <4D70C630.1080100@cn.fujitsu.com> <4D737A96.6040409@redhat.com> <4D737B25.7090503@redhat.com>
In-Reply-To: <4D737B25.7090503@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-07 11:14:45,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-07 11:21:53,
	Serialize complete at 2011-03-07 11:21:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2011 08:16 PM, Avi Kivity wrote:
> On 03/06/2011 02:14 PM, Avi Kivity wrote:
>> On 03/04/2011 01:00 PM, Xiao Guangrong wrote:
>>> No need to record the gfn to verifier the pte has the same mode as
>>> current vcpu, it's because we only speculatively update the pte only
>>> if the pte and vcpu have the same mode
>>
>> True.  We can, as an additional cleanup, change mmu_pte_write_new_pte() to just do vcpu->arch.mmu.update_pte(...) instead of the if ().
>>
> 
> Also, we can remove the pfn guessing and to it in FNAME(update_pte), using gfn_to_pfn_atomic().
> 

OK, i'll do these in the next version, thanks!
