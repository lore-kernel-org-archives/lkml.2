Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933757Ab2JaNgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:36:09 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59020 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab2JaNgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:36:06 -0400
Date: Wed, 31 Oct 2012 06:35:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Shan Wei <shanwei88@gmail.com>
Cc: dipankar@in.ibm.com, Kernel-Maillist <linux-kernel@vger.kernel.org>,
        cl@linux-foundation.org
Subject: Re: [PATCH 7/9] rcu:  use this_cpu_ptr per-cpu helper instead of
 per_cpu_ptr(p, raw_smp_processor_id())
Message-ID: <20121031133539.GY3027@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <50910A17.1090600@gmail.com>
 <20121031115140.GX3027@linux.vnet.ibm.com>
 <50912593.8050305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50912593.8050305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103113-5806-0000-0000-00001B3C24AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 09:20:19PM +0800, Shan Wei wrote:
> Paul E. McKenney said, at 2012/10/31 19:51:
> > 
> > The first uses smp_processor_id(), which will complain if
> > force_quiescent_state() is called with preemption disabled, which it
> > sometimes is.
> > 
> > So what am I missing here?
> 
> Hi Paul
> 
> this patch is not right for CONFIG_DEBUG_PREEMPT case.
> __this_cpu_ptr is ok which do not check for preemption context.

Ah, got it.  Please feel free to submit an updated patch.

							Thanx, Paul

