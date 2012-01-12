Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2ALL26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 06:28:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab2ALL2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 06:28:54 -0500
Date: Thu, 12 Jan 2012 11:18:06 +0100
From: Andrew Jones <drjones@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Rientjes <rientjes@google.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, mingo@elte.hu, david.woodhouse@intel.com,
        gregkh@suse.de, davem@davemloft.net, axboe@kernel.dk, holt@sgi.com,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        hskinnemoen@gmail.com, egtvedt@samfundet.no, msalter@redhat.com,
        a-jacquiot@ti.com, starvik@axis.com, jesper.nilsson@axis.com,
        dhowells@redhat.com, takata@linux-m32r.org, geert@linux-m68k.org,
        yasutake.koichi@jp.panasonic.com, jonas@southpole.se, kyle@mcmartin.ca,
        deller@gmx.de, jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
Message-ID: <20120112101805.GA2375@turtle.usersys.redhat.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com>
 <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com>
 <201201120918.53026.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201120918.53026.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 09:18:52AM +0000, Arnd Bergmann wrote:
> On Wednesday 11 January 2012, David Rientjes wrote:
> > We discussed this when the patch was made to change EMBEDDED to EXPERT and 
> > we knew that things like CONFIG_SLOB exist that would only make sense on a 
> > platform with a very small memory footprint.  So what criteria are you 
> > using to determine what makes sense for EMBEDDED or not and what would be 
> > generally useful for platforms with very small memory footprints?
> > 
> > I would think that something like CONFIG_SMALLMEM would identify those 
> > candidates (for things like SLOB) and then you could separate the rest 
> > based on the platform they exist for since you're essentially introducing 
> > a new config symbol here that existed in the past but are now using it 
> > with different semantics.

No, I'm putting EMBEDDED back to work doing the same thing it did before,
i.e. the semantics for it are the same as they were before 6a108a14fa35.
This is not a revert of that patch though. I'm keeping EXPERT, but
ensuring it doesn't do everything EMBEDDED used to do. I'm ensuring it
only does what it advertises it does, which is to give a useful configmenu
cleanup symbol to the whole kernel.

> 
> The CONFIG_SMALLMEM would also require people to know what they are doing,
> beyond what we expect the average person building a kernel to, which is
> just what CONFIG_EXPERT means, and the same reason why we ended up renaming
> CONFIG_EMBEDDED to CONFIG_EXPERT. People have a very different understanding
> of what "embedded" actually means, and not all of those require small
> memory footprint or even a custom kernel. Let's just stay with CONFIG_EXPERT.

For the SLOB example, and everything else that is 'if EXPERT' after
6a108a14fa35, then don't worry, they are still 'if EXPERT'. See the patch.

I chose EMBEDDED to handle the side effects, simply because it used to
anyway. I think it's best that I leave any further customizing, such as
replacing EMBEDDED with SMALLMEM for particular options, to those that are
more familiar with those options. I can conceive of people wanting EXPERT
-> SMALLMEM -> SLOB type menus, but that's not in the scope of this patch.

Drew
