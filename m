Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935156Ab1ETBvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 21:51:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:34237 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934716Ab1ETBvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 21:51:02 -0400
Subject: Re: [PATCH 2/7] [RFC] add bluegene entry to cputable
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        bg-linux@lists.anl-external.org
In-Reply-To: <BANLkTimEqYnTn10rV2=gfDkXfgxX+2OSCg@mail.gmail.com>
References: <1305753895-24845-1-git-send-email-ericvh@gmail.com>
	 <1305753895-24845-2-git-send-email-ericvh@gmail.com>
	 <1305851709.7481.89.camel@pasglop>
	 <BANLkTimEqYnTn10rV2=gfDkXfgxX+2OSCg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 11:50:51 +1000
Message-ID: <1305856251.7481.117.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-19 at 20:08 -0500, Eric Van Hensbergen wrote:
> On Thu, May 19, 2011 at 7:35 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Wed, 2011-05-18 at 16:24 -0500, Eric Van Hensbergen wrote:
> >> +             .dcache_bsize           = 32,
> >> +             .cpu_setup              = __setup_cpu_460gt,
> >                                            ^^^^^^^^^^^^^^^^^^
> > Are you sure ?
> >
> 
> That surprised me too, I figured it must have been a close enough
> match (at least in the 2.6.29.1 time frame which is where I'm trying
> to merge the BG/P patches up from.  The kittyhawk patches don't even
> use this, so its possible we could just remove it.
>
> _GLOBAL(__setup_cpu_460ex)
> _GLOBAL(__setup_cpu_460gt)
>         mflr    r4
>         bl      __init_fpu_44x
>         bl      __fixup_440A_mcheck
>         mtlr    r4
>         blr
> 
> Looks like the 460 setup invokes a bunch of 440 calls!  Would you
> prefer I setup my own entry point (setup_cpu_bgp or setup_cpu_450)
> which makes the same calls?

Yes, add an entry. 460's are just 440's btw :-)

Cheers,
Ben.


