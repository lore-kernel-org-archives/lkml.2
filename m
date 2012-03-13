Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab2CMJOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 05:14:21 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:59946 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760089Ab2CMJOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 05:14:18 -0400
Date: Tue, 13 Mar 2012 18:20:45 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Avi Kivity <avi@redhat.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] KVM: Avoid checking huge page mappings in
 get_dirty_log()
Message-Id: <20120313182045.97f42399.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4F5E3AAB.7020603@redhat.com>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193216.b14538bb.yoshikawa.takuya@oss.ntt.co.jp>
	<4F5E3AAB.7020603@redhat.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity <avi@redhat.com> wrote:

> It occurs to me that we should write-protect huge page tables, since it
> makes write protection much faster (we make up for this later at write
> fault time, but that might not occur, and even if it does we reduce
> guest jitter).  In fact I once proposed a more involved variant, called

Do you mean protecting huge page tables when we start logging and dropping
them, one by one, at the time of write fault?

If so, we do not need to change get_dirty_log() implementation.
Changing kvm_mmu_remove_write_access() and fault handler seems to be enough.

> O(1) write protection, in which we write-protect the topmost page table
> only and only un-write-protect the paths that fault.

> That can be done later however and shouldn't affect this patchset.

I have some additional patches to optimize rmap handling which seems to
improve get_dirty_log() about 10% in the worst case.

After that, I want to take some time to prepare for further developments
because my current test tools are not enough now.

	Takuya
