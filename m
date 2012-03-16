Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032614Ab2CPHt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 03:49:26 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:44218 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032600Ab2CPHtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 03:49:24 -0400
Date: Fri, 16 Mar 2012 16:55:47 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: Switch to srcu-less get_dirty_log()
Message-Id: <20120316165547.4df2abe4.yoshikawa.takuya@oss.ntt.co.jp>
In-Reply-To: <4F62EC25.5060306@linux.vnet.ibm.com>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
	<4F62C9B4.7060804@linux.vnet.ibm.com>
	<20120316155511.70455b4a.yoshikawa.takuya@oss.ntt.co.jp>
	<4F62EC25.5060306@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012 15:30:45 +0800
Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com> wrote:

> >> There is a example:
> >>
> >>              CPU A                                   CPU  B
> >> guest page is written by write-emulation
> >>
> >>                                                   hold mmu-lock and see dirty-bitmap
> >>                                                   is not be changed, then migration is
> >>                                                   completed.
> > 
> > We do not allow this break.
> > 
> 
> 
> Hmm? what can avoid this? Could you please point it out?

Stopping the guest before actualy migrating the guest means VCPU threads
must be back in the userspace at the moment, no?

So when the final GET_DIRTY_LOG is being executed, thread A cannot be
in KVM.

> The problem is the guest page is written before dirty-bitmap is set,
> we may log the dirty page in this window like above case...

Exactly, but the next GET_DIRTY_LOG call can take that because, as I
wrote above, at this time the GET_DIRTY_LOG must not be the final one.

Makes sense?

	Takuya
