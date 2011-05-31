Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab1EaQ56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:57:58 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:60731 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752315Ab1EaQ55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:57:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=a27R9BFRiy//+qBTRUq5+FP0L6AWIPCz59L3M5TZjIadR16vj0dJqSuM2vnFETtmRG6b+zjmDmA63GrP4XF++GBDmNre2qOHbMABTi2La5hPKwQvla9+u3EsGCosFtgI;
Date: Tue, 31 May 2011 09:57:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jason Stubbs <jasonbstubbs@gmail.com>
Cc: Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: fix regression after clock gating init split
Message-ID: <20110531095737.0adbbfee@jbarnes-desktop>
In-Reply-To: <201105281426.28488.jasonbstubbs@gmail.com>
References: <201105272344.20084.jasonbstubbs@gmail.com>
	<yunaae8j5dg.fsf@aiko.keithp.com>
	<201105281426.28488.jasonbstubbs@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 May 2011 14:26:28 +1000
Jason Stubbs <jasonbstubbs@gmail.com> wrote:

> On Sat, 28 May 2011 05:44:11 Keith Packard wrote:
> > On Fri, 27 May 2011 23:44:19 +1000, Jason Stubbs <jasonbstubbs@gmail.com> 
> wrote:
> > > From: Jason Stubbs <jasonbstubbs@gmail.com>
> > > 
> > > However, there are some code paths, notably IS_PINEVIEW(dev), where 
> > > init_clock_gating is not set and not needed.
> > 
> > Looks like Pineview should be using the gen3_init_clock_gating function.
> 
> Yep, you are right. Adding printk()s to the original implementation confirmed 
> that - at least on my hardware. I should have known to check that...
> 
> There are two other code paths where an init_clock_gating function isn't 
> specified though. The specific code paths are:
> 
> HAS_PCH_SPLIT() && !IS_GEN5() && !IS_GEN6() && !IS_IVYBRIDGE()
> 
> Looking at the original intel_enable_clock_gating() function, there would
> have been some intialization done for this case.
> 
> IS_GEN4() && !IS_CRESTLINE() && !IS_BROADWATER()
> 
> It looks like this would have gone into the final "no gating match" if/else 
> branch.
> 
> If both of the above don't happen in the real world, then I guess it's fine as 
> is. If either are possible, then they need to be fixed too.
> 
> I'll just (re)send a patch for the IS_PINEVIEW() case and leave the above to
> somebody who knows better than I...

Yeah, the above combos aren't valid, so I don't think we need to handle
them.

Thanks for the Pineview fix!

-- 
Jesse Barnes, Intel Open Source Technology Center
