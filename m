Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2DUBiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 21:38:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49253 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab2DUBio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 21:38:44 -0400
Date: Sat, 21 Apr 2012 10:38:39 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 5/9] KVM: MMU: introduce SPTE_WRITE_PROTECT bit
Message-Id: <20120421103839.7e17a3e46ccc50629691c997@gmail.com>
In-Reply-To: <20120421005555.GA16526@amt.cnet>
References: <4F911B74.4040305@linux.vnet.ibm.com>
	<4F911C05.2070701@linux.vnet.ibm.com>
	<20120420215211.GC13817@amt.cnet>
	<20120421004030.GA16191@amt.cnet>
	<20120421005555.GA16526@amt.cnet>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012 21:55:55 -0300
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> More importantly than the particular flush TLB case, the point is
> every piece of code that reads and writes sptes must now be aware that
> mmu_lock alone does not guarantee stability. Everything must be audited.

In addition, please give me some stress-test cases to verify these in the
real environments.  Live migration with KSM, with notifier call, etc?

Although the current logic is verified by dirty-log api test, the new logic
may need another api test program.

Note: the problem is that live migration can fail silently.  We cannot know
the data loss is from guest side problem or get_dirty side.

> Where the bulk of the improvement comes from again? If there is little
> or no mmu_lock contention (which we have no consistent data to be honest
> in your testcase) is the bouncing off mmu_lock's cacheline that hurts?

This week, I was doing some simplified "worst-latency-tests" for my work.
It was difficult than I thought.

But Xiao's "lock-less" should see the reduction of mmu_lock contention
more easily, if there is really some.

To make things simple, e.g., we can do the same kind of write-loop as
XBZRLE people are doing in the guest - with more VCPUs if possible.

Thanks,
	Takuya
