Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab1COL1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 07:27:46 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57914 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab1COL1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 07:27:40 -0400
Date: Tue, 15 Mar 2011 04:27:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
Message-ID: <20110315112734.GA2167@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D7F356C.8020903@cn.fujitsu.com>
 <201103151115.54426.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103151115.54426.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 11:15:54AM +0100, Arnd Bergmann wrote:
> On Tuesday 15 March 2011 10:46:20 Lai Jiangshan wrote:
> > +static __always_inline bool __is_kfree_rcu_offset(unsigned long offset)
> > +{
> > +       return offset < 4096;
> > +}
> 
> So this relies on the assumptions that 
> 
> a) the rcu_head is within the first 4 KB of the data structure to be freed
> b) no callback ever gets called in the first 4 KB of virtual address space
> 
> It's probably a reasonable assumption, but I think it should be documented
> more explicitly, especially the first one. It's entirely possible that
> an RCU managed data structure is larger than 4 KB.

Good catch, this does indeed need to be explicitly documented, for
example in the docbook header.

> Another alternative might be to encode the difference between a
> function pointer and an offset in one of the lower bits of the address.

We discussed this some time back, and it turned out that there were
CPUs that could legitimately have any combination of low-order bits
set -- functions could start at any byte address.

If this has changed, I would prefer to use the low-order bits, but
if it has not, we can't.  :-(

							Thanx, Paul
