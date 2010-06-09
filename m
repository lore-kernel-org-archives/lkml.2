Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab0FIDQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 23:16:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43113 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701Ab0FIDQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 23:16:13 -0400
Date: Tue, 8 Jun 2010 20:16:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
cc: linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <alpine.DEB.2.00.1006090243360.1269@skynet.skynet.ie>
Message-ID: <alpine.LFD.2.00.1006081953060.4506@i5.linux-foundation.org>
References: <alpine.DEB.2.00.1006090243360.1269@skynet.skynet.ie>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Jun 2010, Dave Airlie wrote:
> 
> So this pull does try and fix some problems in a feature we added in -rc1, 
> radeon power management, its either the voltage fixes in here, or just 
> remove voltage stuff completely, but since it works in some cases that 
> would be a regression in itself.

I'm going to take this and hope _really_ hard that it works - since the 
number of current radeon reports seems to mean that I pretty much have to 
take it.

But I want to protest that "regression in itself" statement. We do _not_ 
count new code that needs to be undone as a "regression". Otherwise we 
would be in the situation where "fix one bug, introduce another" could not 
be reverted, because reverting it would "regress" the bug that got fixed.

And in fact that's exactly _why_ we introduced the strict regression 
fixing policy, because we used to have these "one step forward, unknown 
number of steps back" dances especially in power management and ACPI. A 
patch fixed something, but broke some other machine, and people claimed it 
fixed more than it broke (which is an impossible statement to really 
quantify).

So new code simply doesn't matter. Reverting new code is never a 
regression, even if that new code made something work. It's _old_ working 
setups that matter from the regression standpoint.

		Linus
