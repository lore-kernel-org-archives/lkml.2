Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2AQUqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:46:09 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57796 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2AQUqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:46:07 -0500
Date: Tue, 17 Jan 2012 12:46:01 -0800 (PST)
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
In-Reply-To: <20120117142738.GB3188@turtle.usersys.redhat.com>
Message-ID: <alpine.DEB.2.00.1201171240070.2595@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com> <201201120918.53026.arnd@arndb.de> <20120112101805.GA2375@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com> <20120113085125.GA2452@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com> <20120113122202.GB2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com> <20120116091832.GA2401@turtle.usersys.redhat.com>
 <alpine.DEB.2.00.1201161521240.16270@chino.kir.corp.google.com> <20120117142738.GB3188@turtle.usersys.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012, Andrew Jones wrote:

> Now changing it, i.e. making it conform more closely to its name and only
> affect embedded related options, you can't do. If you were to do so, then
> you would lose backward compatibility. How do you know there aren't users
> that started using EMBEDDED for the non-embedded side effects?

That's why they're now using EXPERT.

> If EMBEDDED
> is ever corrected, and then stops selecting EXPERT, then you risk causing
> them problems.
> 

No, because they've already enabled EXPERT.  You can't have EMBEDDED=y and 
EXPERT=n.  That's what this little thing called "select" does.  After a 
sufficient amount of time passes and all options that are important only 
for embedded users have been either extended for EMBEDDED or replaced only 
be EMBEDDED, you can get rid of the "select" without losing backwards 
compatibility.
