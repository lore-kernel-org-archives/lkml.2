Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab2B0Fgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 00:36:42 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:52986 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811Ab2B0Fgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 00:36:41 -0500
Date: Sun, 26 Feb 2012 21:36:40 -0800 (PST)
From: Andrei Warkentin <awarkentin@vmware.com>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrei Warkentin <andreiw@vmware.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        Matt Mackall <mpm@selenic.com>,
        Andrei Warkentin <andrey.warkentin@gmail.com>
Message-ID: <310080656.1570547.1330321000661.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <116798.1330320543@turing-police.cc.vt.edu>
Subject: Re: [PATCHv3 2/3] NETKGDB: Ethernet/UDP/IP KDB transport.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.113.60.13]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - FF3.0 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Original Message -----
> From: "Valdis Kletnieks" <Valdis.Kletnieks@vt.edu>
> To: "Andrei Warkentin" <andrey.warkentin@gmail.com>
> Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, "Andrei Warkentin" <andreiw@vmware.com>,
> kgdb-bugreport@lists.sourceforge.net, "Jason Wessel" <jason.wessel@windriver.com>, "Matt Mackall" <mpm@selenic.com>
> Sent: Monday, February 27, 2012 12:29:03 AM
> Subject: Re: [PATCHv3 2/3] NETKGDB: Ethernet/UDP/IP KDB transport.
> 
> This *really* needs a discussion of the security implications of
> this.  Do
> you *really* want to have a kgdb that will accept connections from
> *anywhere*?
> Sounds like an insta-root waiting to happen.
> 

It does *really* need documentation. It's not meant for general purpose use.
Just like Android devices come with KDB compiled out, this shouldn't be
built in. That means that netkgdb should be default off and come with a
huge warning. It is insta-root. And that's the message it should carry with it.
It's no different from running kgdboc - anyone has root access if they press
Alt-PrtScrn-g, right?

> > +the assigned interface IP address changes. This makes it useful
> > +in an environment where it's not known ahead of time what computer
> > +will connect to perform the crash analysis.
> 
> Exactly. You don't know ahead of time who's going to connect. That's
> the
> problem...

It's not a problem unless you make it one. If I am running a private test farm
where I provision 250+ machines or VMs, and I have 10-15 devs that could possibly
investigate the issue, it's not realistic to know ahead of times what internal
IP address the connection could come from.

I will update the docs and the Kconfig (default=off). That should be
sufficient for PEBCAK failures.

Cheers,
A
