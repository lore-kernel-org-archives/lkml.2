Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab0GMFfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 01:35:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab0GMFfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 01:35:40 -0400
Message-ID: <4C3BFB25.2010602@redhat.com>
Date: Tue, 13 Jul 2010 08:35:33 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 6/9] KVM: MMU: introduce pte_prefetch_topup_memory_cache()
References: <4C330918.6040709@cn.fujitsu.com> <4C330A37.8080709@cn.fujitsu.com> <4C39C1AB.6000606@redhat.com> <4C3A8694.1000401@cn.fujitsu.com> <4C3B09FD.3060307@redhat.com> <4C3BBE84.30708@cn.fujitsu.com> <4C3BE9BD.40007@redhat.com> <4C3BEAC3.9000501@cn.fujitsu.com>
In-Reply-To: <4C3BEAC3.9000501@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 07:25 AM, Xiao Guangrong wrote:
>
>> Regressions? no.  Or do you mean the problem already exists?  Where?
>>      
> I mean this is a exist problem, likes invlpg, pte-write and sync-page, there are
> speculative path that it's not real access, but marked dirty if pte is writable.
>    

Right.  We should fix those too.

Prefetch is much more worrying though, especially with ept.  If a guest 
is using just 1/8 of the pages, it can look to migration as if it's 
using 100% of the pages.  The impact can be pretty large.

In contrast, I'm not too worried about invlpg, as most times an access 
will follow a miss, and usually a write access if we set a writeable 
pte.  Not sure about sync-page.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

