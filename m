Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab0ENHov (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 03:44:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36225 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab0ENHou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 03:44:50 -0400
Subject: Re: [PATCH RFC] perf: fix find_swevent_head() RCU lockdep splat
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       acme@redhat.com
In-Reply-To: <20100513190325.GB5377@nowhere>
References: <20100513182556.GA14326@linux.vnet.ibm.com>
	 <20100513190325.GB5377@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 14 May 2010 09:44:24 +0200
Message-ID: <1273823064.5605.3599.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-13 at 21:03 +0200, Frederic Weisbecker wrote:
> hlist = rcu_dereference_check(ctx->swevent_hlist,
>                               rcu_read_lock_held() ||
>                               raw_spin_lock_is_held(&ctx->lock)); 

raw_spin_lock_is_held() is wrong, that should read:
lockdep_is_held(&ctx->lock).

raw_spin_lock_is_held() only checks if the lock is locked,
lockdep_is_held() ensures we are the one holding it.
