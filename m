Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0EUKYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 06:24:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab0EUKYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 06:24:41 -0400
Subject: Re: [PATCH 2/2] perf: Drop the skip argument from
 perf_arch_fetch_regs_caller
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       David Miller <davem@davemloft.net>
In-Reply-To: <1274429477-21531-3-git-send-regression-fweisbec@gmail.com>
References: <1274429477-21531-1-git-send-regression-fweisbec@gmail.com>
	 <1274429477-21531-3-git-send-regression-fweisbec@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 12:24:37 +0200
Message-ID: <1274437477.1674.1698.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 10:11 +0200, Frederic Weisbecker wrote:
> +static inline void perf_fetch_caller_regs(struct pt_regs *regs)
>  {
> -       unsigned long ip;
> -
>         memset(regs, 0, sizeof(*regs));

btw, do we really need that memset?

As long as we don't actually copy out to userspace, it really doesn't
matter what is in there, and we should be setting all relevant registers
anyway.

