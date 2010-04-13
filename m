Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab0DMGmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 02:42:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab0DMGmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 02:42:18 -0400
Message-ID: <4BC41241.30204@redhat.com>
Date: Tue, 13 Apr 2010 09:42:09 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] KVM MMU: optimize for writing cr4
References: <4BC2D2E2.1030604@cn.fujitsu.com> <4BC2D3E0.8070602@cn.fujitsu.com> <4BC2DB27.7060005@redhat.com> <4BC2F928.2060407@cn.fujitsu.com> <4BC30273.3050406@redhat.com> <4BC3DFE3.6090006@cn.fujitsu.com>
In-Reply-To: <4BC3DFE3.6090006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 06:07 AM, Xiao Guangrong wrote:
>
> And i found the commit 87778d60ee:
>
> |    KVM: MMU: Segregate mmu pages created with different cr4.pge settings
> |
> |    Don't allow a vcpu with cr4.pge cleared to use a shadow page created with
> |    cr4.pge set; this might cause a cr3 switch not to sync ptes that have the
> |    global bit set (the global bit has no effect if !cr4.pge).
> |
> |    This can only occur on smp with different cr4.pge settings for different
> |    vcpus (since a cr4 change will resync the shadow ptes), but there's no
> |    cost to being correct here.
>
> In current code, cr3 switch will sync all unsync shadow pages(regardless it's
> global or not) and this issue not live now, so, do we need also revert this
> patch?
>    

One path is to revert this patch.  The other is to restore the 
optimization that relies on it.  I'm not sure which is best.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

