Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab2CGX2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 18:28:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab2CGX2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 18:28:08 -0500
Date: Wed, 7 Mar 2012 20:20:56 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 changelog-v2] KVM: Switch to srcu-less get_dirty_log()
Message-ID: <20120307232056.GA29570@amt.cnet>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
 <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
 <20120303142148.2689454b30dc86d84c4a19f5@gmail.com>
 <20120306111540.GA29914@amt.cnet>
 <20120306234317.2817d2071038d11ab3831c82@gmail.com>
 <20120306150104.GA3041@amt.cnet>
 <20120307002317.d8682de9c6ccd6af8ccac467@gmail.com>
 <20120306152850.GB3353@amt.cnet>
 <20120307171826.1bb12481.yoshikawa.takuya@oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307171826.1bb12481.yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 05:18:26PM +0900, Takuya Yoshikawa wrote:
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
> > > We cannot drop the lock.
> > > Do you mean doing TLB flush each time before dropping the lock?
> > 
> > Yes, only if there is contention (see cond_resched_lock).
> 
> But how can we conditionally call kvm_flush_remote_tlbs() from
> inside __cond_resched_lock right before spin_unlock()?
>
> We need another API.

Yep, a callback into cond_resched_lock_cb (or something) 
could do it.

