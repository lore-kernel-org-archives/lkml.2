Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336Ab2EIUb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761026Ab2EIUb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:31:58 -0400
Date: Wed, 9 May 2012 22:30:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
        linux-kernel@vger.kernel.org, suresh@aristanetworks.com
Subject: Re: [PATCH 2/3] x86, xsave: remove thread_has_fpu() bug check in
	__sanitize_i387_state()
Message-ID: <20120509203047.GA334@redhat.com>
References: <1336421341.19423.4.camel@sbsiddha-desk.sc.intel.com> <1336519085-27450-1-git-send-email-suresh.b.siddha@intel.com> <1336519085-27450-3-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336519085-27450-3-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suresh,

I can't really comment this series, my understanding of this code
is too limited.

But could you explain this patch? I am just curious.

On 05/08, Suresh Siddha wrote:
>
> BUG_ON() in __sanitize_i387_state() is checking that the fpu state
> is not live any more. But for preempt kernels, task can be scheduled
> out and in at any place and the preload_fpu logic during context switch
> can make the fpu registers live again.

And? Do you see any particular scenario when this BUG_ON() is wrong?

Afaics, __sanitize_i387_state() should not be called if the task can
be scheduled in with ->fpu_counter != 0.

> Similarly during core dump, thread dumping the core can schedule out
> and in for page-allocations etc in non-preempt case.

Again, can't understand. The core-dumping thread does init_fpu()
before it calls sanitize_i387_state().

Oleg.

