Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1A0T10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:27:26 -0500
Received: from casper.infradead.org ([85.118.1.10]:59391 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1A0T1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:27:25 -0500
Subject: Re: One (possible) x86 get_user_pages bug
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jan Beulich <JBeulich@novell.com>, Xiaowei Yang <xiaowei.yang@huawei.com>,
        Nick Piggin <npiggin@kernel.dk>, fanhenglong@huawei.com,
        Kaushik Barde <kbarde@huawei.com>, Kenneth Lee <liguozhu@huawei.com>,
        linqaingmin <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        Wu Fengguang <fengguang.wu@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>
In-Reply-To: <4D41B90D.5000305@goop.org>
References: <4D416D9A.9010603@huawei.com>
	 <4D419416020000780002ECB7@vpn.id2.novell.com>  <4D41B90D.5000305@goop.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 27 Jan 2011 20:27:56 +0100
Message-ID: <1296156476.15234.246.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-27 at 10:27 -0800, Jeremy Fitzhardinge wrote:
> 
> So is there some way we can preserve the current scheme's benefits while
> making it a bit more general?  (If anyone else has non-IPI-based
> shootdown, it would be s390; is there some inspiration there?  An
> instruction perhaps?) 

Well, you can provide a xen gupf implementation based on rcu freed
page-tables like powerpc, sparc and s390 have.

But you'll have to change the mmu_gather implementation of xen and use
the get_page_unless_zero() thing mentioned before (or use
page_cache_get_speculative()).

But I see no need to change the x86 implementation, if the architecture
ever changes the way it does tlb invalidation we need to change more
than just the gupf implementation.


