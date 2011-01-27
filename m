Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691Ab1A0Qz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 11:55:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43962 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab1A0Qz6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 11:55:58 -0500
Subject: Re: One (possible) x86 get_user_pages bug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Beulich <JBeulich@novell.com>
Cc: Xiaowei Yang <xiaowei.yang@huawei.com>, Nick Piggin <npiggin@kernel.dk>,
        fanhenglong@huawei.com, Kaushik Barde <kbarde@huawei.com>,
        Kenneth Lee <liguozhu@huawei.com>,
        linqaingmin <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        Wu Fengguang <fengguang.wu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4D41A651020000780002ED36@vpn.id2.novell.com>
References: <4D416D9A.9010603@huawei.com>
	 <4D41A651020000780002ED36@vpn.id2.novell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 17:56:43 +0100
Message-ID: <1296147403.15234.241.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 16:07 +0000, Jan Beulich wrote:
> 
> Nick, based on your doing of the initial implementation, would
> you be able to estimate whether disabling get_user_pages_fast()
> altogether for Xen would be performing measurably worse than
> adding the locks (but continuing to avoid acquiring mm->mmap_sem)
> as suggested by Xiaowei? That's of course only if the latter is correct
> at all, of which I haven't fully convinced myself yet. 

Also, I don't think taking the pte_lock is sufficient in your case..
since x86 mmu_gather frees the page tables themselves too, your
dereference of the pgd/pud/pmd will be subject to the same deref after
free problems.
