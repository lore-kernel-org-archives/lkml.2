Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab0KRHNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 02:13:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53693 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0KRHNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 02:13:10 -0500
Message-ID: <4CE4D306.6030707@cn.fujitsu.com>
Date: Thu, 18 Nov 2010 15:17:26 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] KVM: MMU: fix forgot flush vcpu tlbs
References: <4CE355A0.6020907@cn.fujitsu.com> <20101117152943.GA18959@amt.cnet> <4CE4024B.4090600@redhat.com> <20101117173616.GG18959@amt.cnet>
In-Reply-To: <20101117173616.GG18959@amt.cnet>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-18 15:13:29,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-18 15:13:29,
	Serialize complete at 2010-11-18 15:13:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 01:36 AM, Marcelo Tosatti wrote:

>> I don't think we need to flush immediately; set a "tlb dirty" bit
>> somewhere that is cleareded when we flush the tlb.
>> kvm_mmu_notifier_invalidate_page() can consult the bit and force a
>> flush if set.
> 
> Yep.
> 

Great, i'll do it in the v3.

Do we need a simple bug fix patch(which immediately flush tlbs) for
backport first?

