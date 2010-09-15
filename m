Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab0IOXLI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 19:11:08 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:33412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab0IOXLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 19:11:05 -0400
Subject: Re: [vendor-sec] [PATCH] wireless: fix 64K kernel heap content
 leak via ioctl
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>, Joe Perches <joe@perches.com>,
        Jean Tourrilhes <jt@hpl.hp.com>, Tejun Heo <tj@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20100915224836.GF19835@kroah.com>
References: <20100827210240.GC4703@outflux.net>
	 <20100915224836.GF19835@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 01:11:07 +0200
Message-ID: <1284592267.3707.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-15 at 15:48 -0700, Greg KH wrote:
> On Fri, Aug 27, 2010 at 02:02:41PM -0700, Kees Cook wrote:
> > This problem was originally tracked down by Brad Spengler.
> > 
> > When calling wireless ioctls, if a driver does not correctly
> > validate/shrink iwp->length, the resulting copy_to_user can leak up to
> > 64K of kernel heap contents.
> > 
> > It seems that this is triggerable[1] in 2.6.32 at least on ath5k, but
> > I was not able to track down how. The twisty maze of ioctl handlers
> > stumped me. :) Other drivers I checked did not appear to have any problems,
> > but the potential remains. I'm not sure if this patch is the right approach;
> > it was fixed differently[2] in grsecurity.
> > 
> > [1] http://forums.grsecurity.net/viewtopic.php?f=3&t=2290&start=0
> > [2] http://grsecurity.net/~spender/wireless-infoleak-fix2.patch
> 
> Is this fixed differently upstream in the kernel with commit id
> 42da2f948d949efd0111309f5827bf0298bcc9a4?

Yes, that's the fix for this.

johannes

