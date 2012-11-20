Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2KTP5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:57:46 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35776 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab2KTP5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:57:45 -0500
Date: Tue, 20 Nov 2012 15:57:17 +0000
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <rric@kernel.org>
Cc: Maynard Johnson <maynardj@us.ibm.com>,
        "jgq516@gmail.com" <jgq516@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: oprofile: add A5/A7/A15 entries in op_perf_name
Message-ID: <20121120155717.GD26475@mudshark.cambridge.arm.com>
References: <1351853016-4476-1-git-send-email-jgq516@gmail.com>
 <20121105113102.GF3351@mudshark.cambridge.arm.com>
 <20121120121747.GJ2504@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120121747.GJ2504@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 12:17:47PM +0000, Robert Richter wrote:
> Will,
> 
> On 05.11.12 11:31:03, Will Deacon wrote:
> > > diff --git a/arch/arm/oprofile/common.c b/arch/arm/oprofile/common.c
> > > index 99c63d4b..ec10db1 100644
> > > --- a/arch/arm/oprofile/common.c
> > > +++ b/arch/arm/oprofile/common.c
> > > @@ -37,8 +37,11 @@ static struct op_perf_name {
> > >  	{ "xscale1",		"arm/xscale2"	},
> > >  	{ "v6",			"arm/armv6"	},
> > >  	{ "v6mpcore",		"arm/mpcore"	},
> > > +	{ "ARMv7 Cortex-A5",	"arm/armv7-ca5"	},
> > > +	{ "ARMv7 Cortex-A7",	"arm/armv7-ca7"	},
> > >  	{ "ARMv7 Cortex-A8",	"arm/armv7"	},
> > >  	{ "ARMv7 Cortex-A9",	"arm/armv7-ca9"	},
> > > +	{ "ARMv7 Cortex-A15",	"arm/armv7-ca15" },
> > >  };
> 
> > I'd rather not go down this route now that we have the operf tool as part of
> > oprofile, which can use the perf syscall directly and doesn't need this
> > string translation.
> 
> since this is just an update of cpu detection I would be willing to
> include this into kernel code anyway.

Perhaps, but one day we might like to remove this compatibility layer as
tools move over to the perf system call, so adding new CPUs here is actively
going against that.

> We could further move the cpu detection to userspace if perf_event
> exists. We let the kernel enable oprofile with cpu_type="unknown".
> User space then could either bind mount the file (user could do this
> manually) or we implement to write to cpu_type. Doing so oprofile
> could use in-kernel perf_events if it exists always as fallback.

Not sure I follow you... operf already does the CPU detection from
userspace, so I guess that code could simply be re-used. What does the bind
mount involve?

Cheers,

Will
