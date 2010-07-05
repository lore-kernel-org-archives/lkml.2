Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402Ab0GEBC2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 21:02:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755263Ab0GEBC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 21:02:26 -0400
Date: Sun, 4 Jul 2010 22:02:11 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: fix tlb flush with invalid root
Message-ID: <20100705010211.GA6969@amt.cnet>
References: <4C2EEEA2.5090305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C2EEEA2.5090305@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 03, 2010 at 04:02:42PM +0800, Xiao Guangrong wrote:
> Commit 341d9b535b6c simplify reload logic while entry guest mode, it
> can avoid unnecessary sync-root if KVM_REQ_MMU_RELOAD and
> KVM_REQ_MMU_SYNC both set.
> 
> But, it cause a issue that when we handle 'KVM_REQ_TLB_FLUSH', the
> root is invalid, it is triggered during my test:
> 
> Kernel BUG at ffffffffa00212b8 [verbose debug info unavailable]
> ......
> 
>  [<ffffffff810f5caf>] ? fget_light+0x111/0x28e
>  [<ffffffff81103963>] sys_ioctl+0x47/0x6a
>  [<ffffffff81002c1b>] system_call_fastpath+0x16/0x1b
> Code: f0 eb 21 f7 c2 00 00 00 04 74 22 48 8d 45 f0 48 c7 45 f0 00 00 00 00 48 c7 45 f8 00 00 00 00 b9 02 00 00 00 66 0f 38 80 08 77 02 <0f> 0b c9 c3 55 48 89 e5 0f 1f 44 00 00 ba 00 68 00 00 48 8b 8f 
> RIP  [<ffffffffa00212b8>] vmx_flush_tlb+0xdf/0xe3 [kvm_intel]
>  RSP <ffff8800be269ca8>
> 
> Fixed by directly return if the root is not ready.
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Applied, thanks.


