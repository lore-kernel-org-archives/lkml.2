Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab2APX2L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 18:28:11 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61747 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2APX2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 18:28:09 -0500
Date: Mon, 16 Jan 2012 15:28:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Jones <drjones@redhat.com>
cc: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org,
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
In-Reply-To: <20120116091832.GA2401@turtle.usersys.redhat.com>
Message-ID: <alpine.DEB.2.00.1201161521240.16270@chino.kir.corp.google.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com> <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com> <201201120918.53026.arnd@arndb.de> <20120112101805.GA2375@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
 <20120113085125.GA2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com> <20120113122202.GB2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
 <20120116091832.GA2401@turtle.usersys.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jan 2012, Andrew Jones wrote:

> > CONFIG_EXPERT does work, there haven't been problems reported with it in 
> > the year that it has been in the kernel, and CONFIG_EMBEDDED is available 
> > to be extended to have its logical semantics.  Right now, CONFIG_EMBEDDED 
> > is pretty useless other than setting CONFIG_EXPERT but that could easily 
> 
> Um? Isn't the whole point of me sending a patch because there's a problem?
> Thus THIS is problem report. Who else besides a kernel developer would
> even notice this problem? As you say, EMBEDDED does nothing more than
> select EXPERT, which does exactly the same thing as EMBEDDED did.

Except now it can be extended for its original semantics, as I've 
explained to you multiple times.

> Therefore to people using EMBEDDED there has been no change.

And that was intended to ensure backwards compatibility so users don't 
lose previously set config options if they aren't using a defconfig, which 
you've totally ignored.

> But what new
> users of EXPERT will there ever be as long EXPERT twists default config
> options?
> 

You may be underestimating how popular CONFIG_EXPERT is.

> > You can't responsibly untangle EXPERT and EMBEDDED without making EMBEDDED 
> > not select EXPERT and instead replace config options that should be 
> > configurable only on embedded devices to do "depends on EXPERT || 
> > EMBEDDED".  That's not what your patch does.
> 
> What? A dependency (or in this case a reverse dependency using select)
> does not mean the semantics of the options are tangled. EXPERT should be
> free of those old EMBEDDED semantics and do only one thing, expose expert
> options.

You're wrong, otherwise you BREAK OTHER PEOPLE'S CONFIGURATIONS SILENTLY.  
It's a non-starter.

> EMBEDDED can then select it or not, I don't care. As for your
> example "depends on EXPERT || EMBEDDED", that doesn't matter to me either.

That's the only way you can extend CONFIG_EMBEDDED to actually mean 
something and is exactly what we wanted to do when the patch was merged: 
allow it to identify options that embedded users will want to configure 
without exposing all of CONFIG_EXPERT.

> > Breaking backwards compatibility for users who aren't defconfigs is a 
> > non-starter, as I've said.  Admitting that your patch does it is almost 
> > like nacking your own patch.
> 
> Like I said (twice), afaik config options aren't in the ABI that we must
> maintain. They're internal to the kernel. While it's nice to keep them the
> same, in order to save people some effort, it's not required.

It's concerning that you choose to hack on the kernel and have such a 
reckless attitude for users who choose not to use defconfigs and its even 
more concerning that you don't care that they'll now silently lose config 
options next time they run make oldconfig with your patch.

> This is a trivial patch for an obvious problem. In all the emails that
> we've exchanged you haven't told me anything I didn't know before posting.

If you knew you were breaking users, then you're just reckless and I want 
no part of it.

Nacked-by: David Rientjes <rientjes@google.com>
