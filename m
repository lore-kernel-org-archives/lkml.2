Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab0FCEpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:45:34 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:27641 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751325Ab0FCEpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:45:31 -0400
Date: Thu, 3 Jun 2010 05:45:12 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
       Daniel Walker <dwalker@codeaurora.org>, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org
Subject: Re: [GIT PULL] ARM MSM updates for 2.6.35-rc1
Message-ID: <20100603044512.GA22906@fluff.org.uk>
References: <1274997173.10998.21.camel@c-dwalke-linux.qualcomm.com>
 <1275511857.27006.6.camel@c-dwalke-linux.qualcomm.com>
 <alpine.LFD.2.00.1006021413100.8175@i5.linux-foundation.org>
 <87d3w9582z.fsf@deeprootsystems.com>
 <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006021803350.8175@i5.linux-foundation.org>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 06:20:09PM -0700, Linus Torvalds wrote:
> 
>    am, but I'm willing to do it only if I have a feeling that things are 
>    under control. And I'm not getting that feeling.
> 
>  - TWO HUNDRED THOUSAND lines of arch/arm is just pure garbage, namely the 
>    defconfig files. Quite frankly, anybody who calls that anything but 
>    pure "noise" is just misguided and being stupid.
> 
> So yes, I do consider a lot of it "noise". When there's two hundred 
> thousand lines of garbage, and it keeps growing without bounds, something 
> needs to be done. 
> 
> Now, I'm actually considering just getting rid of all the 'defconfig' 
> files entirely. The x86 model is sane (there's two of them, nobody likely 
> uses them), but ARM and POWERPC (and to a lesser config SH and MIPS) have 
> turned the whole concept into a disgusting mess. 
> 
> But while POWERPC has abused that thing too, in _other_ respects it has 
> been much less egregious. 

unfortunately there are so many different variants of the ARM
architecture that these defconfigs spring up to ensure that a base
compile for each one of them is performed. We run an autobuild which
runs through all these defconfigs and produces a report of what
happened to allow tracking of build regressions at the moment.
 
> So I can largely fix the defconfig mess on my own (by just using a simple 
> oneliner shell script to deletes them all) but that really only fixes one 
> particularly annoying symptom - not the underlying issue. We do need 
> somebody to maintain the arm platform mess, and actually tries to get some 
> infrastructure or something in place so that it doesn't explode.

Someone should defiently cull the older defconfigs for sepcific
machines, many of which probably don't get built for mainline.
~ 
> > The fact is that ARM-based devices multiply like rabbits, and there is
> > a huge amount of diversity between the various derivatives.  Also,
> > support most of these devices has lived out of tree for a long time.
> > Now that we have a relatively direct path which doesn't require any
> > single person to have to understand all the mind-numbing details of
> > all of these ARM-based platforms, it has allowed us to significantly
> > improve the support for these devices upstream.  Anything that is
> > common to all devices still goes through RMK.
> 
> The thing is, I bet there is way more commonality still to be taken 
> advantage of.  And even if there isn't, we need somebody who cares, and 
> doesn't just mindlessly aggregate all the crud. Somebody with the taste to 
> say "ok, that's just too effin ugly, you need to fix things up" 
> occasionally.

yes, there is that problem, and many of the big company players have
yet to really see the necessity in this... It has taken a while now to
convince the necessary people at Samsung that simply copying and
modifying existing driver/support is simply not going to fly.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
