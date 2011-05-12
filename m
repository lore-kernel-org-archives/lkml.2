Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab1ELSxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:53:40 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16359 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1ELSxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:53:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 May 2011 11:53:38 -0700
Subject: Re: [PATCH v2] net: rfkill: add generic gpio rfkill driver
From: Rhyland Klein <rklein@nvidia.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "olof@lixom.net" <olof@lixom.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1305225648.3461.37.camel@jlt3.sipsolutions.net>
References: <1305159661-11982-1-git-send-email-rklein@nvidia.com>
	 <1305189092.3461.10.camel@jlt3.sipsolutions.net>
	 <1305224592.10961.10.camel@rklein-linux2>
	 <1305225648.3461.37.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 May 2011 11:52:57 -0700
Message-ID: <1305226377.10961.12.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-12 at 11:40 -0700, Johannes Berg wrote:
> On Thu, 2011-05-12 at 11:23 -0700, Rhyland Klein wrote:
> 
> > > Are you sure starting out with UNSPECIFIED works? Then you'll always
> > > change, but if the clock was enabled already you still enable it on the
> > > first set_block() from rfkill, which still has the refcount problem, no?
> > > It seems to me that the original state has to be passed in from the
> > > platform?
> 
> > I thought about that. But I decided the clock that it is possible to
> > have the clock used for the radio used for something else right? 
> 
> Sure.
> 
> > in
> > which case, the driver will leave the clk in whatever state it initially
> > finds it. I.e. if the clock is disabled, then it will enable it only
> > once and work, if it is enabled, it will add a refcount (only once) and
> > then work and disable it again only once. It never changes the refcount
> > in either direction by more than 1, and this way the initial setting of
> > the clock is irrelevant. The board files can simply initialize the block
> > as off if that is the initial clk state they want.
> 
> The issue is that depending on how you boot, the first refcount change
> might be +1 or it might be -1.
> 
> If rfkill decides that at the time of loading wifi should be off, then
> the first change would be -1, and after that it would flip between 0 and
> -1.
> 
> If, on the other hand, rfkill decides that at the time of loading the
> driver wifi should be on, then the first change would be +1 and it'll
> flip between 0 and +1.
> 
> This seems like it'll cause issues at some point, so I think you should
> either allow the driver to set the initial state or hardcode one of
> these possibilities (so at least it's predictable)
> 
> johannes
> 

I won't go negative, if you look, it only will disable clock if it knows
it has already enabled it. 

rhyland

