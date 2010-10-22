Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab0JVJYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:24:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39820 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab0JVJYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:24:08 -0400
Date: Fri, 22 Oct 2010 11:24:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
Message-ID: <20101022092402.GB10456@basil.fritz.box>
References: <1286606987-19879-5-git-send-email-ying.huang@intel.com>
 <20101011212006.GB23882@redhat.com>
 <1287555157.3026.21.camel@yhuang-dev>
 <20101020141558.GB19090@redhat.com>
 <1287623643.19320.40.camel@yhuang-dev>
 <20101021023135.GA12086@redhat.com>
 <1287638251.19320.190.camel@yhuang-dev>
 <20101021141002.GI19090@redhat.com>
 <20101021154543.GD21695@basil.fritz.box>
 <20101022014955.GP19090@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022014955.GP19090@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 09:49:55PM -0400, Don Zickus wrote:
> After re-reading Huang's patch, I am starting to understand what you mean
> by broken hardware.  Basically you are trying to distinguish between
> legacy systems that were 'broken' in the sense they would randomly send
> uknown NMIs for no good reason, hence the 'Dazed and confused' messages
> and hardware errors on more modern systems that say, 'Hardware error,
> panicing check your BIOS for more info' (or whatever).

Yes that's it.

Unfortunately there are some cases where the BIOS lost it either,
so the fallback has to be panic (at least for the modern boxes)

> 
> So Huang's patch was sort of acting like a switch.  On legacy systems use
> 'Dazed and confused' for unknown NMIs.  Whereas on whitelisted modern
> systems use a more relavant 'Check BIOS for error' message.  Is that
> right?

Yes.

> > I don't think you need to worry about a lot more hardware NMI sources.
> 
> Well until those machines dominate the marketplace, I'm stuck supporting
> those pre-Nahelam boxes with customers that committed to 10 years with
> last year's technology.  ;-)

I should clarify that the NMI model I described long predates Nehalem.
If you assume 3-5 years deprecation cycles on servers it should be pretty
much universal in this space. 

The HEDT detection was a proposed way to detect that, because most
of these systems should have HEDT.

The older machines still need to be supported, but it's ok to
just behave the same as today on them, no need for great improvements
here.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
