Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab2ARJTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:19:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55247 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab2ARJTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:19:48 -0500
Date: Wed, 18 Jan 2012 01:19:44 -0800 (PST)
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
In-Reply-To: <20120118081455.GA2317@turtle.usersys.redhat.com>
Message-ID: <alpine.DEB.2.00.1201180113030.19730@chino.kir.corp.google.com>
References: <20120112101805.GA2375@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com> <20120113085125.GA2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
 <20120113122202.GB2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com> <20120116091832.GA2401@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201161521240.16270@chino.kir.corp.google.com> <20120117142738.GB3188@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201171240070.2595@chino.kir.corp.google.com> <20120118081455.GA2317@turtle.usersys.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jan 2012, Andrew Jones wrote:

> > > Now changing it, i.e. making it conform more closely to its name and only
> > > affect embedded related options, you can't do. If you were to do so, then
> > > you would lose backward compatibility. How do you know there aren't users
> > > that started using EMBEDDED for the non-embedded side effects?
> > 
> > That's why they're now using EXPERT.
> 
> How do you know they've all switched?
> 

Because existing CONFIG_EMBEDDED configs now automatically enable it since 
my patch was merged a year ago.  Users who haven't upgraded since then and 
run make oldconfig will do so in the future and we're not risking breaking 
backwards compatibility at least until a sufficient amount of time has 
passed.

> > No, because they've already enabled EXPERT.  You can't have EMBEDDED=y and 
> > EXPERT=n.  That's what this little thing called "select" does.  After a 
> > sufficient amount of time passes and all options that are important only 
> > for embedded users have been either extended for EMBEDDED or replaced only 
> > be EMBEDDED, you can get rid of the "select" without losing backwards 
> > compatibility.
> 
> How do you define a sufficient amount of time? How do you know everyone
> else agrees with that definition? OIOW, where is it documented? If it is
> documented, then how do you know everyone will read it and comply to it?
> 

An example: when I rewrote the kernel oom killer and deprecated 
/proc/pid/oom_adj, we did this:

 - mapped writes to oom_adj to the new tunable, oom_score_adj,

 - emitted a warning when userspace wrote to oom_adj a single time,

 - a year later, emitted a warning every time userspace writes to
   oom_adj, and

 - in September of 2012, the tunable will be removed entirely.

This gives userspace two years to covert before the tunable is dropped 
entirely.  We can't keep it around forever, but we're careful not to 
suddenly drop existing users without some due diligence.  It's added to 
Documentation/feature-removal-schedule.txt like all feature removals are.  
We can do no better without a huge maintenance burden.

We could add that CONFIG_EMBEDDED will stop automatically enabling 
CONFIG_EXPERT in January 2014 to 
Documentation/feature-removal-schedule.txt as well.  That certainly seems 
like a good idea.

However, we've now diverged entirely from your patch in this thread.
