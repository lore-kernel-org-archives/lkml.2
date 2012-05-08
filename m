Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab2EHPt3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:49:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:32047 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab2EHPt1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:49:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150566526"
Date: Tue, 8 May 2012 17:04:42 +0100
From: Alan Cox <alan@linux.intel.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: Regression due to d29f3ef "tty_lock: Localise the lock"
Message-ID: <20120508170442.409ccbe4@bob.linux.org.uk>
In-Reply-To: <4FA93FEB.2060200@wwwdotorg.org>
References: <4FA8557E.5080402@wwwdotorg.org>
	<20120508103512.42db1c4b@pyramind.ukuu.org.uk>
	<4FA93FEB.2060200@wwwdotorg.org>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 May 2012 09:46:51 -0600
Stephen Warren <swarren@wwwdotorg.org> wrote:

> On 05/08/2012 03:35 AM, Alan Cox wrote:
> > On Mon, 07 May 2012 17:06:38 -0600
> > Stephen Warren <swarren@wwwdotorg.org> wrote:
> > 
> >> Alan,
> >>
> >> Commit d29f3ef "tty_lock: Localise the lock" appears to cause a
> >> problem for me.
> >>
> >> With this commit (as in next-20120507), I can no longer log into my
> >> system (NVIDIA Tegra device with ARM CPU) over the serial console,
> >> since the login prompt no longer appears. If I wait a few minutes,
> >> I see the following console spew:
> > 
> > Eep. If it's reproducable can you test whether adding the
> > unlock/relock in drivers/tty/pty.c does the trick ?
> > 
> > ie:
> > 	tty_unlock(tty);
> > 	tty_vhangup(tty);
> > 	tty_lock(tty);
> 
> Yes, that change in pty_close() solves the problem.

Ok Greg - I think we should go with putting that unlock back until we
understand exactly what is going on.

Alan
