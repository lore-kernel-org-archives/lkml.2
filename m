Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2FMVvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:51:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:40550 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908Ab2FMVvh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:51:37 -0400
Message-ID: <1339624281.8980.73.camel@twins>
Subject: Re: [RFC 1/4] ARM: topology: Add arch_scale_freq_power function
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Date: Wed, 13 Jun 2012 23:51:21 +0200
In-Reply-To: <20120613192740.GZ5878@dm>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	 <1339502524-10265-2-git-send-email-vincent.guittot@linaro.org>
	 <1339591969.8980.30.camel@twins> <20120613192740.GZ5878@dm>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 20:27 +0100, Andy Whitcroft wrote:

> Actually if it was a new line, it would have been reported, at least in
> theory:
> 
>     # check for memory barriers without a comment.
> 		    if ($line =~
>     /\b(mb|rmb|wmb|read_barrier_depends|smp_mb|smp_rmb|smp_wmb|smp_read_barrier_depends)\(/)
>     {
> 	if (!ctx_has_comment($first_line, $linenr)) {
> 	    CHK("MEMORY_BARRIER",
> 		"memory barrier without comment\n" . $herecurr);
> 	}
>     }

Oh sweet, we already have something for that.. But yeah I'd promote that
CHK to something stronger like Joe said. Maybe even error. Memory
barriers are magic, not adding proper comments should be a capital
offense. 
