Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744Ab2ADSzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:55:51 -0500
Received: from relais.videotron.ca ([24.201.245.36]:36479 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab2ADSzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:55:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Wed, 04 Jan 2012 13:55:48 -0500 (EST)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: ZenIV (was: Re: Status of arm-soc.git for 3.2)
In-reply-to: <20120104181703.GA11810@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.02.1201041337370.2907@xanadu.home>
References: <201201032243.06440.arnd@arndb.de>
 <20120104100016.GK2914@n2100.arm.linux.org.uk>
 <20120104181703.GA11810@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jan 2012, Russell King - ARM Linux wrote:

> On Wed, Jan 04, 2012 at 10:00:16AM +0000, Russell King - ARM Linux wrote:
> > Now... as for ZenIV (the machine which publically hosts my git tree).  It's
> > developed a new problem over Christmas: apache has started regularly dying
> > in a way that's not been seen before:
> > [alert] (11)Resource temporarily unavailable: setuid: unable to change to uid: xx
> > [error] server reached MaxClients setting, consider raising the MaxClients setting
> > [alert] Child 17666 returned a Fatal error... Apache is exiting!
> > [emerg] (43)Identifier removed: couldn't grab the accept mutex
> > [emerg] (22)Invalid argument: couldn't grab the accept mutex
> > ...
> > I don't see any updates which would have caused this, so I'm going to put
> > it down to increased server load over the Christmas period, possibly again
> > caused by git's smart protocol being excessively resource intensive on the
> > machine.
> 
> I've just checked the machine this evening - I restarted it at 8:57 and
> it was dead again by 16:52.

As we discussed last month, ZenIV with its 2 GB of RAM is becoming 
underpowered for the task of serving the kernel Git tree.

> I've now disabled all access to my git tree there, and restarted apache.
> We will see whether that improves stability - I suspect it will do because
> I reckon that the problem is that the smart git stuff is what's killing
> the machine.

I'm sure that is the case.  However faulty hardware could still be the 
root cause, but without the load from Git the machine might become 
loaded lightly enough you might not see any ill effects before quite a 
while.

> I've no idea how the kernel.org folk manage to run any
> kind of service with this git stuff.

But they do quite well, which is the important point.

> If that resolves the problem, I'll re-enable access but with the "smart"
> stuff and gitweb disabled (I've seen gitweb taking ages accessing the
> tree as well.)

That's good for the other services that ZenIV is providing, but one of 
the most important service was certainly the publication of your Git 
tree.  This specific problem still is unresolved.

> I'm now convinced that git servers are only possible with 64-bit systems
> with some multiple of 16GB of RAM on them - which is not something that
> this machine can be.

If so I'd suggest you consider one of the hosting alternatives readily 
available to you for publishing your Git tree.  I'm sure any hurdle can 
be leveled out very quickly for the core ARM Linux repository.  I can 
certainly facilitate things if you wish.


Nicolas
