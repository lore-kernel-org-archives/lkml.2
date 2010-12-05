Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab0LESkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 13:40:39 -0500
Received: from void.printf.net ([89.145.121.20]:49568 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab0LESki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 13:40:38 -0500
Date: Sun, 5 Dec 2010 18:40:31 +0000
From: Chris Ball <cjb@laptop.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Philip Rakity <prakity@marvell.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aries Lee <arieslee@jmicron.com>
Subject: Re: [PATCH 2/2] mmc: Test bus-width for old MMC devices
Message-ID: <20101205184031.GA30957@void.printf.net>
References: <1290579674-4616-1-git-send-email-tiwai@suse.de> <1290579674-4616-3-git-send-email-tiwai@suse.de> <20101205040221.GA24547@void.printf.net> <s5h1v5wv6gv.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h1v5wv6gv.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi, Philip,

On Sun, Dec 05, 2010 at 11:50:40AM +0100, Takashi Iwai wrote:
> > I'm planning on taking Takashi's since it looks a little cleaner; Philip,
> > please could you take a look at Takashi's patch and add anything you
> > think should be present from your own patch as a new incremental patch?
> 
> One missing thing in my (originally Aries') patch is the quirk bit to
> enable/disable the bus-width test.  In Philip's latest patch, the
> default is off.
> 
> I'm also not sure whether this bus-width test should be enabled as
> default.  I guess it's better for performance, so I'd vote for turning
> on as default.  But, having a quirk for turning off would be safer for
> working around old hardware problems, of course.

Sounds good, although we're trying hard not to add new quirk bits.
I don't see a way around doing that here, though.

We've got plenty of time until the .38 release -- let's turn it on by
default and test during .38-rc, and we can revisit whether to leave it
on closer to the release.  It's not as simple as "turning it on could
cause problems so let's not do that", because we're *already* seeing
problems from things like enabling 8-bit width on setups that don't
support it.

Thanks!

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
