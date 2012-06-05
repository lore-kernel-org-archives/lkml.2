Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658Ab2FEKOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:14:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43810 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756006Ab2FEKOm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:14:42 -0400
Message-ID: <1338891271.28282.155.camel@twins>
Subject: Re: [PATCH] perf: Fix intel shared extra msr allocation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 05 Jun 2012 12:14:31 +0200
In-Reply-To: <CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
References: <1338520856-21020-1-git-send-email-zheng.z.yan@intel.com>
	 <CABPqkBScjC5fJbTc1rYtbtRqOCyJ+7QUbdE32DgMcffBAGJNVw@mail.gmail.com>
	 <CAAM7YAkYgUjwQptYvyeVawzcD5x4c-bTT_=+6AMyUb+-6HoMuQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-01 at 22:11 +0800, Yan, Zheng wrote:
> 
> The real problem is from __intel_shared_reg_put_constraints(). it set
> reg->alloc to 0 

ok

> and decreases fake_cpuc->shared_regs->regs[reg->idx]'s
> reference count. 

So? That's fake state, who cares what its left in?

> Later when deleting the event,  put_constraints() will find
> reg->alloc is 0 and it won't decrease the shared msr's reference count.

OK, so the only problem is us setting reg->alloc to 0?
