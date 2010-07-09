Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758996Ab0GIAeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 20:34:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59813 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939Ab0GIAeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 20:34:14 -0400
Date: Fri, 9 Jul 2010 02:34:09 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, Daniel Kiper <dkiper@net-space.pl>,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] Re: GSoC 2010 - Migration from memory ballooning
 to	memory hotplug in Xen
Message-ID: <20100709003409.GC15950@basil.fritz.box>
References: <20100708194553.GA30124@router-fw-old.local.net-space.pl>
 <871vbdr4ey.fsf@basil.nowhere.org>
 <4C36648F.6020006@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C36648F.6020006@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes.  Another approach would be to fiddle with the E820 maps early at
> boot to add more RAM, but then early_reserve it and hand it over to the
> control of the balloon driver.  But it does mean you need to statically
> come up with the max ever at boot time.

You need to do that too for memory hotadd -- you need predeclared
hotadd regions. Linux mainly needs it to know in which node
to put the memory. Other OS use it for other things too.

> > The only advantage of using memory hotadd is that the mem_map doesn't
> > need to be pre-allocated, but that's only a few percent of the memory.
> >
> > So it would only help if you want to add gigantic amounts of memory
> > to a VM (like >20-30x of what it already has).
> >   
> 
> That's not wildly unreasonable on the face of it; consider a domain
> which starts at 1GB but could go up to 32GB as demand requires.  But

The programs which need 32GB will probably not even start in 1GB :)

> > One trap is also that memory hotadd is a frequent source of regressions,
> > so you'll likely run into existing bugs.
> 
> That could be painful, but I expect the main reason for regressions is
> that the code is fairly underused.  Adding new users should help.

Yes, and we fixed a lot of the bugs, but still a lot of them 
were tricky and frankly new ones might be too difficult for a SoC.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
