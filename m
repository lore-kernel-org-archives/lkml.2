Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2BWNZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 08:25:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42685 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab2BWNZc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 08:25:32 -0500
Message-ID: <1330003524.11248.11.camel@twins>
Subject: Re: [PATCH 0/4] KVM: srcu-less dirty logging
From: Peter Zijlstra <peterz@infradead.org>
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Date: Thu, 23 Feb 2012 14:25:24 +0100
In-Reply-To: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp>
References: <20120223203300.241510a6.yoshikawa.takuya@oss.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 20:33 +0900, Takuya Yoshikawa wrote:
> - Stop allocating extra dirty bitmap buffer area
> 
>   According to Peter, mmu_notifier has become preemptible.  If we can
>   change mmu_lock from spin_lock to mutex_lock, as Avi said before, this
>   would be staightforward because we can use __put_user() right after
>   xchg() with the mmu_lock held 

So the 'only' thing to consider is running the end result with lockdep
enabled since the mmu locks are rather deep in the nesting tree its very
easy to accidentally cause inversions.


