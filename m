Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0FXIoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 04:44:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754486Ab0FXIo1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:44:27 -0400
Subject: Re: [patch 24/52] fs: dcache reduce d_parent locking
From: Peter Zijlstra <peterz@infradead.org>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>,
       "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>
In-Reply-To: <20100624030729.395195069@suse.de>
References: <20100624030212.676457061@suse.de>
	 <20100624030729.395195069@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 10:44:22 +0200
Message-ID: <1277369062.1875.928.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 13:02 +1000, npiggin@suse.de wrote:
> Use RCU property of dcache to simplify locking in some places where we
> take d_parent and d_lock.
> 
> Comment: don't need rcu_deref because we take the spinlock and recheck it.

But does the LOCK barrier imply a DATA DEPENDENCY barrier? (It does on
x86, and the compiler barrier implied by spin_lock() suffices to replace
ACCESS_ONCE()).
