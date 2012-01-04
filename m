Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab2ADSRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:17:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55809 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2ADSRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:17:17 -0500
Date: Wed, 4 Jan 2012 18:17:03 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@fluxnic.net>
Subject: ZenIV (was: Re: Status of arm-soc.git for 3.2)
Message-ID: <20120104181703.GA11810@n2100.arm.linux.org.uk>
References: <201201032243.06440.arnd@arndb.de> <20120104100016.GK2914@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104100016.GK2914@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 10:00:16AM +0000, Russell King - ARM Linux wrote:
> Now... as for ZenIV (the machine which publically hosts my git tree).  It's
> developed a new problem over Christmas: apache has started regularly dying
> in a way that's not been seen before:
> [alert] (11)Resource temporarily unavailable: setuid: unable to change to uid: xx
> [error] server reached MaxClients setting, consider raising the MaxClients setting
> [alert] Child 17666 returned a Fatal error... Apache is exiting!
> [emerg] (43)Identifier removed: couldn't grab the accept mutex
> [emerg] (22)Invalid argument: couldn't grab the accept mutex
> ...
> I don't see any updates which would have caused this, so I'm going to put
> it down to increased server load over the Christmas period, possibly again
> caused by git's smart protocol being excessively resource intensive on the
> machine.

I've just checked the machine this evening - I restarted it at 8:57 and
it was dead again by 16:52.

I've now disabled all access to my git tree there, and restarted apache.
We will see whether that improves stability - I suspect it will do because
I reckon that the problem is that the smart git stuff is what's killing
the machine.  I've no idea how the kernel.org folk manage to run any
kind of service with this git stuff.

If that resolves the problem, I'll re-enable access but with the "smart"
stuff and gitweb disabled (I've seen gitweb taking ages accessing the
tree as well.)

I'm now convinced that git servers are only possible with 64-bit systems
with some multiple of 16GB of RAM on them - which is not something that
this machine can be.
