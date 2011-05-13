Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab1EMQAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:00:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116Ab1EMQAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:00:53 -0400
Date: Fri, 13 May 2011 12:00:29 -0400
From: Don Zickus <dzickus@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: huang ying <huang.ying.caritas@gmail.com>,
        Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110513160029.GD31888@redhat.com>
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
 <20110513124523.GM13984@redhat.com>
 <20110513130011.GA6474@elte.hu>
 <BANLkTi=Z_3MZVs2CQyk82NfvZj-KdSw5kw@mail.gmail.com>
 <20110513152033.GB3854@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513152033.GB3854@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 05:20:33PM +0200, Ingo Molnar wrote:
> 
> * huang ying <huang.ying.caritas@gmail.com> wrote:
> 
> > > What should be done instead is to add an event for unknown NMIs, which can 
> > > then be processed by the RAS daemon to implement policy.
> > >
> > > By using 'active' event filters it could even be set on a system to panic 
> > > the box by default.
> > 
> > If there is real fatal hardware error, maybe we have no luxury to go from NMI 
> > handler to user space RAS daemon to determine what to do. System may explode, 
> > bad data may go to disk before that.
> 
> That is why i suggested:
> 
>   > > By using 'active' event filters it could even be set on a system to panic 
>   > > the box by default.
> 
> event filters are evaluated in the kernel, so the panic could be instantaneous, 
> without the event having to reach user-space.

Interesting.  Question though, what do you mean by 'event filtering'.  Is
that different then setting 'unknown_nmi_panic' panic on the commandline
or procfs?

Or are you suggesting something like registering another callback on the
die_chain that looks for DIE_NMIUNKNOWN as the event, swallows them and
implements the policy?  That way only on HEST related platforms would
register them while others would keep the default of 'Dazed and confused'
messages?

Cheers,
Don
