Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab0LRSUf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 13:20:35 -0500
Received: from qmta11.westchester.pa.mail.comcast.net ([76.96.59.211]:39612
	"EHLO QMTA11.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932097Ab0LRSUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 13:20:34 -0500
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Dec 2010 13:20:34 EST
Date: Sat, 18 Dec 2010 13:14:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@saphir.localdomain
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: linux-pm@lists.linux-foundation.org, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [linux-pm] 2.6.37-rc5, pata_atiixp, DVD-ROM: kernel log flooded
 with "rpm_resume flags 0x4", "rpm_resume returns 1"
In-Reply-To: <20101217213034.7bf6587c@stein>
Message-ID: <Pine.LNX.4.44L0.1012181311570.3334-100000@saphir.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Dec 2010, Stefan Richter wrote:

> Well right --- hald polls the card reader for media change too.
> 
> I now noticed that the two lines
> 	sd *:0:0:0: rpm_resume flags 0x4
> 	sd *:0:0:0: rpm_resume returns 1
> are logged once for each sd device (i.e. those with fixed media too)
> at the startup of hald.  Is this expected?

I don't know anything about the details of hal.  But I do know that you
can tell hal not to poll certain devices.  Look at "man
hal-disable-polling".

> Note, I have not seen anything of the sort on another PC which runs
> 2.3.37-rc6 with the same PM debug options.  The differences are that
> the other PC is an Intel 945GM based one with x86-32 kernel and 32bit
> Gentoo userland, whereas the PC with log spam is an AMD RS780 based one
> with x86-64 kernel and 64bit Gentoo userland.  Both got hal 0.5.14-r2.

Maybe CONFIG_DYNAMIC_DEBUG is set differently, or userspace enables 
dynamic debugging of different subsystems.

Alan Stern

