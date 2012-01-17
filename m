Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2AQOaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:30:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163Ab2AQOad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:30:33 -0500
Date: Tue, 17 Jan 2012 15:27:39 +0100
From: Andrew Jones <drjones@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org,
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
Message-ID: <20120117142738.GB3188@turtle.usersys.redhat.com>
References: <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com>
 <201201120918.53026.arnd@arndb.de>
 <20120112101805.GA2375@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com>
 <20120113085125.GA2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com>
 <20120113122202.GB2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
 <20120116091832.GA2401@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201161521240.16270@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1201161521240.16270@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 16, 2012 at 03:28:02PM -0800, David Rientjes wrote:
> > even notice this problem? As you say, EMBEDDED does nothing more than
> > select EXPERT, which does exactly the same thing as EMBEDDED did.
> 
> Except now it can be extended for its original semantics, as I've 
> explained to you multiple times.

Extend yes, but you could have done that without introducing EXPERT. To
extend you simply use it in more places.

Now changing it, i.e. making it conform more closely to its name and only
affect embedded related options, you can't do. If you were to do so, then
you would lose backward compatibility. How do you know there aren't users
that started using EMBEDDED for the non-embedded side effects? If EMBEDDED
is ever corrected, and then stops selecting EXPERT, then you risk causing
them problems.

If you didn't catch the irony in the last paragraph, then please read it
again.

> You may be underestimating how popular CONFIG_EXPERT is.

I doubt it. I don't doubt that it's used through EMBEDDED. EMBEDDED has
been around a long time, so is likely widely used. Since EMBEDDED is used,
then yes, EXPERT is used (EMBEDDED selects EXPERT). However, I really
doubt anybody has opted to use EXPERT by itself for the purpose advertised
in its help text. If they had, then they very likely would have complained
about it turning off default values, and/or they would have posted a patch
very similar to this one. Hint, I wanted to use EXPERT, but immediately
discovered that it's broken, and then immediately posted this patch.

> That's the only way you can extend CONFIG_EMBEDDED to actually mean 
> something and is exactly what we wanted to do when the patch was merged: 
> allow it to identify options that embedded users will want to configure 
> without exposing all of CONFIG_EXPERT.

Fine. It's not in the scope of this patch.

> more concerning that you don't care that they'll now silently lose config 
> options next time they run make oldconfig with your patch.

If they have CONFIG_EMBEDDED=y, then nothing changes for them. If they
only have CONFIG_EXPERT=y, then they *DON'T* silently lose config options
*ANYMORE*. This patch fixes that silent disabling of options!

