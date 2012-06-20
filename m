Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab2FTM5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 08:57:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46062 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2FTM46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 08:56:58 -0400
Date: Wed, 20 Jun 2012 21:56:53 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v7 02/10] KVM: MMU: abstract spte write-protect
Message-Id: <20120620215653.15930f3467bc13748d548b0d@gmail.com>
In-Reply-To: <4FE193AA.8010801@linux.vnet.ibm.com>
References: <4FE1822D.8010002@linux.vnet.ibm.com>
	<4FE1825B.1030402@linux.vnet.ibm.com>
	<20120620180254.8b3a42f8.yoshikawa.takuya@oss.ntt.co.jp>
	<4FE193AA.8010801@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2012 17:11:06 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> Strange! Why do you think it is wrong? It is just debug code.

kvm_mmu_slot_remove_write_access() does not use rmap but the debug code says:
	rmap_printk("rmap_write_protect: spte %p %llx\n", sptep, *sptep);

> > If you think it is not a problem, please explain why you think so in
> > the changelog.
> 
> 
> It is a from the first place and it is used to debug and not compiled at all.

It was not in kvm_mmu_slot_remove_write_access() before, no?

This patch says that the write protection code becomes commonly usable
function, but it still has rmap_write_protect specific debug code in it;
using it in kvm_mmu_slot_remove_write_access(), which is not at all related
to rmap_write_protect, is strange.

As you say, this is just debug code and does not have any practical problem.
But randomly putting debug code is not a good thing.

Thanks,
	Takuya
