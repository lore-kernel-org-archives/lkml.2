Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab2AMV1m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 16:27:42 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54042 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732Ab2AMV1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 16:27:40 -0500
Date: Fri, 13 Jan 2012 13:27:35 -0800 (PST)
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
In-Reply-To: <20120113122202.GB2452@turtle.usersys.redhat.com>
Message-ID: <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
References: <1326295008-29795-1-git-send-email-drjones@redhat.com> <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com> <201201120918.53026.arnd@arndb.de> <20120112101805.GA2375@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
 <20120113085125.GA2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com> <20120113122202.GB2452@turtle.usersys.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jan 2012, Andrew Jones wrote:

> > What would be helpful is if CONFIG_EMBEDDED actually meant what it 
> > implies, i.e. for config options that only make sense on embedded devices 
> > (similar to CONFIG_SMALLMEM I mentioned earlier, but more focused).
> 
> Agreed, but it's not the problem that this patch is attempting to solve.
> You and I are looking at this patch (and its predecessor 6a108a14fa35)
> from two different sides. I want CONFIG_EXPERT to work, and you want
> CONFIG_EMBEDDED to mean what it should. I'm saying that fixing EXPERT now,
> by reverting EMBEDDED back a bit, and then eventually fixing that later,
> is the better way to go. You're saying you don't want me to touch
> EMBEDDED, and thus far you've ignored the problem I'm attempting to solve.
> 

CONFIG_EXPERT does work, there haven't been problems reported with it in 
the year that it has been in the kernel, and CONFIG_EMBEDDED is available 
to be extended to have its logical semantics.  Right now, CONFIG_EMBEDDED 
is pretty useless other than setting CONFIG_EXPERT but that could easily 
be extended if someone wants to spend the time to separate options out 
from CONFIG_EXPERT that don't make any sense for embedded devices.  I'm 
not from the embedded world, so I don't know the problems they face when 
configuring the kernel.

> This patch is actually attempting to make progress in the separation of
> the semantics for EXPERT and the old, insane EMBEDDED, which had the very
> loose semantics. That's why it's called "untangle EXPERT and EMBEDDED".
> 

You can't responsibly untangle EXPERT and EMBEDDED without making EMBEDDED 
not select EXPERT and instead replace config options that should be 
configurable only on embedded devices to do "depends on EXPERT || 
EMBEDDED".  That's not what your patch does.

> > That's bogus, config EMBEDDED was used to select the new EXPERT so there 
> > was no backwards compatibility issue.  I'd agree with you that your patch 
> > would be backwards compatible and doesn't suddenly, and silently, lose 
> > config options that were previously enabled when running make oldconfig if 
> > everybody in the world used defconfigs.  That's not the case, which is why 
> > this is a non-starter.
> 
> The fact that this patch breaks backward compatibility is unfortunate, but
> the only way to fix the problem that it's attempting to fix, without that
> breakage, is to introduce yet another config option (EXPERT2 or
> REALLY_EXPERT?). If I'm not mistaken and config variable backward
> compliance isn't required, then I'd say breaking it makes much more sense
> then adding something like REALLY_EXPERT and all the mess that'll come
> with it.
> 

Breaking backwards compatibility for users who aren't defconfigs is a 
non-starter, as I've said.  Admitting that your patch does it is almost 
like nacking your own patch.
