Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2G3CNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 22:13:51 -0400
Received: from ozlabs.org ([203.10.76.45]:37544 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753903Ab2G3CNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 22:13:49 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@us.ibm.com>
Subject: Re: [PATCH] x86: don't ever patch back to UP if we unplug cpus.
In-Reply-To: <1343420909.3696.560.camel@sbsiddha-desk.sc.intel.com>
References: <87y5m5mz6o.fsf@rustcorp.com.au> <1343420909.3696.560.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 30 Jul 2012 11:38:57 +0930
Message-ID: <877gtmm24m.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012 13:28:29 -0700, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 	if (!noreplace_smp && (num_present_cpus() == 1 || setup_max_cpus <= 1))
> 
> also, to be consistent with other checks, may be just use
> "num_possible_cpus() == 1" check instead of "setup_max_cpus <= 1".

Actually, if you specify "maxcpus=1" on the kernel command line,
you get num_possible_cpus() == 4, even though only one gets online.

So the setup_max_cpus check is in fact correct here.

Thanks!
Rusty.
