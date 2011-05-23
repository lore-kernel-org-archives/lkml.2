Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1EWXBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 19:01:24 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51729 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755000Ab1EWXBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 19:01:22 -0400
X-Sasl-enc: xKvXdS+ncz26oNmBPbw2jYPzWGnU2HZBgpDNz9WD6Rvm 1306191680
Date: Mon, 23 May 2011 16:00:33 -0700
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org
Subject: Re: [GIT PATCH] STAGING pull for .40
Message-ID: <20110523230033.GA26471@kroah.com>
References: <20110523193855.GA20384@kroah.com>
 <BANLkTi=vUXOfZ57CT7CtAjOzYReBnp=Vvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=vUXOfZ57CT7CtAjOzYReBnp=Vvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 01:43:13PM -0700, Linus Torvalds wrote:
> On Mon, May 23, 2011 at 12:38 PM, Greg KH <greg@kroah.com> wrote:
> > Here is the big pull request for the staging tree for your .40 tree (or
> > 2.8.0, whatever you are wanting to rename it to.)
> 
> Hmm. Doing my once-a-release "try to compile everything in staging
> after pulling from greg by using allyesconfig and also forcing all
> staging",

Ugh, I keep only testing 'allmodconfig' with all staging drivers, I'll
add this to my test build setup from now on.

> I get this:
> 
>   drivers/staging/brcm80211/brcmsmac/built-in.o:(.data+0xba0):
> multiple definition of `wl_msg_level'
>   drivers/staging/brcm80211/brcmfmac/built-in.o:(.data+0x1a94): first
> defined here
> 
> which looks like another case of "can't compile two things both into
> the kernel".
> 
> Looks like the BRCMSMAC / BRCMFMAC drivers need to be mutually
> exclusive. Something like
> 
>   depends on m || (BRCMSMAC != y)
> 
> for BRCMFMAC?
> 
> Or they should just avoid using the same globally visible name.

Both probably.  I'll fix this up for the next set of staging fixes after
you release -rc1.

thanks,

greg k-h
