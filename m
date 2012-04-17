Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2DQOri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:47:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:65084 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab2DQOrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:47:36 -0400
Date: Tue, 17 Apr 2012 23:47:31 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 07/16] KVM: MMU: introduce for_each_pte_list_spte
Message-Id: <20120417234731.a19f270d5701b11ce95d13d4@gmail.com>
In-Reply-To: <4F8B93B9.2030801@linux.vnet.ibm.com>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
	<4F87FC19.8080404@linux.vnet.ibm.com>
	<20120414114422.e3fe6e2abbfdcce61e6f69c8@gmail.com>
	<4F8B93B9.2030801@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2012 11:36:25 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> I tested it with kernbench, no regression is found.

Because kernbench is not at all good test for this.

> It is not a problem since the iter and spte should be in the cache.

I have checked dirty-log-perf myself with this patch [01-07].

GET_DIRTY_LOG for 1GB dirty pages has become more than 15% slower.

This is not a pure cleanup and introduces significant regression to
rmap handling.

This is the reason why I asked to remove "cleanup patches" from this
patch series.  Had it been really trivial cleanup, I would not have
asked that.


Note: if you had checked the worst case latency with this patch series,
you should have noticed this regression by yourself.

Auto-test and kernbench are not enough to see the effect of this work.

Thanks,
	Takuya
