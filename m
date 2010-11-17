Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026Ab0KQByF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 20:54:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58394 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab0KQByC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 20:54:02 -0500
Message-ID: <4CE336BC.4070905@cn.fujitsu.com>
Date: Wed, 17 Nov 2010 09:58:20 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: MMU: cleanup update_pte, pte_prefetch and sync_page
 functions
References: <4CDD173E.8010706@cn.fujitsu.com> <4CDD187A.9010609@cn.fujitsu.com> <20101116205223.GB24156@amt.cnet>
In-Reply-To: <20101116205223.GB24156@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 09:54:24,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-17 09:54:25,
	Serialize complete at 2010-11-17 09:54:25
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2010 04:52 AM, Marcelo Tosatti wrote:

>> +	else
>> +		mmu_set_spte(vcpu, spte, sp->role.access, pte_access, 0, 0,
>> +			     dirty, NULL, PT_PAGE_TABLE_LEVEL, gfn,
>> +			     pfn, true, host_writeable);
> 
> For example, the update path should always go through mmu_set_spte to
> update last_pte_updated, last_pte_gfn.
> 

Actually, the set_spte() just works for sync path ;-)

> Also the callbacks make it harder to read the code. Maybe the
> unification works if you use common functions for common parts.
> 

Um. your advice is reasonable, i'll improve it. Thanks.

