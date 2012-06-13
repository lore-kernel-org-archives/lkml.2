Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab2FMTa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:30:59 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44061 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754392Ab2FMTa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:30:58 -0400
Message-ID: <1339615857.28729.6.camel@joe2Laptop>
Subject: Re: [RFC 1/4] ARM: topology: Add arch_scale_freq_power function
From: Joe Perches <joe@perches.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Date: Wed, 13 Jun 2012 12:30:57 -0700
In-Reply-To: <20120613192740.GZ5878@dm>
References: <1339502524-10265-1-git-send-email-vincent.guittot@linaro.org>
	 <1339502524-10265-2-git-send-email-vincent.guittot@linaro.org>
	 <1339591969.8980.30.camel@twins> <20120613192740.GZ5878@dm>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-13 at 20:27 +0100, Andy Whitcroft wrote:
> On Wed, Jun 13, 2012 at 02:52:49PM +0200, Peter Zijlstra wrote:
> > On Tue, 2012-06-12 at 14:02 +0200, Vincent Guittot wrote:
> > >         }
> > >         smp_wmb();
> > >  } 
> > 
> > You know what.. we should make checkpatch report an error for memory
> > barriers that don't have a comment. 
> > 
> > I know this isn't added by this patch, but every time I see something
> > like it I cry a little.
> 
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

Maybe promote that CHK to a WARN.


