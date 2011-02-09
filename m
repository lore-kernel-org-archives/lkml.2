Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab1BIWhX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:37:23 -0500
Received: from brother.balabit.com ([195.70.62.219]:49996 "EHLO
	lists.balabit.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab1BIWhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:37:22 -0500
Subject: Re: CAP_SYSLOG, 2.6.38 and user space
From: Gergely Nagy <algernon@balabit.hu>
To: david@lang.hm
Cc: "Serge E. Hallyn" <serge@hallyn.com>, James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1102091425040.1472@asgard.lang.hm>
References: <1296733177.14846.26.camel@moria>
	 <20110203153252.GA24153@mail.hallyn.com>
	 <20110204160513.GB17396@mail.hallyn.com> <1296837186.24742.15.camel@moria>
	 <20110204171502.GA24226@mail.hallyn.com>
	 <alpine.DEB.2.00.1102042301420.8162@asgard.lang.hm>
	 <20110206011831.GB15805@mail.hallyn.com>
	 <20110209212329.GA24777@mail.hallyn.com>
	 <1297286934.13055.57.camel@luthien.mhp>
	 <alpine.DEB.2.00.1102091333370.1472@asgard.lang.hm>
	 <1297287604.13055.65.camel@luthien.mhp>
	 <alpine.DEB.2.00.1102091344410.1472@asgard.lang.hm>
	 <1297289098.13055.74.camel@luthien.mhp>
	 <alpine.DEB.2.00.1102091425040.1472@asgard.lang.hm>
Content-Type: text/plain; charset="UTF-8"
Organization: BalaBit
Date: Wed, 09 Feb 2011 23:37:19 +0100
Message-ID: <1297291039.13055.88.camel@luthien.mhp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> what's wrong with doing a runtime test at startup that tries to read with 
> CAP_SYS_ADMIN and if you get -EPERM trying again with CAP_SYSLOG?

That's also an option I considered, and might end up doing if there's no
easier option.  In my case, though, due to the design of the code, it's
not trivially simple to do that (it isn't particularly hard, either, but
such a test wouldn't be my first choice).

> creating an ioctl for something like this seems like it's significantly 
> overcomplicating the issue.

True.

Nevertheless, like I said before: my main concern is making sure
userspace doesn't break. Figuring out how to support CAP_SYSLOG best is
a much lower priority on my list, and I haven't given it all that much
thought.

I'd prefer an ioctl or something similar which I can easily query,
without having to resort to trial and error or version sniffing. But I
understand that's not the best option from a kernel PoV, so falling back
to trying to read at startup is an acceptable solution aswell.

So, yeah... I suppose simply introducing CAP_SYSLOG, and keeping
CAP_SYS_ADMIN as it is would work just fine.

-- 
|8]



