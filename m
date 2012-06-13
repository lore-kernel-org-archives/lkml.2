Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab2FMT1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:27:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58858 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab2FMT1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:27:45 -0400
Date: Wed, 13 Jun 2012 20:27:40 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [RFC 1/4] ARM: topology: Add arch_scale_freq_power function
Message-ID: <20120613192740.GZ5878@dm>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
 <1339502524-10265-2-git-send-email-vincent.guittot@linaro.org>
 <1339591969.8980.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339591969.8980.30.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 02:52:49PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-12 at 14:02 +0200, Vincent Guittot wrote:
> >         }
> >         smp_wmb();
> >  } 
> 
> You know what.. we should make checkpatch report an error for memory
> barriers that don't have a comment. 
> 
> I know this isn't added by this patch, but every time I see something
> like it I cry a little.

Actually if it was a new line, it would have been reported, at least in
theory:

    # check for memory barriers without a comment.
		    if ($line =~
    /\b(mb|rmb|wmb|read_barrier_depends|smp_mb|smp_rmb|smp_wmb|smp_read_barrier_depends)\(/)
    {
	if (!ctx_has_comment($first_line, $linenr)) {
	    CHK("MEMORY_BARRIER",
		"memory barrier without comment\n" . $herecurr);
	}
    }

-apw
