Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760148Ab2CNA6L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:58:11 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:35074 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab2CNA6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:58:10 -0400
Date: Wed, 14 Mar 2012 10:04:35 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: Avoid checking huge page mappings in
 get_dirty_log()
Message-Id: <20120314100435.16c1bfcf.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <20120313230412.GA12153@amt.cnet>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
	<20120313230412.GA12153@amt.cnet>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti <mtosatti@redhat.com> wrote:

> 
> This is a race with hugetlbfs which is not an issue ATM (it is 
> hidden by the removal of huge sptes in get_dirty).

Thank you!
I did not notice this possibility at all.

...

> It can be fixed with a preceding patch that checks whether
> slot->dirty_bitmap value changes between mapping_level and after
> mmu_lock acquision, similarly to mmu_seq. Also please add a 
> WARN_ON in mmu_set_spte if(slot->dirty_bitmap && level > 1).
> And document it clearly.

We may also be able to change the "if (slot->dirty_bitmap)" check to
use another flag so that we can delay the start of logging until
mmu_lock acquisition in kvm_set_memory_region().

Looking dirty_bitmap directly should be limited to when we are in
get_dirty functions.

	Takuya
