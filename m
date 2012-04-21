Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2DUBBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 21:01:20 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:41276 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2DUBBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 21:01:18 -0400
Date: Sat, 21 Apr 2012 10:01:13 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 07/16] KVM: MMU: introduce for_each_pte_list_spte
Message-Id: <20120421100113.4040ac700af6d2b04dda613f@gmail.com>
In-Reply-To: <4F8E3C7F.5040601@linux.vnet.ibm.com>
References: <4F87FA69.5060106@linux.vnet.ibm.com>
	<4F87FC19.8080404@linux.vnet.ibm.com>
	<20120414114422.e3fe6e2abbfdcce61e6f69c8@gmail.com>
	<4F8B93B9.2030801@linux.vnet.ibm.com>
	<20120417234731.a19f270d5701b11ce95d13d4@gmail.com>
	<4F8E3C7F.5040601@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay.

On Wed, 18 Apr 2012 12:01:03 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> > I have checked dirty-log-perf myself with this patch [01-07].
> > 
> > GET_DIRTY_LOG for 1GB dirty pages has become more than 15% slower.

> Thanks for your test!
> 
> Unbelievable, i will do more test and check it more carefully.

GET_DIRTY_LOG now traverses rmap lists intensively.
So only a small change can affect the performance when there are many
dirty pages.

> Could you please open your tool, then i can reproduction it and find the
> real reason?

It's already in kvm unit tests!

> I will check whether your tool is better then kernbench/autotest after
> review your tool.

Let's focus on "lock-less" now: so dirty-log-perf is not needed now.

I think you failed to appeal the real advantage of your "lock-less" approach!
I will write about this on v3-threads.

Thanks,
	Takuya
